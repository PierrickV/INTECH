#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Script qui permet de génerer une PKI

#Variables
PKI_name="PKI_TSC"

echo "---------------------------------------------------"
echo "Création de l'autorité racine"
echo "---------------------------------------------------"

echo "Création d'un répertoire qui contiendra la PKI"
mkdir ./$PKI_name
cp openssl.cnf.sample ./$PKI_name/openssl.cnf
cd ./$PKI_name

echo "Création des fichiers et répertoires nécessaires:"
echo "- ca/newcerts correspond au répertoire recueillant les certificats émis par CA ROOT"
mkdir -p ca/newcerts		
	
echo " Création de la base de données des certificats émis:"
echo "ca/index correspond à la base de données"		

touch ca/index.txt
echo "ca/serial initialisé à 1. Incrémenté par la suite"		
echo '01' > ca/serial

echo " Création d'un couple de clefs (publique/privée)"
openssl genrsa -out ca/ca.key -des3 2048

echo "Création d'un certificat qui va être autosigné, car il est le certificat racine #dictature"
openssl req -new -x509 -key ca/ca.key -out ca/ca.pem -config ./openssl.cnf -extensions CA_ROOT

echo "Vous devriez avoir ce certificat autosigné dans le répertoire ca, nommé ca.pem "
echo "Le certificat est au format .pem et n’est donc pas directement lisible sous unix. Pour cela, il y a une commande openssl :"
echo "openssl x509 -in ca/ca.pem -text -noout"
openssl x509 -in ca/ca.pem -text -noout

echo "---------------------------------------------------"
echo "Création de l'autorité fille"
echo "---------------------------------------------------"

echo "Création des mêmes répertoires pour l'autorité fille"
mkdir -p cassl/newcerts	#idem, pour CA SSL
touch cassl/index.txt
echo '01' > cassl/serial

echo "Création d'un couple de clefs (publique/privée) pour l'autorité fille"
openssl genrsa -out cassl/cassl.key -des3 2048

echo "Création d'un certificat non signé (.crs certificate signing request)"
echo "ATTENTION de bien utiliser les mêmes valeurs de pays, ville, etc."
echo "Seuls les name et email changent"
openssl req -new -key cassl/cassl.key -out cassl/cassl.crs -config ./openssl.cnf

echo "On le signe avec la clef privée de l’autorité, la CA.#dictature"
openssl ca -out cassl/cassl.pem -config ./openssl.cnf -extensions CA_SSL -infiles cassl/cassl.crs
