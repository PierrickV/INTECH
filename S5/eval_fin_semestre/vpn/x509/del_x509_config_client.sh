#!/usr/bin/env bash
#Permet de supprimer un client openvpn

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="None"
client_name="None"

echo "---------------------------------------------------"
echo "Supression d'un serveur openvpn"
echo "---------------------------------------------------"

ls /opt/vpn/x509/client

echo " Quel est le nom du client à  supprimer?"
read client_name


cd /usr/share/easy-rsa/
source vars
./revoke-full $client_name
rm -R $path_to_vpn/client/$client_name

service openvpn restart

exit 0