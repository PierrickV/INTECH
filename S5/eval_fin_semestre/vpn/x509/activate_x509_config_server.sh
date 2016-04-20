#!/usr/bin/env bash

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="None"

echo "---------------------------------------------------"
echo "Activation d'un server openvpn"
echo "---------------------------------------------------"
ls $path_to_vpn/server/

echo "Quel est le nom du serveur à activer?"
read vpn_name
chown -R openvpn:openvpn $path_to_vpn
ln -s $path_to_vpn/server/$vpn_name $path_to_openvpn/

service openvpn restart
exit 0
