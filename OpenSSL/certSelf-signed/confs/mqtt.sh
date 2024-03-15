#!/bin/sh

export PJ_ROOT=`pwd`
export PJ_PREFIX=${PJ_ROOT}/install

export CERT_TYPE="mqtt"
export CERT_DEFINE_DIR="$PJ_ROOT/certDefines/$CERT_TYPE"

export CERT_EXT="$CERT_DEFINE_DIR/alt.ext"
export CERT_BITS="2048"
export CERT_DAYS="3650"

export CERT_CA_CONF="$CERT_DEFINE_DIR/ca.conf"
export CERT_CA_DIR="$PJ_PREFIX/ca"
export CERT_CA="$CERT_CA_DIR/mqtt.ca"
export CERT_CA_KEY="$CERT_CA_DIR/mqtt.ca.key"
export CERT_CA_CSR="$CERT_CA_DIR/mqtt.csr"
export CERT_CA_SRL="$CERT_CA_DIR/mqtt.srl"

export CERT_SRV_CONF="$CERT_DEFINE_DIR/server.conf"
export CERT_SRV_DIR="$PJ_PREFIX/srv"
export CERT_SRV_CERT="$CERT_SRV_DIR/mqtt_srv.crt"
export CERT_SRV_KEY="$CERT_SRV_DIR/mqtt_srv.key"
export CERT_SRV_CSR="$CERT_SRV_DIR/mqtt_srv.csr"

export CERT_CLI_CONF="$CERT_DEFINE_DIR/client.conf"
export CERT_CLI_DIR="$PJ_PREFIX/client"
export CERT_CLI_CERT="$CERT_CLI_DIR/mqtt_beex.crt"
export CERT_CLI_KEY="$CERT_CLI_DIR/mqtt_beex.key"
export CERT_CLI_CSR="$CERT_CLI_DIR/mqtt_beex.csr"
