# My home Labs

## Build a container image to work in
<br/>

Run a small `alpine linux` container where we can install tools we need <br/>

```
podman build -t container-lab -f Dockerfile
podman run -it --rm -v ${HOME}:/root -v ${PWD}:/work -w /work --net host container-lab sh
```