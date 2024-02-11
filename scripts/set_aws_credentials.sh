#!/bin/bash
export AWS_ACCESS_KEY_ID=CHANGEME
export AWS_SECRET_ACCESS_KEY=CHANGEME
export AWS_REGION=us-east-1

# Test credentials
aws sts get-caller-identity
