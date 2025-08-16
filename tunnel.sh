#!/bin/bash

export WEBSITES_PORT=8000
httpbin -port $WEBSITES_PORT &
code tunnel --tunnel-id $DEVTUNNEL_TUNNEL_ID --host-token $DEVTUNNEL_TOKEN --name $DEVTUNNEL_TUNNEL_NAME
