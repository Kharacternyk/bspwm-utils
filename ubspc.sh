#!/bin/bash

CLOSE_LIST="${XDG_RUNTIME_DIR}/ubspc/close"
mkdir -p "$CLOSE_LIST"

undoable_close() {
    case $# in
        0) NODE="$(bspc query -N -n .focused)" ;;
        1) NODE="$1" ;;
        *)
            echo "Expected 0 or 1 argument: NODE" >&2
            exit 1
            ;;
    esac

    # We move the node to a temporary workspace,
    # so that BSPWM removal_adjustment takes place.
    bspc monitor -a __ubspc_tmp__
    bspc node "$NODE" -d __ubspc_tmp__
    bspc node "$NODE" --flag hidden
    bspc desktop __ubspc_tmp__ -r

    TIME="$(date +%s%N)"
    mkdir -p "$CLOSE_LIST/$TIME"

    touch "$CLOSE_LIST/$TIME/$NODE"

    sleep "${UBSPC_CLOSE_TIMEOUT:-10}"

    rm -r "$CLOSE_LIST/$TIME" 2> /dev/null && bspc node "$NODE" --close
}

undo_close() {
    TIME="$(ls "$CLOSE_LIST" | tail -n1)"
    NODE="$(ls "$CLOSE_LIST/$TIME")"

    if [[ -n $NODE ]]; then
        bspc node "$NODE" --flag hidden=off -d focused -f
        rm -r "$CLOSE_LIST/$TIME"
        exit
    fi
    exit 1
}

[[ $# == 0 ]] && exec bspc

case "$1" in
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
                echo "$1 is not an undoable operation" >&2
                exit 1
                ;;
        esac
        ;;
    *)
        exec bspc "$@"
        ;;
esac
