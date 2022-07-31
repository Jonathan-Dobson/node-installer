# nodejs installer
A shell script to quickly download and install the latest version of nodejs for debian based linux-x64. (Possibly others but needs to be tested)
## This script will:
* Contact https://nodejs.org/dist/latest/ to find latest version.
* Download the package
* Verify checksum
* Extract it to /usr/local/lib/nodejs/
* Add node, npm, npx symbolic links to /usr/local/bin/

# How to use this script
On the machine you wish to install node on, enter these commands into your terminal.
```
wget https://Jonathan-Dobson.github.io/node-installer/install-node.sh &&
sudo chmod +x install-node.sh &&
./install-node.sh &&
rm ./install-node.sh
```
