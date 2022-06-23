FROM ubuntu:latest

LABEL maintainer="jose.falanga@gmail.com"
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
                lib32stdc++6 \
                lib32gcc-s1 \
                wget\
                ca-certificates \
                nano \
                curl \
                locales \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	# Create unprivileged user
	&& useradd -u "${PUID}" -m "${USER}" \
	# Download SteamCMD, execute as user
	&& su "${USER}" -c \
		"mkdir -p \"${STEAMCMDDIR}\" \
		&& wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
		&& \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
		&& mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
		&& ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
		&& ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
		&& ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	# Symlink steamclient.so; So misconfigured dedicated servers can find it
	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
	# Clean up
        && apt-get remove --purge --auto-remove -y \
                wget \
        && rm -rf /var/lib/apt/lists/*

WORKDIR ${STEAMCMDDIR}

ENV STEAMAPPID 1829350
ENV STEAMAPP vrising-server
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV DLURL https://raw.githubusercontent.com/josefalanga/vrising

RUN set -x \
	# Install, update & upgrade packages
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		screen \
		nano \
		htop \
		wine \
		xvfb \
		wget\
		ca-certificates\
		lib32z1\
	&& mkdir -p "${STEAMAPPDIR}" \
	# Add entry script
	&& wget --max-redirect=30 "${DLURL}/main/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/* 

##TODO: THIS LOOKS DELETEABLE
# ENV SRCDS_FPSMAX=300 \
# 	SRCDS_TICKRATE=128 \
# 	SRCDS_PORT=27015 \
# 	SRCDS_TV_PORT=27020 \
# 	SRCDS_CLIENT_PORT=27005 \
# 	SRCDS_NET_PUBLIC_ADDRESS="0" \
# 	SRCDS_IP="0" \
# 	SRCDS_LAN="0" \
# 	SRCDS_MAXPLAYERS=14 \
# 	SRCDS_TOKEN=0 \
# 	SRCDS_RCONPW="changeme" \
# 	SRCDS_PW="changeme" \
# 	SRCDS_STARTMAP="de_dust2" \
# 	SRCDS_REGION=3 \
# 	SRCDS_MAPGROUP="mg_active" \
# 	SRCDS_GAMETYPE=0 \
# 	SRCDS_GAMEMODE=1 \
# 	SRCDS_HOSTNAME="New \"${STEAMAPP}\" Server" \
# 	SRCDS_WORKSHOP_START_MAP=0 \
# 	SRCDS_HOST_WORKSHOP_COLLECTION=0 \
# 	SRCDS_WORKSHOP_AUTHKEY="" \
# 	ADDITIONAL_ARGS=""

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27015/tcp 27036/tcp 27015-27016/udp 27031-27036/udp