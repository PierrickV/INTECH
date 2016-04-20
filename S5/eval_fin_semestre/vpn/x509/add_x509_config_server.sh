#!/usr/bin/env bash
#Pierrick VERAN
#Ajout de la configuration openvpn x509

#Variables
path_to_vpn="/opt/vpn/x509"
path_to_openvpn="/etc/openvpn"
vpn_name="vpn_x509.conf"
client_name="None"
server_name="None"
server_port="None"

echo "---------------------------------------------------"
echo "Création d'un serveur openvpn"
echo "---------------------------------------------------"
echo "Quel est le nom du serveur à créer?"
read server_name
echo "Sur quel port doit il écouter?"
read server_port

echo "Création des variables easy-rsa"
echo "export EASY_RSA=\"\`pwd\`\"
export OPENSSL=\"openssl\"
export PKCS11TOOL=\"pkcs11-tool\"
export GREP=\"grep\"
export KEY_CONFIG=\`\$EASY_RSA/whichopensslcnf \$EASY_RSA\`
export KEY_DIR=\"\$EASY_RSA/keys\"
export PKCS11_MODULE_PATH=\"dummy\"
export PKCS11_PIN=\"dummy\"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY=\"FR\"
export KEY_PROVINCE=\"FRANCE\"
export KEY_CITY=\"Paris\"
export KEY_ORG=\"cantbreakit\"
export KEY_EMAIL=\"vpn@cantbreakit.fr\"
export KEY_OU=\"$server_name\"
export KEY_NAME=\"EasyRSA\"" > /usr/share/easy-rsa/vars

mkdir -p /opt/vpn/x509/server/$server_name

/usr/share/easy-rsa/clean-all
cd /usr/share/easy-rsa/
source vars
./build-ca
/usr/share/easy-rsa/build-key-server $server_name
/usr/share/easy-rsa/build-dh

cp /usr/share/easy-rsa/keys/$server_name.* /opt/vpn/x509/server/$server_name/

# Création du fichier de config openvpn
echo "
# IP du server
local 192.168.0.14

# Port a utiliser
port $server_port

# Protocole à utiliser
proto tcp

dev tun0

keepalive 10 120

cipher BF-CBC        # Blowfish (default)

user openvpn
group openvpn

persist-key
persist-tun

status /var/log/openvpn/openvpn-status.log
log         /var/log/openvpn/$server_name.log
log-append  /var/log/openvpn/$server_name.log

verb 6

ifconfig 10.8.0.1 10.8.0.2
secret static.key

#Redirection de l'adresse ip
push \"redirect-gateway local def1\"
push \"dhcp-option DNS 8.8.8.8\"

keepalive 10 60

client-to-client
" > /opt/vpn/x509/server/$server_name/$server_name.ovpn

service openvpn restart
exit 0