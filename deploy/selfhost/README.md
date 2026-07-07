# Self-host Happy

This setup keeps build work in GitHub Actions and keeps the VPS as a runtime-only host.

## 1. Build the server image

Run the `Build self-host Happy Server image` workflow manually from GitHub Actions.
Use `latest` for `image_tag` unless you want a pinned release tag.

The image is pushed to:

```text
ghcr.io/2728816908/happy-server:latest
```

If the VPS cannot pull the image, make the GitHub package public or run
`docker login ghcr.io` on the VPS.

## 2. Run on the VPS

Copy `docker-compose.yml` and `.env.example` to the VPS, then:

```bash
cp .env.example .env
openssl rand -hex 32
```

Edit `.env`:

```env
PUBLIC_URL=http://YOUR_SERVER_IP:3005
HAPPY_SERVER_IMAGE=ghcr.io/2728816908/happy-server:latest
HANDY_MASTER_SECRET=PASTE_RANDOM_SECRET_HERE
HAPPY_SERVER_PORT=3005
```

Start:

```bash
docker compose up -d
curl http://YOUR_SERVER_IP:3005
```

The root endpoint should include:

```text
Welcome to Happy Server!
```

## 3. Point the desktop CLI at the server

Windows:

```powershell
.\configure-happy-server.ps1 -ServerUrl "http://YOUR_SERVER_IP:3005"
happy auth login
happy daemon start
happy codex
```

macOS/Linux:

```bash
./configure-happy-server.sh "http://YOUR_SERVER_IP:3005"
happy auth login
happy daemon start
happy codex
```

## 4. Point the app at the server

Open the app's Server Configuration screen and set the same URL.

If building an Android APK from GitHub Actions, run `Build Android APK` with:

```text
server_url = http://YOUR_SERVER_IP:3005
app_env = production
```

For production use, prefer an HTTPS domain and set `PUBLIC_URL` to the HTTPS URL.
