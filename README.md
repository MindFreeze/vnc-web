vnc-web
========
Render a website in a docker container and serve it through VNC

to build:

```
docker build -t vnc-web .
```

to start:

```
docker run -it -p 5901-5908:5901-5908 vnc-web
```

To use a different configuration, you can mount a custom config.json file when running the container:

```
docker run -p 5901-5908:5901-5908 -v /path/to/your/config.json:/home/vnc_user/config.json vnc-web
```


# TODO
- [ ] Configurable password
- [ ] Optimize container size
