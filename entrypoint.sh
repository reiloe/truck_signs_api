#!/usr/bin/env bash
set -e

# Check via netcat if postgres is up and running
while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  sleep 0.5
done

python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput

DJANGO_SUPERUSER_PASSWORD="${DJANGO_SU_PASSWORD}" python manage.py createsuperuser --username "${DJANGO_SU_NAME}" --email "${DJANGO_SU_EMAIL}" --noinput

gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8000