# Athloop Documentation

This repository contains:
- **Project documentation** (roadmap, changelog, integration plans)
- **Static web files** for App Store requirements (privacy policy, landing page)

---

## 📚 Project Documentation

### Core Documents
- **[ROADMAP.md](ROADMAP.md)** - Complete version planning and feature roadmap (v1.0 → v2.0)
- **[CHANGELOG.md](CHANGELOG.md)** - Detailed version history and changes
- **[STRAVA_INTEGRATION.md](STRAVA_INTEGRATION.md)** - Complete Strava integration plan (v1.4)

### Current Project Status
- **Live on App Store**: v1.0 (Published Oct 13, 2025)
- **In Review**: v1.2 (Oct 2025)
- **In Development**: v1.3 (Critical bug fixes - Target: Early Nov 2025)
- **Planned**: v1.4 (Strava integration - Target: Late Nov 2025)

---

## 🌐 Static Web Files

These files are deployed and publicly accessible for App Store requirements:

- **[index.html](index.html)** - Athloop landing page
- **[privacy.html](privacy.html)** - Privacy policy (required by App Store)
- **[nginx.conf](nginx.conf)** - Nginx configuration for Railway deployment
- **[Dockerfile](Dockerfile)** - Docker configuration for static site hosting
- **[railway.json](railway.json)** - Railway.app deployment configuration

### Deployed URLs
- **Landing Page**: https://athloop.app
- **Privacy Policy**: https://athloop.app/privacy.html

---

## 🔗 Related Repositories

- **coach-ai-backend** - FastAPI REST API + Claude AI integration
- **coach-ai-frontend** - Native iOS app (SwiftUI)
- **athloop-docs** - This repository (documentation + web files)

---

## 🚀 Deployment

This repository is deployed to Railway.app:
- **URL**: https://athloop.app
- **Deployment**: Automatic from `main` branch
- **Service**: Static Nginx server (via Dockerfile)

### Local Development

```bash
# Serve locally with Python
python3 -m http.server 8080

# Or with nginx using Docker
docker build -t athloop-docs .
docker run -p 8080:8080 athloop-docs
```

### Updating the Website

```bash
# 1. Make changes to HTML files
# 2. Commit and push
git add index.html privacy.html
git commit -m "Update landing page"
git push origin main

# 3. Railway auto-deploys in ~1 minute
# 4. Verify at https://athloop.app
```

---

## 📖 Quick Links

### For Developers
- [Version Roadmap](ROADMAP.md) - What's coming next?
- [Changelog](CHANGELOG.md) - What changed in each version?
- [Strava Integration Plan](STRAVA_INTEGRATION.md) - Complete implementation guide

### For Users
- [Privacy Policy](https://athloop.app/privacy.html) - How we handle your data
- [Athloop App](https://athloop.app) - Download from App Store

---

**Last Updated**: 2025-10-18
**Repository**: https://github.com/cgranetgithub/athloop-docs
