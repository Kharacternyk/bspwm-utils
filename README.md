### Usage

* `ubspc close NODE`: hide and later close `NODE` (defaults to the focused node).
* `ubspc undo close`: show the most recently hidden node and cancel its closing.
* `ubscp branch NEW_DESKTOP_NAME SOURCE_DESKTOP_NAME`: create a new desktop called
  `NEW_DESKTOP_NAME` on the focused monitor and place it after `SOURCE_DESKTOP_NAME`,
  defaults to the current timestamp and the focused desktop respectively.

### Environmental variables

* `UBSPC_CLOSE_TIMEOUT`: the timeout between hiding a node and closing it
  in seconds (10 if unset).
