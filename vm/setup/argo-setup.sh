#!/bin/bash

echo "$(date +'%Y-%m-%d %H:%M:%S')  argo setup start" >> "$HOME/status"

# inner-loop
if [ "$PIB_IS_INNER_LOOP" = "true" ]; then
  exit 0
fi

# setup Arc enabled flux
if [ "$PIB_ARC_ENABLED" = "true" ]
then
  exit 0
fi

# make sure flux is installed
if [ ! "$(argocd version)" ]
then
  echo "$(date +'%Y-%m-%d %H:%M:%S')  argocd not found" >> "$HOME/status"
  echo "$(date +'%Y-%m-%d %H:%M:%S')  argo setup failed" >> "$HOME/status"
  exit 1
fi

git pull

kubectl apply -k "$HOME/pib/clusters/$PIB_CLUSTER/argocd"

# reapply once services start
# todo - wait for services to be ready
sleep 30
kubectl apply -k "$HOME/pib/clusters/$PIB_CLUSTER/argocd"

echo "$(date +'%Y-%m-%d %H:%M:%S')  argo setup complete" >> "$HOME/status"
