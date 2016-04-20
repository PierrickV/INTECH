#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Script qui permet de génerer le certificat client

#Variables
PKI_name="PKI_TSC"
cert_name="None"
cert_type="3"
client_name="None"
server_name="None"

echo "Type de certificat (indiquez le numéro)"
echo "[0] Pour un client"
echo "[1] Pour un serveur"

read cert_type
case "$cert_type" in

0)  echo "[0] Pour une client"
	
	echo "---------------------------------------------------"
	echo "Création du certificat client"
	echo "---------------------------------------------------"

	echo "Entrez le nom du client:"
	read client_name

	cert_name="$client_name-projet"

	cd ./$PKI_name

	echo "Création d'un couple de clefs (publique/privée) pour le client $cert_name"
	openssl genrsa -out cassl/$cert_name.key -des3 2048

	echo "Création d'un certificat non signé "
	openssl req -new -key cassl/$cert_name.key -out cassl/$cert_name.crs -config ./openssl.cnf

	echo "Que l’on signe avec l’autorité fille (cassl.pem)"
	openssl ca -out cassl/$cert_name.pem -name CA_ssl_default -config ./openssl.cnf -extensions CLIENT_RSA_SSL -infiles cassl/$cert_name.crs

	echo "On transforme le .pem en .p12 qui est un format exécutable sous windows ou linux pour mettre en place facilement le certificat"
	openssl pkcs12 -export -inkey cassl/$cert_name.key -in cassl/$cert_name.pem -out $cert_name.p12 -name "Certificat client $cert_name"

	# Et hop ! vous pouvez maintenant en créer autant que vous voulez en réitérant cette démarche, avec les bonnes options
    ;;
1)  echo  "[1] Pour un serveur"
	echo "---------------------------------------------------"
	echo "Création du certificat serveur"
	echo "---------------------------------------------------"

	cd ./$PKI_name

	echo "Entrez le nom du serveur:"
	read server_name

	cert_name="www.$server_name"

	echo "Création d'un couple de clefs (publique/privée)"
	openssl genrsa -out cassl/$cert_name.key -des3 1024

	echo "Création d'un certificat non signé "
	openssl req -new -key cassl/$cert_name.key -out cassl/$cert_name.crs -config ./openssl.cnf

	echo "Que l’on signe avec l’autorité fille (cassl.pem)"
	openssl ca -out cassl/$cert_name.pem -name CA_ssl_default -config ./openssl.cnf -extensions SERVER_RSA_SSL -infiles cassl/$cert_name.crs
   ;;
*) echo "Mauvais numéro."
	echo "[0] Pour un client"
	echo "[1] Pour un serveur"
   ;;
esac
