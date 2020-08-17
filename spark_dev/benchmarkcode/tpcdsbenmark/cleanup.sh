#!/bin/sh

BM=$(pwd)
echo ${BM}

cd ../tpcds_data
rm -r *
touch dummyfile

cd $BM

cd ../results
rm -r *
touch dummyfile

cd $BM
