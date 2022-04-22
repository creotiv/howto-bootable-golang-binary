#!/bin/bash
SPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SPATH/gobinary
go build -ldflags="-extldflags=-static" -o init
cd ../
mkdir -p goram
mv $SPATH/gobinary/init $SPATH/goram/init
cd $SPATH/goram
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../goram.cpio.gz