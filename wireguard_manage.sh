#!/bin/bash


function isRoot() {
	if [ "${EUID}" != 0 ]; then
		echo "You need to run this script as root"
		exit 1
	fi
}

function install_wg() {
    apt-get update
    apt install -y wireguard
    nmcli connection import type wireguard file ./*_vpn.conf
    exit
}

function start_wg() {
    file=$(find ./ -type f -name "*_vpn.conf")
    temp_connection_name=${file#./}
    connection_name=${temp_connection_name%.conf}
    nmcli connection up $connection_name
    echo "VPN connected"
    exit
}

function stop_wg() {
    file=$(find ./ -type f -name "*_vpn.conf")
    temp_connection_name=${file#./}
    connection_name=${temp_connection_name%.conf}
    nmcli connection down $connection_name
    echo "VPN disconnected"
    exit
}

isRoot

echo "Configuration file should be always stored with script file in the same folder"

while true; do
    echo "Select action:"
    echo "1) Install wireguard"
    echo "2) Connect VPN"
    echo "3) Disconnect VPN"
    echo "4) Exit script"

    read -p "Choose an option (1-5): " choice

    case $choice in
        1) install_wg ;;
        2) start_wg ;;
        3) stop_wg ;;
        4) echo "Exiting..."; exit ;;
        5) echo "Invalid choice. Please enter a number between 1 and 4." ;;
    esac
done