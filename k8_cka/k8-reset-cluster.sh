#!/usr/bin/env bash
set -euo pipefail

kube=(kubectl --context=docker-desktop --namespace=default)
resources=$("${kube[@]}" api-resources --namespaced=true --verbs=list,delete -o name)
objects=()

while IFS= read -r resource; do
  listed=$("${kube[@]}" get "$resource" -o name)

  while IFS= read -r object; do
    case "$object" in
      ""|service/kubernetes) continue ;;
    esac
    objects+=("$object")
  done <<< "$listed"
done <<< "$resources"

if (( ${#objects[@]} == 0 )); then
  printf 'No lab resources to delete.\n'
  exit 0
fi

"${kube[@]}" delete --ignore-not-found --timeout=120s -- "${objects[@]}"
