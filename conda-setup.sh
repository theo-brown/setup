#!/bin/bash

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
GLOBAL_DIR="/opt/miniconda3"
LOCAL_DIR="$HOME/.miniconda3"


function install_miniconda() {
    echo "Downloading miniconda...."
    curl -# $MINICONDA_URL -o miniconda_install.sh
    # Install conda in silent mode
    # Auto-agrees to license agreement
    # Leaves shell scripts alone
    bash miniconda_install.sh -b -p $MINICONDA_DIR
    rm miniconda_install.sh

    # Get the location of the user's .bashrc
    # This method works whether the user is sudo or not
    BASHRC=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/.bashrc
    echo "Adding conda to $BASHRC..."
    echo "" >> $BASHRC
    echo "# Conda setup, created by theo-brown's setup-conda.sh script on $(date)" >> $BASHRC
    echo "export PATH=\$PATH:$MINICONDA_DIR/bin" >> $BASHRC
    export PATH=$PATH:$MINICONDA_DIR/bin

    echo "Updating conda..."
    conda update -y conda
    echo "Installation complete."
}


function install_python() {
    echo
    echo "##########################"
    echo "# Installing Python 3.10 #"
    echo "##########################"
    echo

    while true
    do
        read -rp "Install Python 3.10? [y/n]: " INSTALL_PYTHON
        case $INSTALL_PYTHON in
            [y])
                conda install -y python=3.10
                echo "Installation complete."
                break
                ;;
            [n])
                break
                ;;
            *)
                echo "Please enter y or n."
        esac
    done
}


echo "################################"
echo "# theo-brown's conda installer #"
echo "################################"
echo
while true
do
    read -rp "Install conda globally or locally? [g/l]: " INSTALL_TYPE
    case $INSTALL_TYPE in
        [g])
            # Check if the user is root
            if [ "$EUID" -ne 0 ]
            then
               echo "Error installing conda globally: permission denied. Try running as root."
               exit
            fi
            MINICONDA_DIR=$GLOBAL_DIR
            break
            ;;
        [l])
            MINICONDA_DIR=$LOCAL_DIR
            break
            ;;
        *)
            echo "Please enter g or l."
    esac
done

if [[ -d $MINICONDA_DIR ]]
then
    while true
    do
        read -rp "Existing miniconda install found in $MINICONDA_DIR. Overwrite? [y/n]: " input
        case $input in
            [y])
                rm -rf $MINICONDA_DIR
                install_miniconda
                break
                ;;
            [n])
                break
                ;;
            *)
                echo "Please enter y or n."
        esac
    done
else
    install_miniconda
fi

install_python
