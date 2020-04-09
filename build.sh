#!/bin/bash
set -ev
openscad -o frame.stl frame.scad
openscad -o clip.stl clip.scad
