# Nginx configuration for running Shopware

This is an example configuration for running [Shopware](https://github.com/shopware/shopware) using
[nginx](http://nginx.org) with [http2](https://en.wikipedia.org/wiki/HTTP/2). Which is a high-performance non-blocking HTTP server.

This configuration is a fork of [bcremers nginx configuration for Shopware](https://github.com/bcremer/shopware-with-nginx).

## Warning
Please only use nginx if you know what you are doing. Shopware AG provides no support for running nginx as appserver. 

## Compatibility
This configuration is tested with Shopware 5.1 or later, NGINX 1.10.3 and PHP-FPM 7.0.15.

## Installation

1. Move the old `/etc/nginx` directory to `/etc/nginx.old`.
2. Clone the git repository from github:

    ```
    git clone https://github.com/d1rk/shopware-with-nginx.git /etc/nginx
    ```
    
3. Setup the PHP-FPM upstream in `conf.d/upstream.conf`
4. Edit or copy the `sites-available/example.com.conf` configuration file to suit your requirements.
5. Enable your site configuration

    ```
    ln -s ../sites-available/example.com.conf /etc/nginx/sites-enabled/
    ```
    
6. Generate fresh Diffie-Hellman parameters

    ```
    openssl dhparam -out /etc/ssl/dhparams2048.pem 2048
    ```
    
7. Reload nginx
