#!/bin/bash
set -ue

undoable_close() {
    bspc node "$@" --flag hidden
    sleep 10

    if NODE="$(bspc query -N -n .hidden | tail -n1)"; then
        bspc node "$NODE" --close
    fi
}

undo_close() {
    if NODE="$(bspc query -N -n .hidden | tail -n1)"; then
        bspc node "$NODE" --flag hidden=off
    fi
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
        exec bspc "$@"
        ;;
esac
