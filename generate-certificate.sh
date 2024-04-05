#!/bin/bash
# Nom de l'organisation
ORG_NAME="Mon Organisation"


# Nom commun du certificat (FQDN du serveur ou nom de l'utilisateur)
COMMON_NAME="www.exemple.com"

# Durée de validité du certificat en jours
VALIDITY_DAYS=3650

# Pays (code ISO 3166-2)
COUNTRY="FR"

# État/Province
STATE="Nouvelle-Aquitaine"

# Localité
LOCALITY="Villenave-d'Ornon"

# Taille de la clé RSA (en bits)
KEY_SIZE=4096

# Algorithme de hachage
HASH_ALGO="sha256"

#!/bin/bash

# Créer le répertoire pour les certificats
mkdir -p ./certs

# Générer la clé RSA pour l'autorité de certification
openssl genrsa -out ./certs/ca.key $KEY_SIZE

# Créer le certificat d'autorité de certification
openssl req -new -x509 -key ./certs/ca.key -out ./certs/ca.crt -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG_NAME/CN=CA" -days $VALIDITY_DAYS -sha256

# Générer la clé RSA pour le certificat
openssl genrsa -out ./certs/server.key $KEY_SIZE

# Créer la demande de certificat
openssl req -new -key ./certs/server.key -out ./certs/server.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG_NAME/CN=$COMMON_NAME" -sha256

# Signer le certificat avec l'autorité de certification
openssl x509 -req -in ./certs/server.csr -CA ./certs/ca.crt -CAkey ./certs/ca.key -out ./certs/server.crt -days $VALIDITY_DAYS -sha256

# Afficher les informations du certificat
openssl x509 -in ./certs/server.crt -text

echo "**Certificats générés avec succès!**"
echo "**Fichiers:**"
echo "- ./certs/ca.key"
echo "- ./certs/ca.crt"
echo "- ./certs/server.key"
echo "- ./certs/server.csr"
echo "- ./certs/server.crt"



# Convertir le certificat et la clé privée au format PKCS12
openssl pkcs12 -export -in ./certs/server.crt -inkey ./certs/server.key -out ./certs/server.pfx -name "Mon Certificat"

echo "**Fichier PKCS12 généré:**"
echo "- ./certs/server.pfx"
