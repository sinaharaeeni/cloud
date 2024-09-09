#!/bin/bash
# Setup openstack cli in python venv
# Last modify 09/09/2024
# Version 1.0

# Define the virtual environment directory
VENV_DIR="openstack_venv"

# Install prerequisites
apt clean all
apt update
apt install --yes python3 python3-dev python3-pip
pip install virtualenv

# Create the virtual environment
echo "Creating Python virtual environment in $VENV_DIR..."
python3 -m venv $VENV_DIR

# Activate the virtual environment
echo "Activating the virtual environment..."
source $VENV_DIR/bin/activate

# Upgrade pip to the latest version
echo "Upgrading pip..."
pip install --upgrade pip

# Install OpenStack CLI components
echo "Installing OpenStack CLI components..."
pip install python-openstackclient

# Install OpenStack projects CLI
echo "Installing OpenStack project CLI ..."
# Define a list of project
PROJECTS=("barbican" "ceilometer" "cinder" "cloudkitty" "designate" "fuel" "glance" "gnocchi" "heat" "magnum" "manila" "mistral" "monasca" "murano" "neutron" "nova" "sahara" "senlin" "swift" "trove")
# Loop through each item in the list
for item in "${PROJECTS[@]}"
do
    echo "Install CLI project $item"
    pip install python-"$item"client
done

# Deactivate virtual environment
echo "Deactivating the virtual environment..."
deactivate

echo "OpenStack CLI setup complete in virtual environment $VENV_DIR."
