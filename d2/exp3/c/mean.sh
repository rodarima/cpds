#!/bin/bash

awk '{print $3, $7}' | python ../../py/mean.py
