#!/bin/bash

cd "$(dirname $0)"

apply() {
  UBUNTU_VERSION=$1
  LIBICU_VERSION=$2
  VSTS_AGENT_VERSION=$3
  VERSIONED_SRC=
  VERSIONED_DIR=

  if [ -z "$VSTS_AGENT_VERSION" ]; then
    rm -rf $UBUNTU_VERSION
    mkdir $UBUNTU_VERSION
  else
    mkdir $UBUNTU_VERSION/$VSTS_AGENT_VERSION
    VERSIONED_SRC=versioned/
    VERSIONED_DIR=/$VSTS_AGENT_VERSION
  fi

  sed \
    -e s/'$(UBUNTU_VERSION)'/$UBUNTU_VERSION/g \
    -e s/'$(LIBICU_VERSION)'/$LIBICU_VERSION/g \
    -e s/'$(VSTS_AGENT_VERSION)'/$VSTS_AGENT_VERSION/g \
    ${VERSIONED_SRC}Dockerfile.template > $UBUNTU_VERSION$VERSIONED_DIR/Dockerfile
  if [ -n "$(which unix2dos)" ]; then
    unix2dos -q $UBUNTU_VERSION$VERSIONED_DIR/Dockerfile
  fi

  cp ${VERSIONED_SRC}start.sh $UBUNTU_VERSION$VERSIONED_DIR
}

. process.sh apply