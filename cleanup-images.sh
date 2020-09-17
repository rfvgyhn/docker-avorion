#!/bin/sh

docker images -q "rfvgyhn/avorion" | uniq | xargs docker rmi --force