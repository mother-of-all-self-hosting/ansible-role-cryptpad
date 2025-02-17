<!--
SPDX-FileCopyrightText: 2023 Julian-Samuel Gebühr
SPDX-FileCopyrightText: 2025 Suguru Hirahara

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Cryptpad Ansible role

[![REUSE status](https://api.reuse.software/badge/github.com/mother-of-all-self-hosting/ansible-role-cryptpad)](https://api.reuse.software/info/github.com/mother-of-all-self-hosting/ansible-role-cryptpad)

This is an [Ansible](https://www.ansible.com/) role which installs [Cryptpad](https://cryptpad.org/) to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

This role *implicitly* depends on:

- [`com.devture.ansible.role.systemd_docker_base`](https://github.com/devture/com.devture.ansible.role.systemd_docker_base)

For an Ansible playbook which integrates this role and makes it easier to use, see the [mash-playbook](https://github.com/mother-of-all-self-hosting/mash-playbook).
