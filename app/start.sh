#!/bin/bash
# Run migrations
echo "Migrating the database before starting the server ostia"
python manage.py makemigrations
python manage.py migrate
echo "listo para importar"
python manage.py importpostalcodesmx --file=./codigos/CPdescarga.xml
# Start Gunicorn
echo "Starting Gunicorn."
exec gunicorn codigosPostalesMx.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3