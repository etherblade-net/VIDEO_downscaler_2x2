#!/usr/bin/env bash

clear

echo "Select Scenario:"
echo "  1) Run downscaler RTL"
echo "  2) Run downscaler BFM"

read n

#Start Cocotb
case $n in
  1) make -B -f Makefile_sc1;;
  2) make -B -f Makefile_sc2;;
  *) echo "invalid option";;
esac