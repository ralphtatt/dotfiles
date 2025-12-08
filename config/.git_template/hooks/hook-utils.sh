#!/usr/bin/env bash

run_tool() {
    local tool_name="$1"
    shift

    # Remaining args = command + arguments
    local enabled
    enabled="$(git config --bool "${tool_name}.enabled")"

    if [ "${enabled}" = "false" ]; then
        echo "[hook] ${tool_name} is disabled via git config"
        return 0
    fi

    echo "[hook] Running ${tool_name}..."

    "$@"
    local status=$?

    if [ ${status} -ne 0 ]; then
        echo "[hook] ${tool_name} failed with status ${status}"
        return ${status}
    fi

    echo "[hook] ${tool_name} completed successfully"
    return 0
}
