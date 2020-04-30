#!/bin/bash

bspc node --flag hidden

sleep 10

NODE="$(bspc query -N -n .hidden | tail -n1)"

[[ -n $NODE ]] && bspc node $NODE --flag hidden=off
