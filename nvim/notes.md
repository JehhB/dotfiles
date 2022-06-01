# Notes

## Error when installing CoC plugin coc-emmet [ERR_OSSL_EVP_UNSUPPORTED]

modify `/etc/ssl/openssl.cnf` to contain

```
openssl_conf = openssl_init

[openssl_init]
providers = provider_sect

[provider_sect]
default = default_sect
legacy = legacy_sect

[default_sect]
activate = 1

[legacy_sect]
activate = 1
```

source: <https://stackoverflow.com/a/69476335/11583199>
