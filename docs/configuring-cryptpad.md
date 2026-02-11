<!--
SPDX-FileCopyrightText: 2020 Aaron Raimist
SPDX-FileCopyrightText: 2020 Chris van Dijk
SPDX-FileCopyrightText: 2020 Dominik Zajac
SPDX-FileCopyrightText: 2020 Mickaël Cornière
SPDX-FileCopyrightText: 2020-2024 MDAD project contributors
SPDX-FileCopyrightText: 2020-2024 Slavi Pantaleev
SPDX-FileCopyrightText: 2022 François Darveau
SPDX-FileCopyrightText: 2022 Julian Foad
SPDX-FileCopyrightText: 2022 Warren Bailey
SPDX-FileCopyrightText: 2023 Antonis Christofides
SPDX-FileCopyrightText: 2023 Felix Stupp
SPDX-FileCopyrightText: 2023 Pierre 'McFly' Marty
SPDX-FileCopyrightText: 2024-2026 Suguru Hirahara

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Setting up CryptPad

This is an [Ansible](https://www.ansible.com/) role which installs [CryptPad](https://cryptpad.org) to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

CryptPad is a free and open-source collaboration suite that is end-to-end encrypted.

See the project's [documentation](https://docs.cryptpad.org) to learn what CryptPad does and why it might be useful to you.

## Adjusting the playbook configuration

To enable CryptPad with this role, add the following configuration to your `vars.yml` file.

**Note**: the path should be something like `inventory/host_vars/mash.example.com/vars.yml` if you use the [MASH Ansible playbook](https://github.com/mother-of-all-self-hosting/mash-playbook).

```yaml
########################################################################
#                                                                      #
# cryptpad                                                             #
#                                                                      #
########################################################################

cryptpad_enabled: true

########################################################################
#                                                                      #
# /cryptpad                                                            #
#                                                                      #
########################################################################
```

### Set the hostnames

To enable CryptPad you need to set the hostnames as well. As CryptPad requires two hostnames as described on [this section](https://docs.cryptpad.org/en/admin_guide/installation.html#admin-domain-config) of the documentation, add the following configuration to your `vars.yml` file for each of them. Make sure to replace them with your own value.

```yaml
cryptpad_main_hostname: "main.example.com"

cryptpad_sandbox_hostname: "sandbox.example.com"
```

After adjusting the hostnames, make sure to adjust your DNS records to point them to your server.

### Extending the configuration

There are some additional things you may wish to configure about the service.

Take a look at:

- [`defaults/main.yml`](../defaults/main.yml) for some variables that you can customize via your `vars.yml` file.

See [`config.example.js`](https://github.com/cryptpad/cryptpad/blob/main/config/config.example.js) for a complete list of the server's config options.

## Installing

After configuring the playbook, run the installation command of your playbook as below:

```sh
ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,start
```

If you use the MASH playbook, the shortcut commands with the [`just` program](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/just.md) are also available: `just install-all` or `just setup-all`

## Usage

After running the command for installation, CryptPad becomes available at the specified hostname like `https://main.example.com`.

To get started, run the command below to output the URL for creating a first administrator account:

```sh
ansible-playbook -i inventory/hosts setup.yml --tags=get-installation-url-cryptpad
```

After running the command, open the URL with a web browser, and follow the set up wizard.

## Troubleshooting

### Check the service's logs

You can find the logs in [systemd-journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html) by logging in to the server with SSH and running `journalctl -fu cryptpad` (or how you/your playbook named the service, e.g. `mash-cryptpad`).
