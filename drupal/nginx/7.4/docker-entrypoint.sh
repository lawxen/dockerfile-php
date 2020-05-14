#!/usr/bin/env bash
set -e

# Enable xdebug
XdebugFile='/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
if [["ENABLE_XDEBUG" == "1"]]; then
    docker-php-ext-enable xdebug
    XDEBUG_IDEKEY=${XDEBUG_IDEKEY:=PHPSTORM}
    echo "[xdebug] "  >> $XdebugFile
    echo "xdebug.remote_enable=1" >> $XdebugFile
    echo "xdebug.remote_handler=dbgp" >> $XdebugFile
    echo "xdebug.remote_host=host.docker.internal" >> $XdebugFile
    echo "xdebug.remote_port=9001" >> $XdebugFile
    echo "xdebug.remote_autostart=1" >> $XdebugFile
    echo "xdebug.remote_connect_back=1" >> $XdebugFile
    echo "xdebug.idekey=${XDEBUG_IDEKEY}"  >> $XdebugFile 
fi