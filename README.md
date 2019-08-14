# Avorion Docker

[Avorion][0] dedicated server

## Usage

### Quickstart

```
docker run -d --name avorion -p 27000:27000 -p 27000:27000/udp -p 27003:27003/udp -p 27020:27020/udp -p 27021:27021/udp rfvgyhn/avorion
```

### Volumes

* `/data` mount for galaxy save and server configuration

```
docker run -d --name avorion \
   -p 27000:27000 \
   -p 27000:27000/udp \
   -p 27003:27003/udp \
   -p 27020:27020/udp \
   -p 27021:27021/udp \
   -v /host/path/saves:/data \
   rfvgyhn/avorion
```

### Configuration

Default settings will be generated and placed in the `/data` volume. To make changes, stop the container, modify the desired files and then restart the container.

If you enable RCON in `settings.ini`, make sure you also forward the port in docker (`-p 27015:27015`).

## Docker Images

The `latest` tag will follow the latest [avorion server][1] release
(including beta releases).

The `stable` tag will follow the latest stable (non-beta) [avorion server][1] release.

You can specify a specific version using the available [tags][2]


[0]: https://www.avorion.net/
[1]: https://www.avorion.net/forum/index.php/board,2.0.html
[2]: https://cloud.docker.com/repository/docker/rfvgyhn/avorion/tags
