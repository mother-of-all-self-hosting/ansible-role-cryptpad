<!--
SPDX-FileCopyrightText: 2023 Julian-Samuel Gebühr
SPDX-FileCopyrightText: 2025, 2026 Suguru Hirahara

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# CryptPad Ansible role

[![REUSE status](https://api.reuse.software/badge/github.com/mother-of-all-self-hosting/ansible-role-cryptpad)](https://api.reuse.software/info/github.com/mother-of-all-self-hosting/ansible-role-cryptpad)

This is an [Ansible](https://www.ansible.com/) role which installs [CryptPad](https://cryptpad.org) to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

This role *implicitly* depends on:

- [`com.devture.ansible.role.systemd_docker_base`](https://github.com/devture/com.devture.ansible.role.systemd_docker_base)

Check [`defaults/main.yml`](defaults/main.yml) for the full list of supported options. Refer to [this page](docs/configuring-cryptpad.md) for details about setting up the service with this role.

💡 For an Ansible playbook which integrates this role and makes it easier to use, see the [Mother-of-All-Self-Hosting Ansible playbook](https://radicle.network/nodes/progressiv.radicle.garden/rad%3Az2SXkaceJw3YmS89T1xGysnFSjWsw).

## Development

### Collaborating on Radicle

This role is developed and distributed on Radicle, and you can freely open an issue or a "patch" for updating it.

Please follow [this "Getting Started" guide](https://radicle.dev/guides/quick-start) on the official documentation for the basic installation and usage of the Radicle toolchain.

You can clone the repository by running the command below:

```sh
rad clone rad:z38Yp2e9yFouswvrnX5MdgZYaViLb
```

💡 When you only want to "seed" a repository and have no interest in contributing code, you can still be a repository’s friend with the `rad seed` command. This is Radicle’s version of a ⭐ *star* or 👍 *like*, where you care by sharing it with others on the network.

### pre-commit

You can optionally install a Git pre-commit hook (via [mise](https://mise.jdx.dev/) + [prek](https://prek.j178.dev/)) that runs formatting and linting checks before each commit. See [`.pre-commit-config.yaml`](./.pre-commit-config.yaml) for which hooks are to be executed.

To install the hook, run the [`just`](https://github.com/casey/just) command below:

```sh
just prek-install-git-pre-commit-hook
```

### Molecule

This role supports [Molecule](https://docs.ansible.com/projects/molecule/), an Ansible testing framework designed for developing and testing Ansible collections, playbooks, and roles.

Refer to [this page](./molecule/README.md) for details about how to utilize it.
