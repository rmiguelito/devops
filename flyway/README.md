podman run --rm -p 8000:80 -e PGADMIN_DEFAULT_EMAIL=sdmiguelvieira@gmail.com -e PGADMIN_DEFAULT_PASSWORD=admin docker.io/dpage/pgadmin4

spawnctl create data-container --image postgres-pagila:v11.0 --name spawn-tutorial --lifetime 6h