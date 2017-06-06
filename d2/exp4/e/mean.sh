#!/bin/bash

awk '{print $5, $7}' | python ../../py/mean.py
