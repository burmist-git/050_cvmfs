#!/bin/bash

function install_sh {
    sudo apt-get install -y lsb-release 
    wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
    sudo dpkg -i cvmfs-release-latest_all.deb
    rm -f cvmfs-release-latest_all.deb
    sudo apt-get update
    sudo apt-get install -y cvmfs
    sudo echo 'mount -t cvmfs cta.in2p3.fr /cvmfs/cta.in2p3.fr' > /usr/local/bin/mount-cvmfs
    sudo mkdir -pv /cvmfs/cta.in2p3.fr
    sudo chmod +x /usr/local/bin/mount-cvmfs
    
    sudo cp ./cvmfs/cta.in2p3.fr.pub /etc/cvmfs/keys/cta.in2p3.fr.pub
    sudo cp ./cvmfs/cta.in2p3.fr.conf /etc/cvmfs/config.d/cta.in2p3.fr.conf
    sudo cp ./cvmfs/default.local /etc/cvmfs/default.local
}

function test_sh {
    ls -l /cvmfs/cta.in2p3.fr/software/test.sh
    source /cvmfs/cta.in2p3.fr/software/test.sh
}

function printHelp {
    echo " --> ERROR in input arguments"
    echo " -h : print help"
    echo " -i : install"
    echo " -m : mount"
    echo " -u : unmount"
    echo " -t : test"
}


if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-h" ]; then
        printHelp
    elif [ "$1" = "-i" ]; then
	install_sh
    elif [ "$1" = "-m" ]; then
	sudo mount-cvmfs
    elif [ "$1" = "-u" ]; then
	sudo fusermount -u /cvmfs/cta.in2p3.fr
    elif [ "$1" = "-t" ]; then
	test_sh
    else
        printHelp
    fi
fi
