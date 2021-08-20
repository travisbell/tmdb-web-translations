#!/bin/bash
FILES=locales/*
for f in $FILES
do
  echo "Processing $f file..."
  
  bundle exec localeapp push $f
  sleep 1
done
