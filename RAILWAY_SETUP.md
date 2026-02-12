# Railway.app Deployment - Setup Summary

I've prepared your Tabbycat application for deployment to Railway.app. Here's what was added:

## 📁 Files Created

### 1. **railway.json**
- Railway configuration file
- Specifies to use the Dockerfile for building
- Sets the start command to use the deployment script

### 2. **bin/railway-serve.sh**
- Startup script for your application
- Runs database migrations
- Collects static files
- Starts Gunicorn web server

### 3. **tabbycat/settings/railway.py**
- Django settings configured for Railway.app
- Handles PostgreSQL database connection via `DATABASE_URL`
- Handles Redis caching via `REDIS_URL`
- HTTPS enforcement for security
- Supports optional Sentry error tracking

### 4. **tabbycat/settings/__init__.py** (Updated)
- Added detection for `ON_RAILWAY` environment variable
- Automatically loads railway.py settings when deploying to Railway

### 5. **RAILWAY_QUICK_START.md**
- Step-by-step quick start guide
- Follow this for fastest deployment

### 6. **RAILWAY_DEPLOYMENT.md**
- Complete deployment guide
- Troubleshooting section
- Production checklist
- Advanced configuration options

## 🚀 Quick Deployment Steps

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Add Railway deployment configuration"
   git push
   ```

2. **Create Railway Project**
   - Go to [railway.app](https://railway.app)
   - Click "Create New Project"
   - Select "Deploy from GitHub repo"
   - Choose your tabbycat repository

3. **Add Services**
   - Click "+ New" → Database → PostgreSQL
   - Click "+ New" → Database → Redis

4. **Set Environment Variables**
   - `ON_RAILWAY=1` (crucial!)
   - `DJANGO_SECRET_KEY=<random-string>`
   - `TAB_DIRECTOR_EMAIL=<your-email>`
   - `TIME_ZONE=Etc/UTC`
   - `USING_NGINX=0`

5. **Configure Start Command**
   - Set to: `./bin/railway-serve.sh`

6. **Deploy**
   - Click "Deploy" button
   - Watch the logs

## ⚙️ Key Configuration Details

### Database Connection
- Railway automatically provides `DATABASE_URL` when you add PostgreSQL
- The railway.py settings file reads this automatically

### Cache / WebSocket Support
- Railway automatically provides `REDIS_URL` when you add Redis
- Used for Django cache and Django Channels

### Static Files
- Served directly by Gunicorn (no Nginx proxy needed)
- Collected automatically during deployment

### HTTPS/SSL
- Railway handles SSL at the edge automatically
- Django will enforce HTTPS redirects

## 🔐 Environment Variables Explained

| Variable | Purpose | Example |
|----------|---------|---------|
| `ON_RAILWAY` | Tells Django to use railway.py settings | `1` |
| `DJANGO_SECRET_KEY` | Secure encryption key | Generate with Django |
| `TAB_DIRECTOR_EMAIL` | Tournament director email | `admin@example.com` |
| `TIME_ZONE` | Server timezone | `Australia/Sydney` |
| `USING_NGINX` | Disable Nginx proxy | `0` |

## 📖 Documentation Links

- **Railway Docs**: https://docs.railway.app
- **Tabbycat Docs**: https://tabbycat.readthedocs.io
- **Django Deployment**: https://docs.djangoproject.com/en/stable/howto/deployment/

## ✅ What's Configured

- ✅ Docker build process
- ✅ Python 3.11 environment
- ✅ PostgreSQL database connection
- ✅ Redis cache and Channels support
- ✅ Static files collection
- ✅ Database migrations
- ✅ Django settings for Railway
- ✅ Environment variable handling
- ✅ HTTPS enforcement

## ⚠️ Important Notes

1. **First Deployment**: Database migrations will run automatically
2. **Secret Key**: Must be a strong random string (50+ chars)
3. **Email Configuration**: Set TAB_DIRECTOR_EMAIL for system emails
4. **Backups**: Enable PostgreSQL backups in production
5. **Monitoring**: Check Railway logs if deployment fails

## 🆘 If You Have Issues

1. **Check Build Logs** - Railway dashboard shows build process
2. **Check Deployment Logs** - Shows runtime errors
3. **Check Service Status** - Verify PostgreSQL and Redis are running
4. **Common Fix** - Try redeploying after fixing environment variables

---

**Next Step**: Follow [RAILWAY_QUICK_START.md](RAILWAY_QUICK_START.md) to get your app live!

Questions? Reference [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) for detailed troubleshooting.
