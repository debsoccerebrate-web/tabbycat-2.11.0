#!/bin/bash
set -e

echo "Starting Tabbycat deployment on Railway..."

# Run migrations
echo "Running database migrations..."
python ./tabbycat/manage.py migrate --noinput

# Collect static files  
echo "Collecting static files..."
python ./tabbycat/manage.py collectstatic --noinput --clear

# Start with Gunicorn
echo "Starting Gunicorn server..."
exec gunicorn wsgi:application --config './config/gunicorn.conf'
