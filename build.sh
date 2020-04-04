#!/bin/bash
set -ev
openscad -o frame.stl -D 'object="frame"' design.scad
openscad -o clip.stl -D 'object="clip"' design.scad
