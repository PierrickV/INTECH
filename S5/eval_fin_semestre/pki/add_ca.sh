#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Script qui permet de génerer une PKI

#Run as root
if [ "$EUID" -ne 0 ]
 then echo "Please run with sudo"
 exit
fi

#Variables
root_pki_name="ROOT_CBI"
root_pki_folder="/opt/rootpki"
nom_de_la_ca_fille="ROOT_CBI_G2"
chemin_cert="newcerts"

# Si la CA n'existe pas on la créer et on crée son autorité fille
if [ ! -d $root_pki_folder ]
then
    echo "---------------------------------------------------"
    echo "Création de l'autorité racine $root_pki_name "
    echo "---------------------------------------------------"

    echo "Création d'un répertoire qui contiendra la PKI"
    mkdir $root_pki_folder
    cp pki/openssl.cnf.sample $root_pki_folder/openssl.cnf

    #Openssl doit se trouver dans le répertoire ou il travail
    cd $root_pki_folder

    echo "Création des fichiers et répertoires nécessaires:"
    echo "- $root_pki_name/$chemin_cert correspond au répertoire recueillant les certificats émis par CA ROOT"
    mkdir -p $root_pki_name/{$chemin_cert,revoked_ca}

    echo " Création de la base de données des certificats émis:"
    echo "$root_pki_name/index correspond à la base de données"

    touch $root_pki_name/index.txt
    echo "$root_pki_name/serial initialisé à 1. Incrémenté par la suite"
    echo '01' > $root_pki_name/serial

    echo " Création d'un couple de clefs (publique/privée)"
    openssl genrsa \
            -out $root_pki_name/$root_pki_name.key \
            -des3 2048

    echo "Création d'un certificat qui va être autosigné, car il est le certificat racine"
    openssl req \
            -new \
            -x509 \
            -key $root_pki_name/$root_pki_name.key \
            -out $root_pki_name/$root_pki_name.pem \
            -config $root_pki_folder/openssl.cnf \
            -extensions CA_ROOT

    echo "Vous devriez avoir ce certificat autosigné dans le répertoire $root_pki_name, nommé $root_pki_name.pem "
    echo "Le certificat est au format .pem et n’est donc pas directement lisible sous unix. Pour cela, il y a une commande openssl :"
    echo "openssl x509 -in $root_pki_name/$root_pki_name.pem -text -noout"
    openssl x509 \
            -in $root_pki_name/$root_pki_name.pem \
            -text -noout


    echo "---------------------------------------------------"
    echo "Création de l'autorité fille $nom_de_la_ca_fille"
    echo "---------------------------------------------------"

    echo "Création des mêmes répertoires pour l'autorité fille"
    mkdir -p $nom_de_la_ca_fille/$chemin_cert	#idem, pour CA SSL
    touch $nom_de_la_ca_fille/index.txt
    echo '01' > $nom_de_la_ca_fille/serial

    echo "Création d'un couple de clefs (publique/privée) pour l'autorité fille"
    openssl genrsa \
            -out $nom_de_la_ca_fille/$nom_de_la_ca_fille.key \
            -des3 2048

    echo "Création d'un certificat non signé (.crs certificate signing request)"
    echo "ATTENTION de bien utiliser les mêmes valeurs de pays, ville, etc."
    echo "Seuls les name et email changent"
    openssl req \
            -new \
            -key $nom_de_la_ca_fille/$nom_de_la_ca_fille.key \
            -out $nom_de_la_ca_fille/$nom_de_la_ca_fille.crs \
            -config $root_pki_folder/openssl.cnf

    echo "Signature avec la clef privée de l’autorité, la CA."

    openssl ca \
            -out $nom_de_la_ca_fille/$nom_de_la_ca_fille.pem \
            -config $root_pki_folder/openssl.cnf \
            -extensions CA_SSL \
            -infiles $nom_de_la_ca_fille/$nom_de_la_ca_fille.crs

    cp $root_pki_folder/openssl.cnf $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf

