#!/bin/bash

awk '{print $1, $7}' | python ../../py/mean.py
