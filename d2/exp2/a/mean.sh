#!/bin/bash

awk '{print $6, $8}' | python ../../py/mean.py
