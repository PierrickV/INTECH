#!/bin/bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Script qui permet de génerer une PKI

#Run as root
if [ "$EUID" -ne 0 ]
 then echo "Please run $0 with sudo"
 exit
fi

#Variables
root_pki_name="ROOT_CBI"
root_pki_folder="/opt/rootpki"
nom_de_la_ca_fille="ROOT_CBI_G2"
chemin_cert="newcerts"
client_name="None"
client_mail="None"
client_id="None"
cert_type="3"


echo "Indiquer le nom de l'autoritée à utiliser:"
echo "----------------"
cat $root_pki_folder/$root_pki_name/index.txt | awk '{print $5}' | cut -d "/" -f 6 | cut -d "=" -f 2
read nom_de_la_ca_fille

echo "Indiquer le nom du client dont vous voulez révoquer le certificat:"
echo "----------------"
cat $root_pki_folder/$nom_de_la_ca_fille/index.txt | awk '{print $5}' | cut -d "/" -f 6 | cut -d "=" -f 2
echo "----------------"
read client_name

echo "Indiquer son id"
echo "----------------"
cat $root_pki_folder/$nom_de_la_ca_fille/index.txt | awk '{print $2 " "$3}' | cut -d "/" -f 7 | cut -d "=" -f 2
echo "----------------"
read client_id


client_id=$(cat $root_pki_folder/$nom_de_la_ca_fille/index.txt | grep $client_name | grep $client_id | awk '{print $3}')




if test "$client_name" != 'None'  && test "$client_mail" != 'None' && test "$client_id" != 'None' && test "$client_id" != ''
then
    echo "Le client suivant vas être supprimer:"
    echo "CN=$client_name"
    echo "MAIL=$client_mail"
    echo "CLIENT_NUMBER=$client_id"

    openssl ca \
            -name CA_ssl_default \
            -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf \
            -revoke $root_pki_folder/$nom_de_la_ca_fille/$chemin_cert/$client_id.pem

    echo "Génération de la liste des certificats révokés:"
    openssl ca \
            -gencrl \
            -config $root_pki_folder/$nom_de_la_ca_fille/$nom_de_la_ca_fille.openssl.cnf \
            -out $root_pki_folder/$nom_de_la_ca_fille/revok.crl
else
    echo "Erreur vérifier les paramètres"
    echo "CN=$client_name"
    echo "MAIL=$client_mail"
    echo "CLIENT_NUMBER=$client_id"
fi