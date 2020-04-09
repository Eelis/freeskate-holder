#!/bin/bash
set -ev
openscad -o stl/frame.stl scad/frame.scad
openscad -o stl/clip.stl scad/clip.scad
