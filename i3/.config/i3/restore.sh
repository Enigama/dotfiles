#!/bin/sh

for layout in ~/.config/i3/layout/*; do
    i3-msg "workspace $(basename "$layout" .json); append_layout $layout"
done

(kitty &)
