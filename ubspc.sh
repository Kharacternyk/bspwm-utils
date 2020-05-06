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

    TIME="$(date +%s%N)"
    mkdir -p "$CLOSE_LIST/$TIME"

    touch "$CLOSE_LIST/$TIME/$NODE"

    if [[ -z $UBSPC_CLOSE_TIMEOUT ]]; then
        sleep 10
    else
        sleep $UBSPC_CLOSE_TIMEOUT
    fi

    rm -r "$CLOSE_LIST/$TIME" 2> /dev/null && bspc node "$NODE" --close
}

undo_close() {
    TIME="$(ls $CLOSE_LIST | tail -n1)"
    NODE="$(ls $CLOSE_LIST/$TIME)"

    if [[ -n $NODE ]]; then
        bspc node "$NODE" --flag hidden=off
        rm -r "$CLOSE_LIST/$TIME"
        exit
    fi
    exit 1
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
            close)
                shift
                undo_close "$@"
                ;;
            *)
                echo "$1 is not an undoable operation"
                exit 1
                ;;
        esac
        ;;
    *)
        exec bspc "$@"
        ;;
esac
