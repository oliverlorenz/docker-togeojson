#!/bin/bash
gcloud auth login
docker login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://gcr.io
