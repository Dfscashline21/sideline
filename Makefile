# One-command workflows for the sideline monorepo.
# Run `make help` to list targets.

COMPOSE := docker compose
UV_RUN := uv run

.DEFAULT_GOAL := help

.PHONY: help \
        up down ps logs dev-shell \
        test lint typecheck format \
        sync hooks

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

# --- Local stack (compose.yaml) ---------------------------------------------

up: ## Start all services and wait until healthy
	@if [ ! -f .env ]; then cp .env.example .env; echo "Created .env from .env.example"; fi
	$(COMPOSE) up -d --wait

down: ## Stop and remove containers (named volumes are kept)
	$(COMPOSE) down

ps: ## Show service status
	$(COMPOSE) ps

logs: ## Tail logs for all services
	$(COMPOSE) logs -f

dev-shell: ## Open a shell inside the dev container
	$(COMPOSE) exec dev bash

# --- Python toolchain ---------------------------------------------------------

sync: ## Install/update dependencies from uv.lock into .venv
	uv sync --locked --dev

test: ## Run the test suite
	$(UV_RUN) pytest

lint: ## Lint and check formatting (ruff)
	$(UV_RUN) ruff check
	$(UV_RUN) ruff format --check

typecheck: ## Static type checking (mypy)
	$(UV_RUN) mypy $$(git ls-files -co --exclude-standard '*.py')

format: ## Auto-format Python code (ruff)
	$(UV_RUN) ruff check --fix
	$(UV_RUN) ruff format

hooks: ## Install the git pre-commit hook
	$(UV_RUN) pre-commit install
