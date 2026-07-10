LOGIN		?= $(shell whoami)
DATA_PATH	?= /home/$(LOGIN)/data
DOMAIN_NAME	?= mysite.local

all: setup up

setup:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@grep -q "$(DOMAIN_NAME)" /etc/hosts || echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts > /dev/null

up:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env down

stop:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env stop

start:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env start

clean: down
	@docker system prune -af
	@docker volume prune -f

fclean: clean
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo rm -rf $(DATA_PATH)/mariadb/*

re: fclean all

logs:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env logs -f

ps:
	@docker-compose -f srcs/docker-compose.yml --env-file srcs/.env ps

.PHONY: all setup up down stop start clean fclean re logs ps
