FROM cm2network/steamcmd:latest

LABEL maintainer="jose.falanga@gmail.com"

ENV STEAMAPPID 1829350
ENV STEAMAPP vrising-server
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV DLURL https://raw.githubusercontent.com/josefalanga/vrising

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wine \
		wget=1.21-1+deb11u1 \
		ca-certificates=20210119 \
		lib32z1=1:1.2.11.dfsg-2+deb11u1 \
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

##TODO: THIS LOOKS MODIFIABLE
# Expose ports
# EXPOSE 27015/tcp \
# 	27015/udp \
# 	27020/udp