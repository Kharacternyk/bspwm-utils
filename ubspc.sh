#!/bin/bash
set -e

CLOSE_LIST="/tmp/ubspc/close"
mkdir -p "$CLOSE_LIST"

undoable_close() {
    case $# in
        0) NODE="$(bspc query -N -n .focused)" ;;
        1) NODE="$1" ;;
        *)
            echo "Expected 0 or 1 argument: NODE"
            exit 1
            ;;
    esac

    bspc node "$NODE" --flag hidden
    touch "$CLOSE_LIST/$NODE"

    if [[ -z $UBSPC_CLOSE_TIMEOUT ]]; then
        sleep 10
    else
        sleep $UBSPC_CLOSE_TIMEOUT
    fi

    rm "$CLOSE_LIST/$NODE" 2> /dev/null && bspc node "$NODE" --close
}

undo_close() {
    NODE="$(ls -t $CLOSE_LIST)"
    if [[ -n $NODE ]]; then
        bspc node "$NODE" --flag hidden=off
        rm "$CLOSE_LIST/$NODE"
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
