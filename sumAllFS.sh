#!/usr/bin/env bash

#author: tpask
# sample script to demo sum of column using awk

fs='tmpfs'

df -mt $fs|grep -v '1M-blocks'|awk '{sum+=$2} END {print sum}'
