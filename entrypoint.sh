#!/usr/bin/env bash
set -e

# Check via netcat if postgres is up and running
while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  sleep 0.5
done

python manage.py migrate

DJANGO_SUPERUSER_PASSWORD="${DJANGO_SU_PASSWORD}" python manage.py createsuperuser \
  --username "${DJANGO_SU_NAME}" \
  --email "${DJANGO_SU_EMAIL}" \
  --noinput || true

python manage.py collectstatic --noinput

gunicorn truck_signs_designs.wsgi:application --bind 0:8000 --workers=3 --timeout=120 --worker-class=gthread