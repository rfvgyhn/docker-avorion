# Avorion Docker [![Docker Stars][4]][2] [![Docker Pulls][5]][2]

[Avorion][0] dedicated server

| Branch        | Version            |
| ------------- | ------------------ |
| stable/latest | [![Version][6]][2] |
| beta          | [![Version][7]][2] |

>  `beta` might not be accurate if the version number is the same as `stable`

## Usage

### Quickstart

```
docker run -d --name avorion -p 27000:27000 -p 27000:27000/udp -p 27003:27003/udp -p 27020:27020/udp -p 27021:27021/udp rfvgyhn/avorion
```

### Volumes

* `/home/steam/.avorion/galaxies/avorion_galaxy` mount for galaxy save and server configuration
* `/home/steam/.avorion/backups` mount for backups

```
docker run -d --name avorion \
   -p 27000:27000 \
   -p 27000:27000/udp \
   -p 27003:27003/udp \
   -p 27020:27020/udp \
   -p 27021:27021/udp \
   -v /host/path/saves:/home/steam/.avorion/galaxies/avorion_galaxy \
   rfvgyhn/avorion
```

Note that the container runs as non-root user 1000:1000. Make sure your mounted volume(s) have the correct permissions. (When running Docker in rootless mode, the user is remapped to a different id, usually 100999:100999)

### Configuration

Default settings will be generated and placed in the `/home/steam/.avorion/galaxies/avorion_galaxy` volume. To make changes, stop the container, modify the desired files and then restart the container.

If you enable RCON in `settings.ini`, make sure you also forward the port in docker (`-p 27015:27015`).

## Docker Images

The `latest` and `stable` tag will follow the latest stable (non-beta) [avorion server][1] release.

The `beta` tag will follow the latest beta [avorion server][1] release.

You can specify a specific version using the available [tags][3]


[0]: https://www.avorion.net/
[1]: https://www.avorion.net/forum/index.php/board,2.0.html
[2]: https://hub.docker.com/r/rfvgyhn/avorion
[3]: https://hub.docker.com/r/rfvgyhn/avorion/tags
[4]: https://img.shields.io/docker/stars/rfvgyhn/avorion.svg
[5]: https://img.shields.io/docker/pulls/rfvgyhn/avorion.svg
[6]: https://img.shields.io/github/v/release/lightlike/docker-avorion?label=stable&sort=semver
[7]: https://img.shields.io/github/v/release/lightlike/docker-avorion?include_prereleases&label=beta&sort=semver
