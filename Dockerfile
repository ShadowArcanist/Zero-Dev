FROM oven/bun:canary

WORKDIR /app

# Install turbo globally
RUN bun install -g next turbo


COPY package.json bun.lock turbo.json ./

RUN mkdir -p apps packages

COPY apps/*/package.json ./apps/
COPY packages/*/package.json ./packages/
COPY packages/tsconfig/ ./packages/tsconfig/

RUN bun install

COPY . .

# Installing with full context. Prevent missing dependencies error. 
RUN bun install

# Build the app (this stage requires environment variables)
ARG NEXT_PUBLIC_APP_URL
ARG DATABASE_URL
ARG BETTER_AUTH_SECRET
ARG BETTER_AUTH_URL
ARG GOOGLE_CLIENT_ID
ARG GOOGLE_CLIENT_SECRET
ARG GOOGLE_REDIRECT_URI
ARG GITHUB_CLIENT_ID
ARG GITHUB_CLIENT_SECRET
ARG REDIS_URL
ARG REDIS_TOKEN

ENV NEXT_PUBLIC_APP_URL=$NEXT_PUBLIC_APP_URL
ENV DATABASE_URL=$DATABASE_URL
ENV BETTER_AUTH_SECRET=$BETTER_AUTH_SECRET
ENV BETTER_AUTH_URL=$BETTER_AUTH_URL
ENV GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID
ENV GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET
ENV GOOGLE_REDIRECT_URI=$GOOGLE_REDIRECT_URI
ENV GITHUB_CLIENT_ID=$GITHUB_CLIENT_ID
ENV GITHUB_CLIENT_SECRET=$GITHUB_CLIENT_SECRET
ENV REDIS_URL=$REDIS_URL
ENV REDIS_TOKEN=$REDIS_TOKEN

RUN bun run build 

ENV NODE_ENV=production

# Resolve Nextjs TextEncoder error.
ENV NODE_OPTIONS=--no-experimental-fetch

EXPOSE 3000

CMD ["bun", "run", "start"]
