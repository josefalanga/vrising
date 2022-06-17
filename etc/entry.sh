#!/bin/bash
export PATH='/usr/local/bin:/usr/bin:/bin'

mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				+quit

mkdir "${STEAMAPPDIR}/save-data/Settings" || true  

##TODO: Get the actual vrising config dynamically
# Is the config missing?
# if [ ! -f "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" ]; then
# 	# Download & extract the config
# 	wget -qO- "${DLURL}/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

# 	# Change hostname on first launch (you can comment this out if it has done its purpose)
# 	sed -i -e 's/{{SERVER_HOSTNAME}}/'"${SRCDS_HOSTNAME}"'/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
# fi

cd "${STEAMAPPDIR}"

export WINEARCH=win32

xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine VRisingServer.exe -persistentDataPath ./save-data -logFile server.log 