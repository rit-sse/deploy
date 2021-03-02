# deploy
Deploy Configuration for the SSE Website

## Traefik
Traefik is a reverse proxy that handles SSL and routing across Docker containers. Documentation for Traefik can be found [here](https://doc.traefik.io/traefik/).

## Environment Variables
Environment variables are discovered from a `.env` file. A sample `.env` file is provided below.
```
POSTGRES_PASSWORD=
NODE_API_GOOGLE_CLIENT_ID=
NODE_API_GOOGLE_CLIENT_SECRET=
COURSEPLANNER_JWT_SECRET=
COURSEPLANNER_GOOGLE_CLIENT_SECRET=
COURSEPLANNER_DB_USER=
COURSEPLANNER_DB_PASS=
```