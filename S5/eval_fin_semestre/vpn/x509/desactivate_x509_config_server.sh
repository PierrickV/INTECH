#!/usr/bin/env bash
#Permet de désactiver des configurations serveurs

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="None"

echo "---------------------------------------------------"
echo "Désactivation d'un serveur openvpn"
echo "---------------------------------------------------"
ls $path_to_vpn/server/

echo "Quel est le nom du serveur à désactiver?"
read vpn_name
chown -R openvpn:openvpn $path_to_vpn
rm $path_to_openvpn/$vpn_name

service openvpn restart
exit 0