.PHONY: setup test lint check

setup:
	@command -v bats >/dev/null 2>&1 || { echo "Installing bats-core..."; brew install bats-core; }
	@command -v pre-commit >/dev/null 2>&1 || { echo "Installing pre-commit..."; brew install pre-commit; }
	pre-commit install
	pre-commit install --hook-type pre-push
	@echo "Setup complete."

test:
	bats .dotfiles/test/*.bats

lint:
	pre-commit run --all-files

check: lint test
