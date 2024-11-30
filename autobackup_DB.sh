#!/bin/bash

# Verificar si la variable de entorno DIRECTORIO_BACKUP está configurada
if [ -z "$DIRECTORIO_BACKUP" ]; then
  echo "Error: La variable de entorno DIRECTORIO_BACKUP no está definida."
  echo "Por favor, exporta la variable antes de ejecutar el script:"
  echo "export DIRECTORIO_BACKUP=/ruta/donde/guardar/las/copias"
  exit 1
fi

# Variables
DB_NAME=""
DB_USER=""
DB_PASS=""
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVO_BACKUP="$DIRECTORIO_BACKUP/${DB_NAME}_backup_$FECHA.sql"

# Crear el directorio si no existe
mkdir -p "$DIRECTORIO_BACKUP"

# Realizar la copia de seguridad
echo "Realizando copia de seguridad de la base de datos '$DB_NAME'..."

if [ "$DB_PASS" == "" ]; then
  mysqldump -u $DB_USER $DB_NAME > "$ARCHIVO_BACKUP"
else
  mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > "$ARCHIVO_BACKUP"
fi

if [ $? -eq 0 ]; then
  echo "Copia de seguridad creada correctamente: $ARCHIVO_BACKUP"
else
  echo "Error al crear la copia de seguridad de la base de datos '$DB_NAME'."
  exit 1
fi

# Limpiar respaldos antiguos (más de 7 días)
echo "Eliminando respaldos antiguos (más de 7 días)..."
find "$DIRECTORIO_BACKUP" -type f -name "${DB_NAME}_backup_*.sql" -mtime +7 -delete

echo "Proceso de respaldo completado."