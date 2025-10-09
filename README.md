# Athloop Docs

Public documentation and legal pages for Athloop iOS app.

## Pages

- **index.html** - Landing page
- **privacy.html** - Privacy policy

## Deployment

Deployed on Railway with custom domain athloop.app

**URLs:**
- Landing: https://athloop.app/
- Privacy: https://athloop.app/privacy.html

## Local Development

```bash
# Serve locally with Python
python3 -m http.server 8080

# Or with nginx using Docker
docker build -t athloop-docs .
docker run -p 8080:8080 athloop-docs
```

## Railway Setup

1. Connect this GitHub repository to Railway
2. Railway will automatically detect the Dockerfile
3. Add custom domain: athloop.app
4. Deploy

## App

Main app repository is private. This repo only contains public-facing documentation required for App Store submission.
