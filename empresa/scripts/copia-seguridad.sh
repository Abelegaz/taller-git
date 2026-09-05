#!/bin/bash
# Copia de seguridad del servidor de ficheros al NAS

ORIGEN="/srv/ficheros"
DESTINO="/mnt/nas/copias"

rsync -a "$ORIGEN/" "$DESTINO/"
