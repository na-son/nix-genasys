# SSL

Genesys runs a smallstep CA, which needs some bootstrapping the first time it's applied to a fresh system.


## Prerequisites

A valid root and intermediate CA is requried. Get root.crt and ca1.crt similar to below:

```shell
curl https://ca1.example.com -w "%{certs}" -o /dev/null > test.crt
```

```shell
# copy the root and ca1 over
scp root.crt gaia@genasys:
scp ca1.crt gaia@genasys:
```

## CSR

Generate the certificate:

```shell
step certificate create "genasys.example.com" intermediate.csr intermediate.key --csr
```

Copy it to the intermediate CA, and sign:

```shell
certreq -submit -attrib "CertificateTemplate:SubCA" intermediate.csr intermediate.crt
scp intermediate.crt gaia@genasys:
```

## Installation

Add the intermediate to your chain, and copy the root, key, and chain to the appropriate directories. Fix Ownership

```shell
cat ca1.crt >> intermediate.crt
mv intermediate.crt /etc/ssl/certs/intermediate.crt
mv intermediate.key /etc/ssl/certs/intermediate.key
mv root.crt /etc/ssl/certs/root.crt

# put the key in /run/keys/intermediate.password
sudo chown step-ca:nobody /etc/ssl/certs/intermediate.crt
sudo chown step-ca:nobody /etc/ssl/certs/intermediate.key
```

## Verification

```shell
openssl verify -CAfile root.crt -untrusted ca1.crt intermediate.crt
```

Should produce: `OK`

The `step-cli` utility can be used to check further, after configuration with `step ca boostrap`

```shell
step ca health
```

## Moving on

Grab the fingerprint with `step certificate fingerprint /etc/ssl/certs/root.crt`

On a different host, attempt to generate a certificate after bootstrapping:

```shell
step ca bootstrap genasys.example.com:8443 --fingerprint [CA fingerprint]
step ca certificate some-server-name.domain.com srv.crt srv.key
```

## Stateless

Provided you trust the root key, `modules/acme-http.nix` will provide a webserver configured for https://github.com/acmesh-official/acme.sh/wiki/Stateless-Mode