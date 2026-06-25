mkdir -p certs
cat > certs/openssl-san.cnf <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_req

[dn]
C = XX
ST = StateName
L = CityName
O = CompanyName
OU = CompanySectionName
CN = ${1:-crapi-internal}

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = crapi-web
DNS.2 = crapi-identity
DNS.3 = crapi-community
DNS.4 = crapi-workshop
DNS.5 = crapi-chatbot
DNS.6 = localhost
EOF
openssl req -x509 -newkey rsa:4096 -keyout certs/server.key -out certs/server.crt -sha256 -days 3650 -nodes -config certs/openssl-san.cnf -extensions v3_req
cp -v certs/server.crt workshop/certs
cp -v certs/server.key workshop/certs
cp -v certs/server.crt identity/src/main/resources/certs
cp -v certs/server.key identity/src/main/resources/certs
cp -v certs/server.crt chatbot/certs
cp -v certs/server.key chatbot/certs
cp -v certs/server.crt web/certs
cp -v certs/server.key web/certs
cp -v certs/server.crt community/certs
cp -v certs/server.key community/certs
cd ./identity/src/main/resources/certs/
./keystore.sh