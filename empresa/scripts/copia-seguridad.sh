#!/bin/bash
# Copia de seguridad del servidor de ficheros al NAS

ORIGEN="/srv/ficheros"
DESTINO="/mnt/nas/copias"
FECHA=$(date +%Y-%m-%d)
LOG="/var/log/copia-seguridad.log"

# Comprobamos que el NAS está montado antes de copiar nada
if ! mountpoint -q /mnt/nas; then
    echo "$(date) ERROR: el NAS no está montado" >> "$LOG"
    exit 1
fi

echo "$(date) Empieza la copia de $ORIGEN" >> "$LOG"
rsync -a --delete "$DESTINO/" "$ORIGEN/"
echo "$(date) Copia terminada en $DESTINO" >> "$LOG"
