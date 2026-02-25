# ==============================================================================
# BMS Microservice - Software Factory Makefile
# ==============================================================================

.DEFAULT_GOAL := help
.PHONY: help install lint lint-check analyse test quality up down shell logs build scaffold validate factory-check

DOCKER_COMPOSE = docker compose
PHP_CONTAINER  = $(DOCKER_COMPOSE) exec app
COMPOSER       = $(PHP_CONTAINER) composer

# --- Colors ---
GREEN  := \033[0;32m
YELLOW := \033[0;33m
RESET  := \033[0m

## —— Help ——————————————————————————————————————————————————————————
help: ## Show this help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}{printf "$(GREEN)%-20s$(RESET) %s\n", $$1, $$2}' \
		| sed -e 's/^## /\n$(YELLOW)/'

## —— Project Setup ————————————————————————————————————————————————
install: ## Install dependencies (composer install)
	$(COMPOSER) install

update: ## Update dependencies (composer update)
	$(COMPOSER) update

## —— Quality Tools ————————————————————————————————————————————————
lint: ## Fix code style with PHP-CS-Fixer
	$(PHP_CONTAINER) vendor/bin/php-cs-fixer fix --verbose

lint-check: ## Check code style (dry-run, no changes)
	$(PHP_CONTAINER) vendor/bin/php-cs-fixer fix --dry-run --diff --verbose

analyse: ## Run PHPStan static analysis
	$(PHP_CONTAINER) vendor/bin/phpstan analyse --memory-limit=-1

test: ## Run PHPUnit tests
	$(PHP_CONTAINER) vendor/bin/phpunit

test-coverage: ## Run PHPUnit tests with coverage report
	$(PHP_CONTAINER) vendor/bin/phpunit --coverage-text --coverage-html=var/coverage

quality: lint-check analyse test ## Run all quality checks (lint + analyse + test)

## —— Docker ———————————————————————————————————————————————————————
up: ## Start Docker containers
	$(DOCKER_COMPOSE) up -d

down: ## Stop Docker containers
	$(DOCKER_COMPOSE) down

build: ## Build Docker images
	$(DOCKER_COMPOSE) build

logs: ## Show container logs
	$(DOCKER_COMPOSE) logs -f

shell: ## Open a shell in the PHP container
	$(PHP_CONTAINER) sh

db-shell: ## Open a psql shell in the database container
	$(DOCKER_COMPOSE) exec db psql -U app

## —— Symfony ——————————————————————————————————————————————————————
cc: ## Clear Symfony cache
	$(PHP_CONTAINER) php bin/console cache:clear

migrate: ## Run database migrations
	$(PHP_CONTAINER) php bin/console doctrine:migrations:migrate --no-interaction

diff: ## Generate a migration diff
	$(PHP_CONTAINER) php bin/console doctrine:migrations:diff

## —— Software Factory —————————————————————————————————————————————
scaffold: ## Generate scaffolding for a resource (usage: make scaffold NAME=Product)
	@if [ -z "$(NAME)" ]; then \
		echo "\033[31mError: Falta el nombre del recurso. Uso: make scaffold NAME=Product\033[0m"; \
		exit 1; \
	fi
	$(PHP_CONTAINER) php .factory/scaffold.php $(NAME) $(ARGS)

scaffold-dry: ## Preview scaffolding without creating files (usage: make scaffold-dry NAME=Product)
	@if [ -z "$(NAME)" ]; then \
		echo "\033[31mError: Falta el nombre del recurso. Uso: make scaffold-dry NAME=Product\033[0m"; \
		exit 1; \
	fi
	$(PHP_CONTAINER) php .factory/scaffold.php $(NAME) --dry-run

validate: ## Validate project structure follows Software Factory conventions
	$(PHP_CONTAINER) php .factory/validate.php

factory-check: quality validate ## Run quality checks + factory validation
