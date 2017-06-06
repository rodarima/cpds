#!/bin/bash

awk '{print $2, $7}' | python ../../py/mean.py
