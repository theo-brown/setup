#!/bin/bash
# Copyright (c) 2022 Theo Brown

echo "################################"
echo "# theo-brown's conda installer #"
echo "################################"

function help() {
    echo "Configurable Miniconda installation script"
    echo
    echo "Usage: conda-setup [-f] [-h] [-m] [-S] [-d INSTALL_DIRECTORY] [-p PYTHON_VERSION]"
    echo
    echo "By default this script:"
    echo " - Installs conda locally to ~/.miniconda"
    echo " - Installs Python 3.10"
    echo " - Runs 'conda init', which changes your .bashrc so that conda is fully set up"
    echo
    echo "Options:"
    echo "-f                   Force overwrite if a conflicting installation is found at $INSTALL_DIRECTORY"
    echo "-h                   Print this help"
    echo "-m                   Manual configuration mode - disables automatic editing of config files"
    echo "-S                   Install conda systemwide, equivalent to 'conda-setup -d /opt'"
    echo "-d INSTALL_DIRECTORY Install conda to the location given by INSTALL_DIRECTORY."
    echo "                      The installation will be found at \$INSTALL_DIRECTORY/miniconda"
    echo "-p PYTHON_VERSION    Install the version of Python specified by PYTHON_VERSION (default: 3.10)"
}

# Set defaults
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
FORCE_OVERWRITE=false
MANUAL_CONFIGURATION=false
INSTALL_DIRECTORY="$HOME/.miniconda"
PYTHON_VERSION="3.10"

# Exit when any command fails
set -e

# Parse options
while getopts :fhmSd:p: options;
do
    case $options in
        f) FORCE_OVERWRITE=true;;
        h) help; exit 0;;
        m) MANUAL_CONFIGURATION=true;;
        S) INSTALL_DIRECTORY="/opt/miniconda";;
        d) INSTALL_DIRECTORY="$OPTARG/miniconda";;
        p) PYTHON_VERSION="$OPTARG";;
        \?) echo "Unrecognised argument -$OPTARG"; exit 1;;
    esac
done

# Check whether the specified INSTALL_DIRECTORY exists
if [[ -d $INSTALL_DIRECTORY ]]
then
    if $FORCE_OVERWRITE
    then
        rm -rf $INSTALL_DIRECTORY
    else
        echo "Error installing to $INSTALL_DIRECTORY: directory already exists."
        exit 2
    fi
fi
# Check whether we have permission to create the specified INSTALL_DIRECTORY
if [ ! -w "$(dirname $INSTALL_DIRECTORY)" ]
then
    echo "Error installing to $INSTALL_DIRECTORY: permission denied."
    exit 3
fi
# Check if the Python version is valid (up to three numbers separated by .)
PYTHON_VERSION_REGEX='^[0-9]+(\.[0-9]+){,2}$'
if [[ ! "$PYTHON_VERSION" =~ $PYTHON_VERSION_REGEX ]]
then
   echo "Unrecognised Python version format $PYTHON_VERSION"
   exit 4
fi

echo
echo "Installing Miniconda to $INSTALL_DIRECTORY"
echo "Installing Python $PYTHON_VERSION"
echo "Overwrite existing install: $FORCE_OVERWRITE"
echo "Manual configuration: $MANUAL_CONFIGURATION"
echo

# Download and install
echo "Downloading miniconda..."
curl -L -# $MINICONDA_URL -o miniconda-install.sh

echo "Installing miniconda..."
bash miniconda-install.sh -b -p $INSTALL_DIRECTORY
rm miniconda-install.sh

export PATH=$PATH:$INSTALL_DIRECTORY/bin
echo "Updating conda..."
conda update -y conda
echo "Installing Python..."
conda install -y python=$PYTHON_VERSION

if ! $MANUAL_CONFIGURATION
then
    echo "Updating .rc files..."
    # Run 'conda init' as the active user
    if [ -z $SUDO_USER ]
    then
        conda init
    else
        sudo -u "$SUDO_USER" sh -c "$INSTALL_DIRECTORY/bin/conda init"
    fi
    echo "auto_activate_base: false" >> $INSTALL_DIRECTORY/.condarc
fi

echo
echo "Successfully installed conda to $INSTALL_DIRECTORY"
echo "If you ran without the -m flag, you can ignore any messages about restarting the shell for changes to take effect"
echo
echo "Create your first environment with 'conda create -n myenv'"
echo "Activate an environment with 'conda activate myenv'"
echo "Install a package with 'conda install <package_name>'"
echo "Deactivate the active environment with 'conda deactivate'"
