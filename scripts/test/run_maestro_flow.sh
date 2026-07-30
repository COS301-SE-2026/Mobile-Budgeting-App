#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

DEFAULT_FLOW="Flutter/budgetit/test/maestro/auth/login.yaml"
DEFAULT_ENV_FILE="Flutter/budgetit/test/maestro/auth/.env"

FLOW_PATH=${1:-$DEFAULT_FLOW}
ENV_FILE=${2:-$DEFAULT_ENV_FILE}


cd "$PROJECT_ROOT"

if [ -f "$ENV_FILE" ]; then
  set -a
  . "$ENV_FILE"
  set +a
fi

if [ ! -f "$FLOW_PATH" ]; then
  echo "Maestro flow not found: $FLOW_PATH" >&2
  exit 1
fi

if [ -z "${MAESTRO_LOGIN_EMAIL:-}" ] || [ -z "${MAESTRO_LOGIN_PASSWORD:-}" ]; then
  echo "Missing MAESTRO_LOGIN_EMAIL or MAESTRO_LOGIN_PASSWORD." >&2
  echo "Set them in $ENV_FILE  before running this script." >&2
  exit 1
fi

exec maestro test "$FLOW_PATH"
