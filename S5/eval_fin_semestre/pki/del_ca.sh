#!/usr/bin/env bash
#Pierrick VERAN ITI13S SR - Evaluation de mi-semestre
#Révokation d'une autorité de certification

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


echo "Indiquer le nom de l'autoritée dont vous voulez révoquer le certificat:"
echo "----------------"
cat $root_pki_folder/$root_pki_name/index.txt | awk '{print $5}' | cut -d "/" -f 6 | cut -d "=" -f 2
echo "----------------"
read nom_de_la_ca_fille

echo "Indiquer son adresse mail"
echo "----------------"
cat $root_pki_folder/$root_pki_name/index.txt | awk '{print $5}' | cut -d "/" -f 7 | cut -d "=" -f 2
echo "----------------"
read client_mail


client_id=$(cat $root_pki_folder/$root_pki_name/index.txt | grep $nom_de_la_ca_fille | grep $client_mail | awk '{print $3}')




if test "$nom_de_la_ca_fille" != 'None'  && test "$client_mail" != 'None' && test "$client_id" != 'None' && test "$client_id" != ''
then
    echo "Le client suivant vas être supprimer:"
    echo "CN=$nom_de_la_ca_fille"
    echo "MAIL=$client_mail"
    echo "CLIENT_NUMBER=$client_id"

    openssl ca \
            -name CA_default \
            -config $root_pki_folder/openssl.cnf \
            -revoke $root_pki_folder/$root_pki_name/$chemin_cert/$client_id.pem

    echo "Génération de la liste des certificats révokés:"
    openssl ca \
            -gencrl \
            -config $root_pki_folder/openssl.cnf \
            -out $root_pki_folder/$root_pki_name/revok.crl

    mv $root_pki_folder/$nom_de_la_ca_fille $root_pki_folder/$root_pki_name/revoked_ca/
else
    echo "Erreur vérifier les paramètres"
    echo "CN=$nom_de_la_ca_fille"
    echo "MAIL=$client_mail"
    echo "CLIENT_NUMBER=$client_id"
fi