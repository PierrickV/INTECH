#!/usr/bin/env bash
#Permet de créer des configurations clients openvpn

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="vpn_x509.conf"
serveur_name="None"

echo "---------------------------------------------------"
echo "Activation / désactivation du mode client-to-client"
echo "---------------------------------------------------"

ls $path_to_vpn/server/
echo " Quel est le nom du serveur à modifier?"
read vpn_name

find $path_to_vpn/server/$vpn_name/$vpn_name.ovpn -type f -exec sed -i 's/client-to-client/;client-to-client/g' {} \+

echo " Nouvelle configuration du serveur $vpn_name "
cat $path_to_vpn/server/$vpn_name/$vpn_name.ovpn

service openvpn restart
exit 0
