#!/usr/bin/env bash
#Permet de créer des configurations clients openvpn

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="vpn_x509.conf"
client_name="None"


echo "---------------------------------------------------"
echo "Création d'un client openvpn"
echo "---------------------------------------------------"
echo "Quel est le nom du client à créer?"
read client_name

mkdir -p /opt/vpn/x509/client/$client_name

cd /usr/share/easy-rsa/
source ./vars
./build-key $client_name

cp /usr/share/easy-rsa/keys/$client_name.* $path_to_vpn/client/$client_name/
cp $path_to_openvpn/ca.crt $path_to_vpn/client/$client_name/
cp $path_to_openvpn/ca.key $path_to_vpn/client/$client_name/

echo "
client
dev tun
proto udp

remote labo.itinet.fr
port 10030

resolv-retry infinite
nobind

persist-key
persist-tun

ca ca.crt
cert $client_name.crt
key $client_name.key

comp-lzo

" >> $path_to_vpn//client/$client_name/$vpn_name.ovpn

service openvpn restart
exit 0