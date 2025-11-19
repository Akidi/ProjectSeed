# ProjectSeed Infrastructure Starter

This repo bootstraps a SvelteKit/Svelte 5 app with hardened Postgres + Redis services, reproducible environment files, and Docker/Podman compose helpers. Everything is driven by templates so teams can re-run the setup whenever they need a new environment.

## Requirements

- Windows PowerShell 7+ (scripts use strict mode)
- Docker Desktop **or** Podman (`podman machine init` required on Windows)
- Node 20 / PNPM (already configured in `app/`)

## Workflow

0. (Optional) Run the interactive helper (or the single-command dev quickstart) so you don’t have to memorize script flags:

   ```powershell
   # menu-driven helper
   pwsh -File .\scripts\ProjectSeed.ps1

   # or run everything for dev (init + compose up) in one shot
   pwsh -File .\scripts\ProjectSeed.ps1 -QuickstartDev
   ```

   Option 1 seeds/updates an environment, option 2 wraps compose actions (up/down/logs/ps), and option 3 exits.

1. Generate config for an environment (dev/staging/prod/custom):

   ```powershell
   pwsh -File .\scripts\Initialize-Environment.ps1 -Environment dev
   ```

   - Creates `.env.dev`, `infrastructure/postgres/dev/init.sql`, and `infrastructure/redis/dev/{redis.conf,users.acl,network.conf}` using templates under `templates/`.
   - Secrets use `[A-Za-z0-9_-]` 40-char passwords that are shell-safe.
   - Reserves a `/24` in the `172.28/29/30/31.0.0` range; if the subnet already exists locally it picks another.
   - When `-Environment dev`, it symlinks `app/.env -> ../.env.dev` so `pnpm dev` works immediately.
   - Re-running preserves existing secrets by default; pass `-RegenerateSecrets` to force new credentials.
   - The script auto-detects Podman vs Docker and tailors its “next steps” command accordingly.

2. Start or stop the stack with Docker or Podman Compose:

   ```powershell
   # Bring dev profile up (live-reload app container + db + redis)
   pwsh -File .\scripts\Manage-Stack.ps1 -Environment dev -Action up

   # Shut everything down and ensure the custom network is removed
   pwsh -File .\scripts\Manage-Stack.ps1 -Environment dev -Action down
   ```

- Profiles: `dev` (hot-reload with volume mounts + host port) and `prod` (optimized build, only exposes the app to the internal services network).
- The script detects Docker vs Podman automatically and always runs with `--env-file .env.<environment>`.
- If you call Compose manually, run `docker compose -f docker-compose.yml --env-file .env.<env> --profile <profile> up -d` (same for Podman).

3. Inspect logs or running containers:

   ```powershell
   pwsh -File .\scripts\Manage-Stack.ps1 -Environment staging -Action logs
   pwsh -File .\scripts\Manage-Stack.ps1 -Environment staging -Action ps
   ```

## Reverse Proxy Integration

- The compose network (`${SERVICES_NETWORK_NAME}`, default `projectseed_services`) is `attachable`, so an external reverse proxy like Nginx Proxy Manager, Traefik, or Caddy just needs to join that network and forward traffic to `app-prod:${APP_PROD_PORT}`.
- By default only the `app-dev` service publishes a host port. `app-prod` only exposes the internal port to the services network so the reverse proxy is the single ingress point.
- If you use something other than NPM, update the README note and adjust headers as needed; the networking model already supports other proxies.

## Podman Notes

- Ensure `podman machine set --rootful` (or install the Windows Podman service) if you want to create bridge networks with custom subnets.
- `scripts/Manage-Stack.ps1` works with `podman compose`; if you prefer manual commands, run `podman compose --env-file .env.dev --profile dev up -d`.

## Files & Templates

- `templates/env/.env.template` – base template for `.env.<env>` files. Create `templates/env/.env.<env>.template` to override specifics.
- `templates/postgres/init.sql.template` – seeds roles (`app_runtime`, `api_worker`, `app_reader`, `app_migrator`) with least-privilege grants and SCRAM passwords.
- `templates/redis/redis.conf.template` – hardened Redis configuration with ACL enforcement and disabled dangerous commands.
- `templates/redis/network.conf.template` – injects the environment-specific bind/listen IP so Redis only listens on the static container address and localhost.
- `templates/redis/users.acl.template` – ACL entries for admin/api/readonly clients.
- `docker-compose.yml` – SvelteKit app (`app-dev` and `app-prod` profiles), Postgres, and Redis on the isolated `services` network (custom 172.x subnet, attachable for proxies). The Redis service’s startup command sets `vm.overcommit_memory=1` before launching redis-server.
- `scripts/Initialize-Environment.ps1` – fills templates, generates secrets, creates per-environment config folders, and links `app/.env`.
- `scripts/Manage-Stack.ps1` – thin compose wrapper that ensures the custom network gets removed during teardown.
- `scripts/ProjectSeed.ps1` – interactive entry point (with a `-QuickstartDev` shortcut) that drives the two scripts above.

## Security Defaults

- Postgres uses SCRAM-SHA-256 auth (`POSTGRES_INITDB_ARGS`), data checksums, and user-specific roles for admin, runtime, readonly, and migrations.
- Redis default user is disabled; each role uses ACL scopes and random passwords, with dangerous commands renamed.
- Redis containers attempt to set `vm.overcommit_memory=1` during startup (falls back silently if the container lacks permission). If you still see warnings, run `sysctl vm.overcommit_memory=1` on the host.
- Redis containers bind to their static service IP (`NETWORK_REDIS_IP`) plus localhost, and the services network does **not** publish any ports for Postgres/Redis; only the app container connects internally.
- Passwords are randomly generated each time you create a new environment unless you explicitly regenerate them.

## Customization Tips

- For different hostnames, edit the `PUBLIC_ORIGIN` entry in `.env.<env>`. The script seeds staging/prod with placeholder domains to prompt customization.
- Need more users or queue backends? Add new placeholders into the templates and extend `scripts/Initialize-Environment.ps1`.
- If a specific subnet is required, add it to the candidates array near the top of `Initialize-Environment.ps1`.
- Adjust Redis binding/static IP by editing `NETWORK_REDIS_IP` inside `.env.<env>` (defaults to the `.10` address inside the reserved subnet).

## Reverse Proxy Reminder

This stack is tuned for Nginx Proxy Manager out of the box, but any reverse proxy that can attach to `projectseed_services` and forward to `app-prod:${APP_PROD_PORT}` will work. Update the docs if your team standardizes on Traefik, Caddy, etc.

## Quickstart (Dev)

1. `pnpm install` inside `app/` if you haven’t already.
2. Run the menu helper (option `1` then `2`) **or** execute `pwsh -File .\scripts\ProjectSeed.ps1 -QuickstartDev` to initialize + start the stack automatically.
3. If you used the menu, choose option `2` → `up` (rebuild optional) to launch the compose services.
4. In another terminal run `cd app && pnpm dev` if you prefer host-side dev; otherwise the compose `app-dev` container already serves on `http://localhost:5173`.
5. When finished, rerun option `2` → `down` to stop containers and free the custom network.
