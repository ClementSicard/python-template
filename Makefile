.PHONY: setup
setup:
	@poetry install
	@poetry run pre-commit install
	@poetry run pre-commit install-hooks

.PHONY: test
test:
	@JUPYTER_PLATFORM_DIRS=1 poetry run pytest tests -v --color yes


.PHONY: lint
lint:
	@poetry run mypy **/*.py --strict --ignore-missing-imports --no-warn-unused-ignores
	@poetry run isort **/*.py --profile black
	@poetry run ruff **/*.py --fix --line-length 120 --show-source -v
	@poetry run black **/*.py --line-length 120 --color
	@poetry run interrogate **/*.py -vv
