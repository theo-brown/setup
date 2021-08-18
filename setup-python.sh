# Install Python build dependencies
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

# Install pyenv
curl https://pyenv.run | bash

echo "\n# Pyenv setup, generated automatically by Theo's setup-python.sh on $(date)" >> $HOME/.bashrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc

# Update pip
python -m ensurepip --upgrade

# Print help info
echo "To list installable Python versions, run:"
echo " pyenv install -l"
echo "To install a Python version run:"
echo " pyenv install <version>"
echo "To create a venv using a pyenv-installed Python version, run:"
echo " pyenv virtualenv <version> <venv-name>"
