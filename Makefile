# Determine the operating system
OS = $(shell uname)

# Define Docker compose command
DOCKER_COMPOSE = docker compose

# (1) Build
build:
	@echo " Running in $(OS)....."
	@echo "Building Docker image..."
	$(DOCKER_COMPOSE) build


# (2) Run
run:
	echo "Starting Containers..."
	$(DOCKER_COMPOSE) up -d


# (3) Stop
stop:
	@echo "Stopping Containers..."
	$(DOCKER_COMPOSE) down


# (4) Check Logs
logs:
	$(DOCKER_COMPOSE) logs -f


# (5) Check Status
status:
	$(DOCKER_COMPOSE) ps


# (6)  Clean
clean: stop
	@echo "Removing unsed Docker resources..."
	$(DOCKER_COMPOSE) rm -f
	docker system prune -f


.PHONY: build run stop clean logs  status
