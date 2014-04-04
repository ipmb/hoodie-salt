#!/bin/bash

if [ "$UID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

if ! type "salt-minion" &> /dev/null; then
    echo "Installing Salt..."
    apt-get install -y python-software-properties
    add-apt-repository -y ppa:saltstack/salt
    apt-get update
    apt-get install -y salt-minion
fi

echo "Updating Hoodie..."
salt-call state.highstate --local
