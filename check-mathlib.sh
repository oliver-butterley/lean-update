#!/bin/bash

# Check if project is downstream of mathlib. 
# Using the method of https://github.com/leanprover/lean-action

TOML_PATTERN="\[\[require\]\]\nname = \"mathlib\"\ngit = \"https://github.com/leanprover-community/mathlib4"

if grep -q "require mathlib" lakefile.lean || grep -Pzq "$TOML_PATTERN" lakefile.toml; then
    echo "uses_mathlib=true"
else
    echo "uses_mathlib=false"
fi
