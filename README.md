# deploy
Deploy Configuration for the SSE Website

## Directory Heirachy
This repostiroty splits the deployment into different parts. 
```
./
| - /website # main website stack
| - /watchtower # auto updates
```
## Contents
`website` contains the Docker Compose stack for running our production website and related services. 

It contains our:
- Our production website
- Our development website
    - An OAuth2 Github authentication proxy in front
- PostgresSQL as our DB

`watchtower` contains the Docker Compose stack for running [Watchtower](https://github.com/nicholas-fedor/watchtower/), a service for auto-updating Docker services. 

## Environment Variables
Below are the environment variables used for each respective stack:  
### Website
```
# .env
POSTGRES_PASSWORD=

OAUTH2_PROXY_CLIENT_ID=
OAUTH2_PROXY_CLIENT_SECRET=
OAUTH2_PROXY_COOKIE_SECRET=
OAUTH2_PROXY_GITHUB_ORG=
OAUTH2_PROXY_GITHUB_TEAM=
```

```
# .env.prod/.env.dev
NODE_ENV=""
NEXT_PUBLIC_ENV=""

DATABASE_URL=""

GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""

NEXTAUTH_URL=""
NEXTAUTH_SECRET=""

INTERNAL_API_URL=""
SESSION_COOKIE_NAME=""

GCAL_CLIENT_EMAIL=""
GCAL_PRIVATE_KEY=""
GCAL_CAL_ID=""

AWS_S3_BUCKET_NAME=""
AWS_S3_REGION=""
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
# Public versions for client-side URL construction
NEXT_PUBLIC_AWS_S3_BUCKET_NAME=""
NEXT_PUBLIC_AWS_S3_REGION=""

EMAIL_PROVIDER= # can do gmail or smtp
SMTP_HOST=
SMTP_PORT=
SMTP_SECURE=
SMTP_USER= # defaults to 587
SMTP_PASS= # set to true for port 465
SMTP_FROM= # defaults to SMTP_USER

# for .env.dev
STAGING_PROXY_AUTH=
STAGING_PROXY_AUTH_SECRET=
GITHUB_APP_ID=
GITHUB_APP_PRIVATE_KEY=
```

### Watchtower
```
WATCHTOWER_HTTP_API_TOKEN=
DISCORD_URL=
```

## Commands
Once the environment variable file is filled out, the stack is ready to deploy. 

Any `docker-compose` command must be run from a folder with a `docker-compose.yaml` file.

- `docker-compose up -d` - Pull any missing docker images and create all containers. Run this for initial start-up as well as any time the configuration changes to apply the configuration.
- `docker-compose pull` - Update any containers with newer images available. This will not restart the containers, you will have to run `docker-compose up -d` for that.

### Debugging Commands
- `docker-compose logs` with an optional `container-name` - Get the logs from all running containers or a specific container if a name is specified.
- `docker ps` - Get a list of all running containers.
- `docker exec -it <container-name> <command>` - Execute a command in a given container. Useful commands are `bash` or `ash` to get a shell within the container. Use `bash` for Debian/Ubuntu based images and `ash` for Alpine based images.

### Database Backup and Restore
To back up the database, run `docker exec -it postgres pg_dump -U postgres > dump_file.sql`

To restore the database, run `cat dump_file.sql | docker exec -i postgres psql -U postgres`

## Reference Links
- [Install Docker](https://docs.docker.com/engine/install/)
- [Install docker-compose](https://docs.docker.com/compose/install/)
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker development best practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker CI/CD best practices](https://docs.docker.com/ci-cd/best-practices/)
- [Complete Docker reference](https://docs.docker.com/reference/)
    - [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
    - [Docker CLI reference](https://docs.docker.com/engine/reference/commandline/cli/)
    - [docker-compose file reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)
    - [docker-compose CLI reference](https://docs.docker.com/compose/reference/overview/)
- [traefik documentation](https://doc.traefik.io/traefik/)
- [watchtower documentation](https://watchtower.nickfedor.com/)
