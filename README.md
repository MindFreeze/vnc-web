to build:

```
docker build -t vnc-web .
```

to start:

```
docker run -it -p 5901:5901 -e VNC_RESOLUTION=1920x1080 -e URL=example.com vnc-web
```


# TODO
- [ ] Configurable password
- [ ] Configurable VNC port (5901)
- [ ] Optimize container size
