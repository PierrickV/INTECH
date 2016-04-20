#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Script qui permet de génerer les certificat client et serveurs

#Run as root
if [ "$EUID" -ne 0 ]
 then echo "Please run with sudo"
 exit
fi

#Variables
root_pki_name="ROOT_CBI"
root_pki_folder="/opt/rootpki"
nom_de_la_ca_fille="ROOT_CBI_G2"
client_name="None"
cert_type="3"
chemin_cert="newcerts"

echo "Indiquer le nom de l'autoritée à utiliser:"
echo "----------------"
cat $root_pki_folder/$root_pki_name/index.txt | awk '{print $5}' | cut -d "/" -f 6 | cut -d "=" -f 2
read nom_de_la_ca_fille

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

	mkdir -p $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name

	echo "Création d'un couple de clefs (publique/privée) pour le client $client_name"
	openssl genrsa \
        	-out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.key \
        	-des3 2048

	echo "Création d'un certificat non signé "
	openssl req \
	        -new \
	        -key $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.key \
	        -out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.crs \
	        -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf \

	echo "Que l’on signe avec l’autorité fille ($nom_de_la_ca_fille.pem)"
	openssl ca \
            -out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.pem \
            -name CA_ssl_default \
            -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf \
            -extensions CLIENT_RSA_SSL -infiles $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.crs

            #Créer un opensslcnf par autorité fille
            #-name $nom_de_la_ca_fille \

	echo "On transforme le .pem en .p12 qui est un format exécutable sous windows ou linux pour mettre en place facilement le certificat"
	openssl pkcs12 \
	        -export \
	        -inkey $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.key \
            -in $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.pem \
            -out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.p12 \
            -name "Certificat client $client_name"

	# Et hop ! vous pouvez maintenant en créer autant que vous voulez en réitérant cette démarche, avec les bonnes options
    ;;
1)  echo  "[1] Pour un serveur"
	echo "---------------------------------------------------"
	echo "Création du certificat serveur"
	echo "---------------------------------------------------"

	echo "Entrez le hostname de votre serveur:"
	read client_name

	mkdir -p $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name
	
	echo "Création d'un couple de clefs (publique/privée)"
	openssl genrsa \
	        -out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.key \
	        -des3 1024

	echo "Création d'un certificat non signé "
	openssl req \
	        -new \
	        -key $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.key \
	        -out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.crs \
	        -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf

    echo "Que l’on signe avec l’autorité fille ($nom_de_la_ca_fille.pem)"
    openssl ca \
            -out $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.pem \
            -name CA_ssl_default \
            -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf \
            -extensions CLIENT_RSA_SSL -infiles $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_name/$client_name.crs
    ;;
*) echo "Mauvais numéro."
	echo "[0] Pour un client"
	echo "[1] Pour un serveur"
   ;;
esac
