# deploy
Deploy Configuration for the SSE Website

## Traefik
Traefik is a reverse proxy that handles SSL and routing across Docker containers. Documentation for Traefik can be found [here](https://doc.traefik.io/traefik/).

<!-- (commented out because the web dashboard is disabled now)
### HTTP Basic Authentication
Traefik uses htpasswd files for basic authentication. The `htpasswd` utility is provided by the package `apache2-utils` on Debian-based systems. To add or modify an entry, use `htpasswd -c /path/to/file username`.
-->

## Watchtower
[Watchtower](https://github.com/containrrr/watchtower/) is used to fetch new versions of a container when CI updates them. 

To run updates, run `curl -sSL -H "Authorization: Bearer <WATCHTOWER_HTTP_API_TOKEN>" <BASE_DOMAIN>/watchtower/v1/update`, substituting `<WATCHTOWER_HTTP_API_TOKEN>` and `<BASE_DOMAIN>` with the appropriate values from the `.env` file.

The documentation on [containrrr.dev/watchtower/](https://containrrr.dev/watchtower/) is out of date. Make sure you refer to the docs folder in the GitHub repository or the help command (accessible with `docker run -it --rm containrrr/watchtower watchtower -h`) for the latest documentation.

To generate a strong `WATCHTOWER_HTTP_API_TOKEN`, run `openssl rand -hex 16`.

## PostgreSQL
Our current database is postgres. Do NOT add a port bind to the postgres container unless you absolutely know what you are doing. If done incorrectly, this will expose our database to the internet. Our database currently does not have a password. It is global read-write without any credentials. Setting up a port bind on the container will allow anyone with the url to modify our database. Again, do *NOT* do this.

## pubwebs
[pubwebs](https://github.com/galenguyer/pubwebs) provides web hosting for each user account. It mounts the `/home` folder as a read-only filesystem so in nearly impossible event a static webserver is compromised, no data can be written to the host system. There is no support for PHP or any type of server-side scripting. All pages must be static files.

User content is available at `https://<BASE_DOMAIN>/~<USERNAME>/`. Content is served from the user's `public_html` folder. Should an `index.html` file be available, it will be provided as the folder index. Otherwise, a listing of all files in the directory will be shown. Currently there is no way to disable this but that will likely change in the future.

To ensure the `public_html` folder is created automatically, ensure the folder exists within `/etc/skel`. This will ensure the folder is created for each user when their account is created.

## Environment Variables
Environment variables are discovered from a `.env` file. A sample `.env` file is provided below.
```
BASE_DOMAIN=
DEV_DOMAIN=
WATCHTOWER_HTTP_API_TOKEN=
POSTGRES_PASSWORD=
NODE_API_GOOGLE_CLIENT_ID=
NODE_API_GOOGLE_CLIENT_SECRET=
DEV_NODE_API_GOOGLE_CLIENT_ID=
DEV_NODE_API_GOOGLE_CLIENT_SECRET=
COURSEPLANNER_JWT_SECRET=
COURSEPLANNER_GOOGLE_CLIENT_SECRET=
COURSEPLANNER_DB_USER=
COURSEPLANNER_DB_PASS=
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
- [watchtower documentation](https://github.com/containrrr/watchtower/tree/main/docs)
