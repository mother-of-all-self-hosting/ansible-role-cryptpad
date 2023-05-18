# Cryptpad Ansible role

This is an [Ansible](https://www.ansible.com/) role which installs [Cryptpad](https://cryptpad.org/) to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

It utilizes the [community built docker images](https://github.com/xwiki-labs/cryptpad-docker#cryptpad-proxied-by-nginx).

This role *implicitly* depends on:

- [`com.devture.ansible.role.systemd_docker_base`](https://github.com/devture/com.devture.ansible.role.systemd_docker_base)
- 
For an Ansible playbook which integrates this role and makes it easier to use, see the [mash-playbook](https://github.com/mother-of-all-self-hosting/mash-playbook).
