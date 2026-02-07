#!/bin/bash

context=$(kubectl config current-context 2>/dev/null)
if [ -n "$context" ]; then
    echo "K8s: $context |"
fi

