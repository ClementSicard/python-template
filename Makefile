UV_RUN ?= uv run --frozen
PYTEST ?= $(UV_RUN) pytest

TEST_RESULTS_FOLDER := test-results

#* Cleaning

.PHONY: clean
clean:
	# Pycache
	find . | grep -E "(__pycache__|\.pyc|\.pyo$$)" | xargs rm -rf
	# DS Store
	find . | grep -E ".DS_Store" | xargs rm -rf
	# Pytype
	find . | grep -E ".pytype" | xargs rm -rf
	# pytest
	find . | grep -E ".pytest_cache" | xargs rm -rf
	# ruff
	find . | grep -E ".ruff_cache" | xargs rm -rf
	# mypy
	find . | grep -E ".mypy_cache" | xargs rm -rf
	# Build
	rm -rf build/


#* Formatting and linting

.PHONY: pre-commit-setup
pre-commit-setup:
	$(UV_RUN) pre-commit install

.PHONY: isort-fix
isort-fix:
	$(UV_RUN) isort --settings-path pyproject.toml src

.PHONY: isort-check
isort-check:
	$(UV_RUN) isort --settings-path pyproject.toml --check-only src --diff

.PHONY: pyink-fix
pyink-fix:
	$(UV_RUN) pyink --config pyproject.toml src

.PHONY: pyink-check
pyink-check:
	$(UV_RUN) pyink --config pyproject.toml --check --diff src

.PHONY: ruff-fix
ruff-fix:
	$(UV_RUN) ruff check --fix src

.PHONY: ruff-check
ruff-check:
	$(UV_RUN) ruff check src

.PHONY: blocklint-check
blocklint-check:
	$(UV_RUN) blocklint --max-issue-threshold 1

.PHONY: pytype-check
pytype-check:
	$(UV_RUN) pytype --pythonpath src --keep-going --jobs auto src


.PHONY: lint
lint: isort-fix pyink-fix ruff-fix blocklint-check pytype-check

.PHONY: lint-check
lint-check: isort-check pyink-check ruff-check blocklint-check pytype-check


#* uv

.PHONY: uv-setup
uv-setup:
	pip install uv

.PHONY: lock
lock:
	uv lock

.PHONY: lock-upgrade
lock-upgrade: uv-setup
	uv lock --upgrade

.PHONY: install
install:
	uv sync --frozen --all-extras --dev


#* Testing

.PHONY: test
test:
	$(PYTEST) --cov -n auto --dist loadgroup --junit-xml=$(TEST_RESULTS_FOLDER)/tests.xml --html=$(TEST_RESULTS_FOLDER)/tests.html --self-contained-html
	$(UV_RUN) coverage-badge -o assets/coverage.svg -f
