#!/bin/bash

[[ $1 =~ ^[0-9.]+$ ]] || { echo "First arg should be version" >&2; exit 1; }
[[ $2 =~ ^(stable|beta)$ ]] || { echo "Invalid channel (stable|beta)." >&2; exit 1; }

version=$1
channel=$2

echo "Version: $version"
echo "Channel: $channel"

if [[ $channel = "beta" ]]; then
    sed -i "s/^beta.*$/beta: $version/" version.txt
    sed -i "s|^\[7\].*|[7]: https://img.shields.io/badge/v-$version--beta-blue|" README.md
    sed -i "s|^\[10\].*|[10]: https://img.shields.io/docker/image-size/rfvgyhn/avorion/$version-beta|" README.md
    sed -i "s|^\[11\].*|[11]: https://img.shields.io/badge/v-$version--beta-blue|" README.md
else
    sed -i "s/^stable.*$/stable: $version/" version.txt
    sed -i "s|^\[7\].*|[7]: https://img.shields.io/badge/v-$version-blue|" README.md
    sed -i "s|^\[9\].*|[9]: https://img.shields.io/badge/v-$version-blue|" README.md
fi

git add version.txt README.md
git commit -m "upgrade $channel to $version"

make release CHANNEL=$channel
