#!/bin/bash
set -e

for part in frame clip
do
    echo "Creating $part.stl..."
    openscad -o stl/$part.stl scad/$part.scad
done
