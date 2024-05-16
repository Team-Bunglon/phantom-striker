#!/usr/bin/env bash

for l in *; do
  echo "$l: $(cat $l | grep room_name)"
done
