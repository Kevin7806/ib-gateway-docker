#!/bin/sh

export DISPLAY=:1

rm -f /tmp/.X1-lock
Xvfb :1 -ac -screen 0 1024x768x16 &

if [ -n "$VNC_SERVER_PASSWORD" ]; then
  echo "Starting VNC server"
  /root/scripts/run_x11_vnc.sh &
fi

envsubst < "${IBC_INI}.tmpl" > "${IBC_INI}"

/root/scripts/fork_ports_delayed.sh &

# ###########################################################################
# 2023/09/10  Kelvin Lu
# ###########################################################################
# The following is using docker service secret to assign
# IBKR TWS user ID and password into following variables
#
#   TWS_USERID
#   TWS_PASSWORD
#
# ###########################################################################
TWS_USERID=$(cat /run/secrets/iStrategy-IBKR-TWS_USERID)
TWS_PASSWORD=$(cat /run/secrets/iStrategy-IBKR-TWS_PASSWORD)

echo "User: ${TWS_USERID}"
# ###########################################################################

/root/ibc/scripts/ibcstart.sh "${TWS_MAJOR_VRSN}" -g \
     "--tws-path=${TWS_PATH}" \
     "--ibc-path=${IBC_PATH}" "--ibc-ini=${IBC_INI}" \
     "--user=${TWS_USERID}" "--pw=${TWS_PASSWORD}" "--mode=${TRADING_MODE}" \
     "--on2fatimeout=${TWOFA_TIMEOUT_ACTION}"
