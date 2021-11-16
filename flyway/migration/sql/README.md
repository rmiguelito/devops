podman build -t flyway:3 -f Dockerfile 
podman tag flyway:3 docker.io/rmiguel/flyway:3
podman push flyway:3 docker.io/rmiguel/flyway:3


podman login docker.io