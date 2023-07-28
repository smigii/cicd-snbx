external_url 'https://10.0.0.88'
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/certificate.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/openssl_private.key"