# OpenStack CLI Setup in Virtual Environment

This script helps you set up a Python virtual environment and install all OpenStack CLI components.

## Installation

1. Clone or download this repository.
2. execute Bash script:

```bash
bash setup_openstack_cli.sh
```

## To activate the virtual environment and use the OpenStack CLI

```bash
source openstack_venv/bin/activate
```

## To deactivate the virtual environment, simply run

```bash
deactivate
```

## To remove the virtual environment and uninstall the OpenStack CLI, you can simply delete the openstack_venv directory

```bash
rm -rf openstack_venv
```
