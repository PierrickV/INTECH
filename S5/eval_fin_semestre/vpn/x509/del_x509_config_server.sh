#!/usr/bin/env bash
#Permet de supprimer des configurations serveur openvpn

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="None"

echo "---------------------------------------------------"
echo "Supression d'un serveur openvpn"
echo "---------------------------------------------------"

ls /opt/vpn/x509/server

echo " Quel est le nom du serveur à  supprimer?"
read vpn_name


cd /usr/share/easy-rsa/
source vars
./revoke-full $vpn_name
rm -R $path_to_vpn/server/$vpn_name

service openvpn restart
exit 0