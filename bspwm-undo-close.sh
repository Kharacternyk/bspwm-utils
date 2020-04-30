#!/bin/bash

NODE="$(bspc query -N -n .hidden | tail -n1)"

[[ -n $NODE ]] && bspc node $NODE --flag hidden=off
