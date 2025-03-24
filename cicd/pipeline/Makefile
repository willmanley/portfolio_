# Define commands as variables for easy reuse
RUFF_FORMAT = ruff format
TERRAFORM_FMT = terraform fmt
PRETTIER = prettier --write

# Define file patterns for linting with Prettier.
JS_CSS_HTML_JSON_MD = "**/*.{js,html,css,json,md}"

# Run ruff format
ruff:
	$(RUFF_FORMAT)

# Run terraform fmt
terraform:
	$(TERRAFORM_FMT)

# Run prettier on specified file types
prettier:
	$(PRETTIER) $(JS_CSS_HTML_JSON_MD)

# Default target when `make` is run without arguments
.PHONY: format
format: ruff terraform prettier
