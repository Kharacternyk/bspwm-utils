===========
Instalation
===========

Get it `from AUR`_ or just clone/download the repo.

=====
Usage
=====

* ``ubspc close NODE``: hide and later close NODE (defaults to the focused node).
* ``ubspc undo close``: show the previously hidden node and cancel its closing.

=======================
Environmental variables
=======================

* ``UBSPC_CLOSE_TIMEOUT``: the timeout between hiding a node and closing it
  in seconds (10 if unset).

.. LINKS
.. _from AUR: https://aur.archlinux.org/packages/bspwm-undo-git/
