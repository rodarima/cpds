#!/bin/bash

awk '{print $4, $7}' | python ../../py/mean.py
