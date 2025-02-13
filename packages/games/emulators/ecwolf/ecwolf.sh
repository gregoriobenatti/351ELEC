#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)
# Copyright (C) 2021-present 351ELEC (https://github.com/351ELEC)

. /etc/profile

EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
CONFIG_DIR="/storage/.config/distribution/ecwolf"
CONFIG_FILE="${CONFIG_DIR}/ecwolf.cfg"
SAVE_DIR="/storage/roms/gamedata/ecwolf"

if [ ! -L "/storage/.config/ecwolf" ]
then
  ln -sf "/storage/.config/distribution/ecwolf" "/storage/.config/ecwolf"
fi

if [ ! -f "/storage/.config/distribution/ecwolf/ecwolf.cfg" ]
then
  cp -rf /usr/config/distribution/ecwolf/ecwolf.cfg /storage/.config/distribution/ecwolf/
fi

mkdir -p ${SAVE_DIR}

params=" --config ${CONFIG_FILE} --savedir ${SAVE_DIR}"

# data can be SD2 SD3 SOD WL6 or N3D and it's passed as the ROM
DATA=${1#*.}

# If its a mod (extension .ecwolf) read the file and parse the data
if [ ${DATA} == "ecwolf" ]; then
  dos2unix "${1}"
  while IFS== read -r key value; do
    if [ "$key" == "DATA" ]; then
      params+=" --data $value"
    fi
    if [ "$key" == "PK3" ]; then
      params+=" --file $value"
    fi
    if [ "$key" == "PK3_1" ]; then
      params+=" --file $value"
    fi
    if [ "$key" == "PK3_2" ]; then
      params+=" --file $value"
    fi
    if [ "$key" == "PK3_3" ]; then
      params+=" --file $value"
    fi
    if [ "$key" == "PK3_4" ]; then
      params+=" --file $value"
    fi
  done < "${1}"
else
  params+=" --data ${DATA}"
fi

if [[ "$EE_DEVICE" == RG351P ]]; then
  params+=" --res 480 320"
fi
if [[ "$EE_DEVICE" == RG351V ]] || [[ "$EE_DEVICE" == RG351MP ]]; then
  params+=" --res 640 480"
fi

cd "${CONFIG_DIR}"
/usr/bin/ecwolf ${params} > /tmp/logs/ecwolf.log 2>&1
