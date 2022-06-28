#!/bin/bash

PRODUCT="${1:-nomad}"

curl -sL https://api.releases.hashicorp.com/v1/releases/$PRODUCT/latest | jq -r '.version'
