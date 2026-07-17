#!/bin/bash

cd "/home/$USER/Applications/" || exit

rm -rf cursor.AppImage

curl -Lo cursor.AppImage "https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/"

chmod +x cursor.AppImage