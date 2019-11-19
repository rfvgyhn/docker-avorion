FROM cm2network/steamcmd:steam as build
ARG VERSION
ARG INSTALL_ARGS
RUN set -x \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
		+login anonymous \
		+force_install_dir /home/steam/avorion-dedicated \
		+app_update 565060$INSTALL_ARGS validate \
		+quit

FROM debian:stretch-slim
LABEL org.opencontainers.image.title="Avorion Dedicated Server"
LABEL org.opencontainers.image.url="https://www.avorion.net/"

ARG DEBIAN_FRONTEND=noninteractive
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
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

ENTRYPOINT ["./server.sh"]