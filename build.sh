#!/bin/bash
docker build $1 -t gcr.io/geht-auf-reisen/$(basename $(pwd)):master . 
