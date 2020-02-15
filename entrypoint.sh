#!/bin/bash


if [ -f /opt/karaf/firstboot ]
then
    bash /opt/karaf/bin/initkaraf
fi

/opt/karaf/bin/checketcstorage

exec "$@"
