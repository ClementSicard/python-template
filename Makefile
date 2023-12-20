.PHONY: setup
setup:
	@poetry install
	@poetry run pre-commit install
	@poetry run pre-commit install-hooks

.PHONY: test
test:
	@JUPYTER_PLATFORM_DIRS=1 poetry run pytest tests -v --color yes
