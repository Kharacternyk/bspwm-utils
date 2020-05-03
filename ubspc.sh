#!/bin/bash

undoable_close() {
    bspc node "$@" --flag hidden
    sleep 10

    NODE="$(bspc query -N -n .hidden | tail -n1)"
    [[ -n $NODE ]] && bspc node $NODE --close
}

undo_close() {
    NODE="$(bspc query -N -n .hidden | tail -n1)"
    [[ -n $NODE ]] && bspc node $NODE --flag hidden=off
}

[[ $# == 0 ]] && exec bspc

case $1 in
    close)
        shift
        undoable_close "$@"
        ;;
    undo)
        shift
        case $1 in
            close) shift; undo_close "$@";;
            *) echo "$1 is not an undoable operation"; exit 1
        esac
        ;;
    *)
        exec bspc $@
        ;;
esac
