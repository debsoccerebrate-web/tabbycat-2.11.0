# Quick Start: Deploy Tabbycat to Railway.app

## 1. Prepare Your Repository

```bash
# Make sure you've committed the Railway config files
git add railway.json bin/railway-serve.sh RAILWAY_DEPLOYMENT.md
git commit -m "Add Railway.app deployment files"
git push origin main
```

## 2. Create Railway Project

1. Go to [railway.app](https://railway.app)
2. Sign up or log in
3. Click **"Create New Project"**
4. Select **"Deploy from GitHub repo"**
5. Authorize Railway with GitHub
6. Select your **tabbycat** repository
7. Railway will automatically detect `Dockerfile` and start building

## 3. Add Services (PostgreSQL + Redis)

While Railway builds your app:

### PostgreSQL
1. In your Railway dashboard, click **"+ New"**
2. Select **"Database"** → **"PostgreSQL"**
3. Wait for provisioning (it will auto-add `DATABASE_URL`)

### Redis
1. Click **"+ New"** again
2. Select **"Database"** → **"Redis"**
3. Wait for provisioning (it will auto-add `REDIS_URL`)

## 4. Set Environment Variables

Go to **your web service** → **Variables** and add:

```env
ON_RAILWAY=1
DJANGO_SECRET_KEY=<generate-a-secret-key>
TAB_DIRECTOR_EMAIL=<your-email@example.com>
TIME_ZONE=Etc/UTC
USING_NGINX=0
```

**Generate a secret key:**
```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

## 5. Configure Build Command

In your web service settings:

- **Build Command**: Leave empty (uses Dockerfile)
- **Start Command**: Set to:
  ```
  ./bin/railway-serve.sh
  ```

## 6. Deploy

Click the **"Deploy"** button. Railway will:
1. Build the Docker image
2. Run migrations
3. Collect static files
4. Start the application

**That's it!** Your app will be live at the URL shown in Railway dashboard.

## Common Issues

**Port not binding?**
- Railway uses `PORT` env var. Gunicorn should read this automatically.

**Static files missing (CSS/JS broken)?**
- Check build logs for `collectstatic` errors
- Ensure `USING_NGINX=0` is set (we don't use Nginx on Railway)

**Database won't connect?**
- Verify PostgreSQL service is running
- Check `DATABASE_URL` is in Variables
- Review PostgreSQL service logs

**Static files not served from Redis?**
- Verify Redis service is running
- Check `REDIS_URL` is in Variables

**"Bad Request" errors?**
- Your domain should be in Railway's custom domain settings
- `ALLOWED_HOSTS = ['*']` is already set

## View Logs

Click on your service and select the **Deployment** or **Logs** tab to debug issues.

## Next Steps

- Add custom domain (in Railway Domains settings)
- Set up monitoring/alerts
- Scale services for production load
- Configure backups for PostgreSQL
- Set `DEBUG=False` in production

---

See [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) for the complete guide.
