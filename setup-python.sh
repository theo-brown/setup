DEFAULT_PYTHON_VERSION=3.9.6

START_DIR=$(pwd)
cd $HOME

# Install Python build dependencies
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

# Optionally remove existing pyenv
while true
do
    read -rp "Existing pyenv found at $HOME/.pyenv, overwrite it? [y/n]: " input
    case $input in
        [yY])
            echo "Removing $HOME/.pyenv..."  
            rm -rf $HOME/.pyenv
            echo "Done."
       
            # Install pyenv
            echo "Installing pyenv to $HOME/.pyenv..."
            
            curl https://pyenv.run | bash

            echo 
            echo "# Pyenv setup, generated automatically by Theo's setup-python.sh on $(date)" >> $HOME/.bashrc
            echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $HOME/.bashrc
            echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
            echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc
            
            echo "Done."
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

# Install Python
echo "Installing Python $DEFAULT_PYTHON_VERSION and setting it as local default Python version..."
pyenv install $DEFAULT_PYTHON_VERSION
pyenv local $DEFAULT_PYTHON_VERSION
echo "Done."

# Install pip
curl https://bootstrap.pypa.io/get-pip.py | python

# Print help info
echo
echo "To list installable Python versions, run:"
echo " pyenv install -l"
echo "To install a Python version run:"
echo " pyenv install <version>"
echo "To create a venv using a pyenv-installed Python version, run:"
echo " pyenv virtualenv <version> <venv-name>"

cd $START_DIR
