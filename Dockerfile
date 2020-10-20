FROM cm2network/steamcmd:steam as build
ARG VERSION
ARG INSTALL_ARGS
RUN set -x \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
		+login anonymous \
		+force_install_dir /home/steam/avorion-dedicated \
		+app_update 565060$INSTALL_ARGS validate \
		+quit
WORKDIR /home/steam/avorion-dedicated
RUN rm -r steamapps && \
    rm launcher.sh

FROM debian:stretch-slim
LABEL org.opencontainers.image.title="Avorion Dedicated Server"
LABEL org.opencontainers.image.url="https://www.avorion.net/"

ARG DEBIAN_FRONTEND=noninteractive
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates libsdl2-2.0-0 \
    && rm -rf /var/lib/apt/lists/*
RUN set -x \
    && useradd -m steam \
    && mkdir -p /home/steam/.avorion/galaxies/avorion_galaxy \
    && chown -R steam:steam /home/steam
WORKDIR /home/steam/avorion-dedicated
COPY --from=build --chown=steam /home/steam/avorion-dedicated .
USER steam
VOLUME /home/steam/.avorion/galaxies/avorion_galaxy

EXPOSE 27000/tcp
EXPOSE 27000/udp
EXPOSE 27003/udp
EXPOSE 27020/udp
EXPOSE 27021/udp

ARG CREATED
ARG REVISION
ARG SOURCE
ARG VERSION

LABEL org.opencontainers.image.created=$CREATED
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.source=$SOURCE
LABEL org.opencontainers.image.version=$VERSION

# down here we are basically copying the server.sh, since that one does not `exec`
# since now the AvorionServer is pid1 we can use `stop` commands since SIGTERM is passed through
# SIGTERM on AvorionServer causes a clean shutdown with saving, graceful connection closing and everything

# env from server.sh
ENV LD_LIBRARY_PATH="/home/steam/avorion-dedicated:/home/steam/avorion-dedicated/linux64"
# extra arguments can be supplied with the run command of your container runtime (equals the $@ of server.sh)
ENTRYPOINT ["./bin/AvorionServer", "--galaxy-name", "avorion_galaxy"]

