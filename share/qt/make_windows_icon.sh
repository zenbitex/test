#!/bin/bash
# create multiresolution windows icon
#mainnet
ICON_SRC=../../src/qt/res/icons/futurexco.png
ICON_DST=../../src/qt/res/icons/futurexco.ico
convert ${ICON_SRC} -resize 16x16 futurexco-16.png
convert ${ICON_SRC} -resize 32x32 futurexco-32.png
convert ${ICON_SRC} -resize 48x48 futurexco-48.png
convert futurexco-16.png futurexco-32.png futurexco-48.png ${ICON_DST}
#testnet
ICON_SRC=../../src/qt/res/icons/futurexco_testnet.png
ICON_DST=../../src/qt/res/icons/futurexco_testnet.ico
convert ${ICON_SRC} -resize 16x16 futurexco-16.png
convert ${ICON_SRC} -resize 32x32 futurexco-32.png
convert ${ICON_SRC} -resize 48x48 futurexco-48.png
convert futurexco-16.png futurexco-32.png futurexco-48.png ${ICON_DST}
rm futurexco-16.png futurexco-32.png futurexco-48.png
