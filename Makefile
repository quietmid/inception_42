# Paths
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

test:
	# Test TLSv1.2 and TLSv1.3 (Should succeed)
	openssl s_client -connect localhost:443 -tls1_2
	openssl s_client -connect localhost:443 -tls1_3
	
	# Test TLSv1.0 and TLSv1.1 (Should fail)
	openssl s_client -connect localhost:443 -tls1 || true
	openssl s_client -connect localhost:443 -tls1_1 || true
	
.PHONY: all re down clean