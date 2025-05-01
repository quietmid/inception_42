# Colors
RESET=$(shell echo -e "\033[0m")
BLUE=$(shell echo -e "\033[1;34m")
YELLOW=$(shell echo -e "\033[1;33m")
RED=$(shell echo -e "\033[1;31m")
GREEN=$(shell echo -e "\033[1;32m")

# Paths
DATA_DIR=/

# Docker compose file
COMPOSE = docker-compose -f ./srcs/docker-compose.yml

# Commands
.PHONY: all build up down restart logs test clean

all: build up

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f nginx

	
.PHONY: all re down clean