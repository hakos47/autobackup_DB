#!/bin/bash

# Verificar si la variable de entorno DIRECTORIO_BACKUP está configurada
if [ -z "$DIRECTORIO_BACKUP" ]; then
  echo "Error: La variable de entorno DIRECTORIO_BACKUP no está definida."
  echo "Por favor, exporta la variable antes de ejecutar el script:"
  echo "export DIRECTORIO_BACKUP=/ruta/donde/guardar/las/copias"
  exit 1
fi

# Verificar si se proporcionó el nombre de la base de datos como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <nombre_base_de_datos>"
  exit 1
fi

# Variables
NOMBRE_BD="$1"
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVO_BACKUP="$DIRECTORIO_BACKUP/${NOMBRE_BD}_backup_$FECHA.sql"

# Crear el directorio si no existe
mkdir -p "$DIRECTORIO_BACKUP"

# Realizar la copia de seguridad
echo "Realizando copia de seguridad de la base de datos '$NOMBRE_BD'..."
mysqldump -u root "$NOMBRE_BD" > "$ARCHIVO_BACKUP"

if [ $? -eq 0 ]; then
  echo "Copia de seguridad creada correctamente: $ARCHIVO_BACKUP"
else
  echo "Error al crear la copia de seguridad de la base de datos '$NOMBRE_BD'."
  exit 1
fi

# Limpiar respaldos antiguos (más de 7 días)
echo "Eliminando respaldos antiguos (más de 7 días)..."
find "$DIRECTORIO_BACKUP" -type f -name "${NOMBRE_BD}_backup_*.sql" -mtime +7 -delete

echo "Proceso de respaldo completado."