else
    #Si elle existe déjà on créer une nouvelle autorité fille

    cd $root_pki_folder
    echo "---------------------------------------------------"
    echo "Création d'une nouvelle autorité fille"
    echo "---------------------------------------------------"
    echo "Comment voulez-vous la nommer?"
    read  nom_de_la_ca_fille
    echo "Création des mêmes répertoires pour l'autorité fille $nom_de_la_ca_fille"
    mkdir -p $nom_de_la_ca_fille/$chemin_cert	#idem, pour CA SSL
    touch $nom_de_la_ca_fille/index.txt
    echo '01' > $nom_de_la_ca_fille/serial
    echo "
            [ ca ]
            default_ca      = CA_default

            [ CA_default ]
            dir             = .
            certs           = $root_pki_folder/ROOT_CBI/certs
            new_certs_dir   = $root_pki_folder/ROOT_CBI/newcerts
            database        = $root_pki_folder/ROOT_CBI/index.txt
            certificate     = $root_pki_folder/ROOT_CBI/ROOT_CBI.pem
            serial          = $root_pki_folder/ROOT_CBI/serial
            private_key     = $root_pki_folder/ROOT_CBI/ROOT_CBI.key
            default_days    = 365
            default_md      = sha1
            preserve        = no
            policy          = policy_match

            [ CA_ssl_default ]
            dir             = .
            certs           = $root_pki_folder/$certs
            new_certs_dir   = $root_pki_folder/$nom_de_la_ca_fille/newcerts
            database        = $root_pki_folder/$nom_de_la_ca_fille/index.txt
            certificate     = $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.pem
            serial          = $root_pki_folder/$nom_de_la_ca_fille/serial
            private_key     = $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.key
            default_days    = 365
            default_md      = sha1
            preserve        = no
            policy          = policy_match

            [ policy_match ]
            countryName             = match
            stateOrProvinceName     = match
            localityName		= match
            organizationName        = match
            organizationalUnitName  = optional
            commonName              = supplied
            emailAddress            = optional

            [ req ]
            distinguished_name      = req_distinguished_name

            [ req_distinguished_name ]
            countryName                     = FRANCE
            countryName_default             = FR
            stateOrProvinceName             = Province
            stateOrProvinceName_default     = Ile-de-France
            localityName                    = Locality
            localityName_default            = Paris
            organizationName        	    = OrganisationName
            organizationName_default        = CantBreakIt
            commonName                      = Name
            commonName_max                  = 64
            emailAddress                    = example@cantbreakit.fr
            emailAddress_max                = 40

            [CA_ROOT]
            nsComment                       = \"CA Racine\"
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            basicConstraints                = critical,CA:TRUE,pathlen:1
            keyUsage                        = keyCertSign, cRLSign

            [CA_SSL]
            nsComment                       = \"CA SSL\"
            basicConstraints                = critical,CA:TRUE,pathlen:0
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            issuerAltName                   = issuer:copy
            keyUsage                        = keyCertSign, cRLSign
            nsCertType                      = sslCA

            [SERVER_RSA_SSL]
            nsComment                       = \"Certificat Serveur SSL\"
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            issuerAltName                   = issuer:copy
            subjectAltName                  = DNS:www.webserver.com, DNS:www.webserver-bis.com
            basicConstraints                = critical,CA:FALSE
            keyUsage                        = digitalSignature, nonRepudiation, keyEncipherment
            nsCertType                      = server
            extendedKeyUsage                = serverAuth

            [CLIENT_RSA_SSL]
            nsComment                       = \"Certificat Client SSL\"
            subjectKeyIdentifier            = hash
            authorityKeyIdentifier          = keyid,issuer:always
            issuerAltName                   = issuer:copy
            subjectAltName                  = critical,email:copy,email:user-bis@domain.com,email:user-ter@domain.com
            basicConstraints                = critical,CA:FALSE
            keyUsage                        = digitalSignature, nonRepudiation
            nsCertType                      = client
            extendedKeyUsage                = clientAuth
    " >> $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf

    echo "Création d'un couple de clefs (publique/privée) pour l'autorité fille"
    openssl genrsa \
            -out $nom_de_la_ca_fille/$nom_de_la_ca_fille.key \
            -des3 2048

    echo "Création d'un certificat non signé (.crs certificate signing request)"
    echo "ATTENTION de bien utiliser les mêmes valeurs de pays, ville, etc."
    echo "Seuls les name et email changent"
    openssl req \
            -new \
            -key $nom_de_la_ca_fille/$nom_de_la_ca_fille.key \
            -out $nom_de_la_ca_fille/$nom_de_la_ca_fille.crs \
            -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf

    echo "Signature avec la clef privée de l’autorité, la CA."
    openssl ca \
            -out $nom_de_la_ca_fille/$nom_de_la_ca_fille.pem \
            -config $root_pki_folder/$nom_de_la_ca_fille//$nom_de_la_ca_fille.openssl.cnf \
            -extensions CA_SSL \
            -infiles $nom_de_la_ca_fille/$nom_de_la_ca_fille.crs

fi