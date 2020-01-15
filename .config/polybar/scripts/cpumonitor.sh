#!/bin/bash

mpstat -P ALL 1 1 | awk '/Average:/ && $2 ~ /[0-9]/ {print $3}' | sed -uEn 's/(^[0-9]*)\..*$/0\1\%/p' | grep -o '...$' | tr '\n' ' ' | sed -E 's/(^.*$)/ \1/'

#mpstat -P ALL 1 1 | #get cpu loads
#awk '/Average:/ && [ ~ /[0-9]/ {print {}' | #magic to get only load values
#sed -uEn 's/(^[0-9]*)\..*$/0\1\%/p' | #trim decimals, pad 0 if < 10, add % after
#tr '\n' ' ' # join lines togethre

