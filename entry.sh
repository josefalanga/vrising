#!/bin/bash
export PATH='/usr/local/bin:/usr/bin:/bin'

mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				+quit

cd "${STEAMAPPDIR}"

export WINEARCH=win64

screen -dmS vrising xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine VRisingServer.exe -persistentDataPath ./save-data -logFile server.log
while screen -list | grep -q vrising
do
    sleep 1
done