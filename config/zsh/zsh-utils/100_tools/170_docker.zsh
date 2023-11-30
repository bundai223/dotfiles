#!/usr/bin/env zsh

# docker compose run の省略系
dcrun () {
  service_name=$1
  shift

  if [ -z "$(docker compose ps $service_name --format "{{ .Status }}" --filter "status=running")" ]; then
    docker compose run --rm $service_name $@
  else
    # execのときはクオート不要だった
    docker compose exec $service_name $@
  fi
}
