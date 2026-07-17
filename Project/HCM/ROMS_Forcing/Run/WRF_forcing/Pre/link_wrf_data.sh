export DATA_DIR=/home/liugl/Clark/application/BYECS/BYECS_6km/Result/BYECS_WRF/WRF
export SAVE_DIR=${PWD}/DATA

rm -rf ${SAVE_DIR}
mkdir  ${SAVE_DIR}

ln -s ${DATA_DIR}/wrfout*  ${SAVE_DIR}/
