#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Slavi Pantaleev
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Exercises bin/compute-next-tag.sh against throwaway git repositories.
#
# Usage: bin/test-compute-next-tag.sh
#
# Every scenario creates a repository in a temporary directory, gives it role
# files and a release history, and then replays a series of merges through the
# real script, tagging as it goes just like the autotag workflow does. This
# repository is never touched and no network access is needed.

set -euo pipefail

script_under_test="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/compute-next-tag.sh"

failures=0
workdir=''

cleanup() {
	cd /
	if [ -n "$workdir" ]; then
		rm -rf "$workdir"
		workdir=''
	fi
}

trap cleanup EXIT

# The Renovate annotation and the derived variables are part of the fixture on
# purpose: `cryptpad_version` is the only leaf value in this block, and the
# lines around it are the ones a careless pattern would pick up instead - the
# annotation names a version-looking dependency, and three other variables have
# names ending in `_version` or hold the version behind a Jinja expression.
write_defaults() {
	cat > defaults/main.yml <<-'EOF'
		# renovate: datasource=docker depName=cryptpad/cryptpad
		cryptpad_version: 2026.5.1

		cryptpad_container_image: "{{ cryptpad_container_image_registry_prefix }}cryptpad/cryptpad:{{ cryptpad_container_image_tag }}"
		cryptpad_container_image_tag: "version-{{ cryptpad_version }}"
		cryptpad_container_image_registry_prefix_upstream_default: docker.io/

		cryptpad_container_image_self_build_name: "cryptpad/cryptpad:{{ cryptpad_container_image_self_build_repo_version }}"
		cryptpad_container_image_self_build_repo_version: "{{ cryptpad_version if cryptpad_version != 'latest' else 'main' }}"
	EOF
}

# Starts a scenario with a repository at CryptPad 2026.5.1 which has already
# seen two releases of it (v2026.5.1-0 and v2026.5.1-1).
scenario() {
	echo "$1"

	cleanup
	workdir="$(mktemp -d)"

	mkdir -p "$workdir/bin" "$workdir/defaults" "$workdir/tasks" "$workdir/templates"
	cp "$script_under_test" "$workdir/bin/"
	cd "$workdir"

	git init -q -b main .
	git config user.email 'test@example.com'
	git config user.name 'Test'
	git config commit.gpgsign false

	write_defaults
	printf 'placeholder\n' > tasks/main.yml
	printf 'placeholder\n' > templates/env.j2
	printf 'placeholder\n' > README.md

	git add -A
	git commit -qm 'Initial commit'

	local release_number
	for release_number in 0 1; do
		git tag "v2026.5.1-$release_number"
	done
}

# Applies a change, commits it, and tags whatever the script says it should be.
# Prints the tag, or nothing when the script decided against a release.
merge() {
	local change="$1" tag

	eval "$change"
	git add -A
	git commit -qm 'Merge'

	tag="$(bin/compute-next-tag.sh 2>/dev/null)"

	if [ -n "$tag" ]; then
		git tag "$tag"
	fi

	printf '%s' "$tag"
}

expect() {
	local description="$1" expected="$2" actual="$3"

	if [ "$actual" = "$expected" ]; then
		printf '  ok   | %s -> %s\n' "$description" "${actual:-no release}"
	else
		printf '  FAIL | %s -> expected %s, got %s\n' "$description" "${expected:-no release}" "${actual:-no release}"
		failures=$((failures + 1))
	fi
}

bump_version="sed -i 's|^cryptpad_version: 2026.5.1|cryptpad_version: 2026.6.0|' defaults/main.yml"
revert_version="sed -i 's|^cryptpad_version: 2026.6.0|cryptpad_version: 2026.5.1|' defaults/main.yml"
prefix_version="sed -i 's|^cryptpad_version: 2026.5.1|cryptpad_version: v2026.6.0|' defaults/main.yml"
edit_registry="sed -i 's|docker.io/|registry.example.com/|' defaults/main.yml"
edit_task="printf 'a task\n' >> tasks/main.yml"
edit_template="printf 'a line\n' >> templates/env.j2"
edit_readme="printf 'documentation\n' >> README.md"
edit_script="printf '# a comment\n' >> bin/compute-next-tag.sh"

# The two merge orders below apply the same updates and must each end up with
# every update released exactly once, whichever order they arrive in.

scenario 'A version bump merged before other role changes'
expect 'version bump' v2026.6.0-0 "$(merge "$bump_version")"
expect 'task edit'    v2026.6.0-1 "$(merge "$edit_task")"
expect 'template'     v2026.6.0-2 "$(merge "$edit_template")"

scenario 'A version bump merged after other role changes'
expect 'task edit'    v2026.5.1-2 "$(merge "$edit_task")"
expect 'version bump' v2026.6.0-0 "$(merge "$bump_version")"

scenario 'Commits that do not affect the role'
expect 'README'   ''            "$(merge "$edit_readme")"
expect 'a script' ''            "$(merge "$edit_script")"
expect 'a task'   v2026.5.1-2   "$(merge "$edit_task")"

scenario 'Release numbers past 9'
for release_number in 2 3 4 5 6 7 8 9 10; do
	git tag "v2026.5.1-$release_number"
done
expect 'a task' v2026.5.1-11 "$(merge "$edit_task")"

scenario 'Reverting to an already released version'
merge "$bump_version" > /dev/null
# The role is now identical to what v2026.5.1-1 already published, so there is
# nothing new to release.
expect 'a revert' ''          "$(merge "$revert_version")"

scenario 'Reverting to an already released version, with a change'
merge "$bump_version" > /dev/null
expect 'a revert' v2026.5.1-2 "$(merge "$revert_version && $edit_task")"

scenario 'A version value carrying a leading v does not double it in the tag'
expect 'version bump' v2026.6.0-0 "$(merge "$prefix_version")"

# Editing a variable that is derived from `cryptpad_version` must release the
# version `cryptpad_version` still holds. A pattern that latched onto
# `cryptpad_container_image_tag` instead would try to release something like
# `vversion-{{ cryptpad_version }}-0` here.
scenario 'A derived variable is not mistaken for the version'
expect 'registry prefix' v2026.5.1-2 "$(merge "$edit_registry")"

if [ "$failures" -gt 0 ]; then
	echo >&2 "$failures scenario(s) behaved unexpectedly"
	exit 1
fi

echo 'All scenarios behaved as expected'
