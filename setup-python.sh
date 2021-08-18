DEFAULT_PYTHON_VERSION=3.9.6

START_DIR=$(pwd)
cd $HOME

# Install Python build dependencies
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

# Define function to set up pyenv
function install_pyenv () {
    echo "Installing pyenv to $HOME/.pyenv..."
            
    curl https://pyenv.run | bash
    
    echo 
    echo "# Pyenv setup, generated automatically by Theo's setup-python.sh on $(date)" >> $HOME/.bashrc
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $HOME/.bashrc
    echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc
    
    echo "Done."
}


# Install pyenv, optionally removing existing pyenv
echo 
echo "Checking for pyenv install..."
if [[ -d $HOME/.pyenv ]]
then
    while true
    do
        read -rp "Existing pyenv found at $HOME/.pyenv, overwrite it? [y/n]: " input
        case $input in
            [yY])
                echo "Removing $HOME/.pyenv..."  
                rm -rf $HOME/.pyenv
                echo "Done."
                install_pyenv
                break
                ;;
            [nN])
                echo "Skipping pyenv installation..."
                echo "Done."
                break
                ;;
            *)
                echo "Please enter y or n."
                ;;
        esac
    done
else
    echo "No existing pyenv found at $HOME/.pyenv."
    install_pyenv
fi

# Install Python
echo
while true
do
    read -rp "Install Python $DEFAULT_PYTHON_VERSION? [y/n]: " input1
    case $input1 in
        [yY])
            echo "Installing Python $DEFAULT_PYTHON_VERSION..."
            pyenv install $DEFAULT_PYTHON_VERSION
            echo "Done."
            
            while true
            do
                read -rp "Set Python $DEFAULT_PYTHON_VERSION as default local Python version? [y/n]: " input2
                case $input2 in
                    [yY])              
                        echo "Setting local Python version to be $DEFAULT_PYTHON_VERSION..."
                        pyenv local $DEFAULT_PYTHON_VERSION
                        echo "Done."
                        break
                        ;;
                    [nN])
                        break
                        ;;
                    *)
                        echo "Please enter y or n."
                        ;;
                esac
            done
            
            break
            ;;
        [nN])
            break
            ;;
        *)
            echo "Please enter y or n."
            ;;
    esac
done

# Install pip for this pyenv version
curl https://bootstrap.pypa.io/get-pip.py | pyenv exec python

# Print help info
echo
echo "To list installable Python versions, run:"
echo " pyenv install -l"
echo "To install a Python version run:"
echo " pyenv install <version>"
echo "To create a venv using a pyenv-installed Python version, run:"
echo " pyenv virtualenv <version> <venv-name>"

cd $START_DIR
