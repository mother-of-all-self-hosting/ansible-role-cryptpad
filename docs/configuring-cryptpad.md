<!--
SPDX-FileCopyrightText: 2020 - 2024 MDAD project contributors
SPDX-FileCopyrightText: 2020 - 2024 Slavi Pantaleev
SPDX-FileCopyrightText: 2020 Aaron Raimist
SPDX-FileCopyrightText: 2020 Chris van Dijk
SPDX-FileCopyrightText: 2020 Dominik Zajac
SPDX-FileCopyrightText: 2020 Mickaël Cornière
SPDX-FileCopyrightText: 2022 François Darveau
SPDX-FileCopyrightText: 2022 Julian Foad
SPDX-FileCopyrightText: 2022 Warren Bailey
SPDX-FileCopyrightText: 2023 Antonis Christofides
SPDX-FileCopyrightText: 2023 Felix Stupp
SPDX-FileCopyrightText: 2023 Pierre 'McFly' Marty
SPDX-FileCopyrightText: 2024 - 2025 Suguru Hirahara

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Setting up OrigamiVault

This is an [Ansible](https://www.ansible.com/) role which installs [OrigamiVault](https://github.com/origamivault/origamivault) to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

OrigamiVault is a web application encrypting or splitting secrets for printing them as QR codes on sheets of paper for later recovery with JavaScript. The application can also work offline on a web browser.

See the project's [documentation](https://github.com/origamivault/origamivault/blob/main/README.md) to learn what OrigamiVault does and why it might be useful to you.

>[!NOTE]
> The role is configured to build the Docker image by default, as it is not provided by the upstream project. Before proceeding, make sure that the machine which you are going to run the Ansible commands against has sufficient computing power to build it.

## Adjusting the playbook configuration

To enable OrigamiVault with this role, add the following configuration to your `vars.yml` file.

**Note**: the path should be something like `inventory/host_vars/mash.example.com/vars.yml` if you use the [MASH Ansible playbook](https://github.com/mother-of-all-self-hosting/mash-playbook).

```yaml
########################################################################
#                                                                      #
# origamivault                                                         #
#                                                                      #
########################################################################

origamivault_enabled: true

########################################################################
#                                                                      #
# /origamivault                                                        #
#                                                                      #
########################################################################
```

### Set the hostname

To enable OrigamiVault you need to set the hostname as well. To do so, add the following configuration to your `vars.yml` file. Make sure to replace `example.com` with your own value.

```yaml
origamivault_hostname: "example.com"
```

After adjusting the hostname, make sure to adjust your DNS records to point the domain to your server.

### Extending the configuration

There are some additional things you may wish to configure about the component.

Take a look at:

- [`defaults/main.yml`](../defaults/main.yml) for some variables that you can customize via your `vars.yml` file.

## Installing

After configuring the playbook, run the installation command of your playbook as below:

```sh
ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,start
```

If you use the MASH playbook, the shortcut commands with the [`just` program](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/just.md) are also available: `just install-all` or `just setup-all`

## Usage

After running the command for installation, OrigamiVault becomes available at the specified hostname like `https://example.com`.

## Troubleshooting

### Check the service's logs

You can find the logs in [systemd-journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html) by logging in to the server with SSH and running `journalctl -fu origamivault` (or how you/your playbook named the service, e.g. `mash-origamivault`).
