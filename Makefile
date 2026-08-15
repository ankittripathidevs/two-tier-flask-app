# Determine the operating system
OS = $(shell uname)

# Define Docker compose command
DOCKER_COMPOSE = docker compose

# (1) Build target
build:
ifeq ($(OS),Linux)
    @echo "Building for Linux"
    $(DOCKER_COMPOSE) build
endif
ifeq ($(OS),Darwin)
    @echo "Building for macOS"
    $(DOCKER_COMPOSE) build
endif
ifeq ($(OS),Windows_NT)
    @echo "Building for Windows"
    # Add Windows-specific build commands if you wish :P
endif


# (2) Run target
run:
    @echo "Starting containers..."
    $(DOCKER_COMPOSE) up -d


# (3) Stop target
stop:
    @echo "Stopping containers..."
    $(DOCKER_COMPOSE) down


# (4) Check Logs
logs:
    $(DOCKER_COMPOSE) logs -f


# (5) Restart Container
restart: stop run


# (6) Check Status
status:
    $(DOCKER_COMPOSE) ps


# (7)  Clean target
clean: stop
    @echo "Removing unused Docker resources..."
    $(DOCKER_COMPOSE) rm -f
    docker system prune -f


.PHONY: build run stop clean logs restart status