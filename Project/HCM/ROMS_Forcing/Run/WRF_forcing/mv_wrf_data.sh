export DATA_DIR=${PWD}/Pre/DATA
export SAVE_DIR=${PWD}/WRF

rm -rf ${SAVE_DIR}
mkdir  ${SAVE_DIR}

mv ${DATA_DIR}/*.nc  ${SAVE_DIR}/
rm -rf ${DATA_DIR}
