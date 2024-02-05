#!/bin/bash

# Nome do repositório ECR para a Flask API
flask_api_repository="flask-api"

# Nome do repositório ECR para o frontend
frontend_repository="frontend"

# Verifique se a imagem Flask API com a tag 0.1 já existe
if ! aws ecr describe-images --repository-name $flask_api_repository --image-ids imageTag=0.1 >/dev/null 2>&1; then
  # Se a imagem não existe, faça o build, tag e push com a tag 0.1
  docker build -t $flask_api_repository:0.1 .
  docker tag $flask_api_repository:0.1 $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$flask_api_repository:0.1
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$flask_api_repository:0.1
else
  # Se a imagem com a tag 0.1 já existe, encontre a próxima tag disponível
  for i in {2..9}; do
    if ! aws ecr describe-images --repository-name $flask_api_repository --image-ids imageTag=0.$i >/dev/null 2>&1; then
      next_tag="0.$i"
      break
    fi
  done

  # Se não houver mais tags disponíveis entre 0.2 e 0.9, vá para 1.0 e assim por diante
  if [ -z "$next_tag" ]; then
    latest_tag=$(aws ecr describe-images --repository-name $flask_api_repository --query 'images[].imageTags' --output json | jq -r '.[]' | grep -oE '^[0-9]+\.[0-9]+' | sort -V | tail -n 1)
    major_version=$(echo $latest_tag | cut -d'.' -f1)
    next_major_version=$((major_version + 1))
    next_tag="${next_major_version}.0"
  fi

  # Faça o build, tag e push com a próxima tag disponível
  docker build -t $flask_api_repository:$next_tag .
  docker tag $flask_api_repository:$next_tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$flask_api_repository:$next_tag
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$flask_api_repository:$next_tag
fi

# Repita o mesmo processo para o repositório do frontend
if ! aws ecr describe-images --repository-name $frontend_repository --image-ids imageTag=0.1 >/dev/null 2>&1; then
  docker build -t $frontend_repository:0.1 .
  docker tag $frontend_repository:0.1 $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$frontend_repository:0.1
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$frontend_repository:0.1
else
  for i in {2..9}; do
    if ! aws ecr describe-images --repository-name $frontend_repository --image-ids imageTag=0.$i >/dev/null 2>&1; then
      next_tag="0.$i"
      break
    fi
  done

  if [ -z "$next_tag" ]; then
    latest_tag=$(aws ecr describe-images --repository-name $frontend_repository --query 'images[].imageTags' --output json | jq -r '.[]' | grep -oE '^[0-9]+\.[0-9]+' | sort -V | tail -n 1)
    major_version=$(echo $latest_tag | cut -d'.' -f1)
    next_major_version=$((major_version + 1))
    next_tag="${next_major_version}.0"
  fi

  docker build -t $frontend_repository:$next_tag .
  docker tag $frontend_repository:$next_tag $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$frontend_repository:$next_tag
  docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$frontend_repository:$next_tag
fi
