# deploy
Deploy Configuration for the SSE Website

## Traefik
Traefik is a reverse proxy that handles SSL and routing across Docker containers. Documentation for Traefik can be found [here](https://doc.traefik.io/traefik/).

## Watchtower
[Watchtower](https://github.com/containrrr/watchtower/) is used to fetch new versions of a container when CI updates them. 

To run updates, run `curl -H "Authorization: Bearer <WATCHTOWER_HTTP_API_TOKEN>" watchtower.<BASE_DOMAIN>/v1/update`, substituting `<WATCHTOWER_HTTP_API_TOKEN>` and `<BASE_DOMAIN>` with the appropriate values from the `.env` file.

The documentation on [containrrr.dev/watchtower/](https://containrrr.dev/watchtower/) is out of date. Make sure you refer to the docs folder in the GitHub repository or the help command (accessible with `docker run -it --rm containrrr/watchtower watchtower -h`) for the latest documentation.

To generate a strong `WATCHTOWER_HTTP_API_TOKEN`, run `openssl rand -hex 16`.

## Environment Variables
Environment variables are discovered from a `.env` file. A sample `.env` file is provided below.
```
BASE_DOMAIN=
WATCHTOWER_HTTP_API_TOKEN=
POSTGRES_PASSWORD=
NODE_API_GOOGLE_CLIENT_ID=
NODE_API_GOOGLE_CLIENT_SECRET=
COURSEPLANNER_JWT_SECRET=
COURSEPLANNER_GOOGLE_CLIENT_SECRET=
COURSEPLANNER_DB_USER=
COURSEPLANNER_DB_PASS=
```

## Commands
Once the environment variable file is filled out, the stack is ready to deploy. 

- `docker-compose up -d` - Pull any missing docker images and create all containers. Run this for initial start-up as well as any time the configuration changes to apply the configuration.
- `docker-compose pull` - Update any containers with newer images available. This will not restart the containers, you will have to run `docker-compose up -d` for that.

### Database Backup and Restore
To back up the database, run `docker exec -it postgres pg_dump -U postgres > dump_file.sql`

To restore the database, run `cat dump_file.sql | docker exec -i postgres psql -U postgres`
