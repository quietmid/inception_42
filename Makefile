# Colors
RESET=$(shell echo -e "\033[0m")
BLUE=$(shell echo -e "\033[1;34m")
YELLOW=$(shell echo -e "\033[1;33m")
RED=$(shell echo -e "\033[1;31m")
GREEN=$(shell echo -e "\033[1;32m")

# Paths
DATA_DIR=/home/jlu/data

# Docker compose file
COMPOSE=docker compose -f ./srcs/docker-compose.yml

# Commands
.PHONY: all up down clean fclean re

up:
	@echo "$(BLUE)Creating data directories...$(RESET)"
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@echo "$(GREEN)Data directories created at $(DATA_DIR)$(RESET)"
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all -v

fclean: clean
	@echo "$(YELLOW)Removing data directories...$(RESET)"
	@rm -rf $(DATA_DIR)
	@echo "$(GREEN)Removing all unused Docker resources...$(RESET)"
	docker system prune -f --volumes

all: up

re: fclean all