#!/bin/bash

ORGANIZATION=$ORGANIZATION
REG_TOKEN=$REG_TOKEN
REPO=$REPO

cd /home/docker/actions-runner

./config.sh --url https://github.com/${ORGANIZATION}/${REPO} --token ${REG_TOKEN}

./run.sh & wait $!