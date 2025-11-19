FROM node:20-bullseye AS base

ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH="${PNPM_HOME}:${PATH}"
RUN corepack enable
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY .npmrc .npmrc
RUN pnpm install --frozen-lockfile

FROM base AS development
COPY . .
CMD ["pnpm", "dev", "--host", "0.0.0.0", "--port", "5173"]

FROM base AS build
COPY . .
RUN pnpm build && pnpm prune --prod

FROM node:20-bullseye-slim AS production
ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH="${PNPM_HOME}:${PATH}"
ENV NODE_ENV=production
ENV HOST=0.0.0.0

RUN corepack enable
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app ./
CMD ["node", "build"]
