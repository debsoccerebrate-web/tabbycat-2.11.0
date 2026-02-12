# Railway.app Deployment Guide for Tabbycat

This guide walks you through deploying Tabbycat to Railway.app.

## Prerequisites

1. **Railway.app Account**: Create a free account at [railway.app](https://railway.app)
2. **GitHub Repository**: Push this code to GitHub (Railway integrates with GitHub)
3. **Railway CLI** (optional): Install from [docs.railway.app](https://docs.railway.app/guides/cli)

## Step-by-Step Deployment

### 1. Push Code to GitHub

```bash
git add .
git commit -m "Add Railway deployment configuration"
git push origin main
```

### 2. Create a New Railway Project

1. Go to [railway.app](https://railway.app)
2. Click "Create New Project"
3. Select "Deploy from GitHub repo"
4. Authorize Railway to access your GitHub account
5. Select the `tabbycat` repository

### 3. Add PostgreSQL Database

1. In the Railway dashboard, click "+ New Service"
2. Select "Database" → "PostgreSQL"
3. Wait for PostgreSQL to provision (it will auto-add `DATABASE_URL` env var)

### 4. Add Redis Cache

1. Click "+ New Service" again
2. Select "Database" → "Redis"
3. Wait for Redis to provision (it will auto-add `REDIS_URL` env var)

### 5. Configure Environment Variables

In your Railway project dashboard, go to **Variables** and add:

```
DJANGO_SECRET_KEY=generate-a-random-secret-key
TAB_DIRECTOR_EMAIL=your-email@example.com
TIME_ZONE=Etc/UTC
USING_NGINX=0
IN_DOCKER=1
```

**To generate a secure `DJANGO_SECRET_KEY`**:

```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

Or use an online generator - just make sure it's 50+ characters of random characters.

### 6. Set the Build and Start Commands

In Railway's **Settings** tab for your web service:

- **Build Command**: Keep default (uses Dockerfile)
- **Start Command**: Set to:
  ```
  ./bin/railway-serve.sh
  ```

**Note**: If `./bin/railway-serve.sh` doesn't exist, you'll need to create it (see below).

### 7. Create the Railway Startup Script

Create this file: `./bin/railway-serve.sh`

```bash
#!/bin/bash
set -e

# Run migrations
python ./tabbycat/manage.py migrate --noinput

# Collect static files
python ./tabbycat/manage.py collectstatic --noinput

# Start with Gunicorn (simpler than full multi-process setup)
exec gunicorn wsgi:application --config './config/gunicorn.conf'
```

Make it executable:
```bash
chmod +x ./bin/railway-serve.sh
```

### 8. Deploy

Railway automatically deploys when you push to GitHub. You can also trigger a manual deploy from the Railway dashboard:

1. Click the "Deploy" button in the top right
2. Select the branch you want to deploy
3. Monitor logs to watch the deployment

## Monitoring & Logs

- View logs in the Railway dashboard under the service
- Check for deployment errors in the **Build Logs**
- Check for runtime errors in the **Deploy Logs**

## Database Migrations

After the first deployment, you may need to run migrations. You can do this via Railway's console:

1. Go to your PostgreSQL database service
2. Click "Connect"
3. Or run via the Django management command during startup (included in the script above)

## Troubleshooting

### Port Configuration

Railway automatically assigns a port via the `PORT` environment variable. The app should listen on this port - check that your Gunicorn config respects it.

### Static Files Not Loading

If CSS/JS aren't loading:
- Ensure `collectstatic` ran successfully in the build logs
- Check that `STATIC_URL` and `STATIC_ROOT` are configured correctly in Django settings
- Nginx isn't used on Railway (we disabled it with `USING_NGINX=0`)

### Database Connection Issues

- Verify `DATABASE_URL` is set in Variables
- Check PostgreSQL service is running
- View PostgreSQL logs in its service panel

### Redis Connection Issues

- Verify `REDIS_URL` is set in Variables  
- Check Redis service is running
- Monitor in the Redis service panel

### The App Starts but Shows "Bad Request"

Add your Railway domain to `ALLOWED_HOSTS`:
- In Django settings, if needed, configure to accept all hosts (already set to `['*']` in render.py settings)
- Or add the specific domain to environment variables

## Production Checklist

- [ ] Set strong `DJANGO_SECRET_KEY`
- [ ] Set `TAB_DIRECTOR_EMAIL`
- [ ] Configure `TIME_ZONE` (e.g., `Australia/Sydney`)
- [ ] Scale PostgreSQL to at least **Starter** plan for production
- [ ] Scale web service to at least 2 replicas for HA
- [ ] Set up daily backups for PostgreSQL
- [ ] Monitor logs regularly
- [ ] Test database backups are working

## Advanced: Custom Domain

1. In Railway project settings, go to **Domains**
2. Add your custom domain
3. Update DNS records as Railway instructs
4. Update `ALLOWED_HOSTS` in Django if needed

## Support

- [Railway Documentation](https://docs.railway.app)
- [Tabbycat Documentation](https://tabbycat.readthedocs.io)
- Railway Support: support@railway.app

## Alternative: Using the Railway CLI

If you prefer deploying via CLI:

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to your Railway project
railway link

# Deploy
railway up
```

This will use the `railway.json` configuration defined in the project root.
