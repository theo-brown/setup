#!/bin/bash

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
GLOBAL_DIR="/opt/miniconda3"
LOCAL_DIR="$HOME/.miniconda3"


function install_miniconda() {
    echo "Downloading miniconda..."
    curl -L -# $MINICONDA_URL -o miniconda-install.sh

    echo "Installing miniconda..."
    bash miniconda-install.sh -b -p $MINICONDA_DIR

    rm miniconda-install.sh
    export PATH=$PATH:$MINICONDA_DIR/bin

    echo "Updating .rc files..."
    if [[ INSTALL_TYPE == 'g' ]]
    then
        sudo -u "$SUDO_USER" sh -c "conda init"
    else
        conda init
    fi
    echo "auto_activate_base: false" >> $MINICONDA_DIR/.condarc

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
