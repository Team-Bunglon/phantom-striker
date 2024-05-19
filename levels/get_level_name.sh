#!/usr/bin/env bash

for l in *; do
  echo "$l: $(cat $l | grep "level_name = ")"
done
