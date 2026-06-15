FROM oven/bun:1.3.0-slim AS base
WORKDIR /app

# Install production dependencies using the lockfile for reproducible builds
FROM base AS deps
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --production

# Final runtime image
FROM base
ENV NODE_ENV=production
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Cloud Run injects the PORT env var (defaults to 8080)
EXPOSE 8080
CMD ["bun", "run", "src/index.ts"]
