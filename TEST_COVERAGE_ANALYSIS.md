# Test Coverage Analysis

## Current State

This repository has **zero tests and no CI/CD infrastructure**. There are no test files, no test runner configuration, no GitHub Actions workflows, and no linting or validation of any kind.

The codebase contains **9 shell scripts** (4 modify scripts, 2 run_once scripts, 3 run_onchange scripts), **3 shell library files** (functions.sh, aliases.sh, zshrc.shared), and **1 TOML config** (.chezmoiexternal.toml) — all completely untested.

---

## Proposed Test Areas

### 1. Modify Scripts — Idempotency & Correctness (High Priority)

**Files:** `modify_dot_bashrc`, `modify_dot_zshrc`, `modify_dot_vimrc`, `modify_dot_tmux.conf`

These scripts are the most testable and most important to verify. They read existing file contents from stdin and must produce correct output. Bugs here silently corrupt rc files.

**What to test:**
- **Empty input**: script produces correct output when the target file doesn't exist yet
- **Idempotency**: running the script twice on its own output produces identical results (no duplicate lines)
- **Existing content preserved**: user's custom config lines are not lost or reordered
- **Marker/source line detection**: the grep-based detection correctly identifies existing markers even with surrounding whitespace variations

**Example test approach** (pure bash, no dependencies):
```bash
#!/bin/bash
# test_modify_scripts.sh
set -euo pipefail
failures=0

# Test: modify_dot_zshrc on empty input produces source line
result=$(echo -n "" | ./modify_dot_zshrc)
expected="source ~/.dotfiles/zsh/zshrc.shared"
if [[ "$result" != "$expected" ]]; then
    echo "FAIL: modify_dot_zshrc empty input"
    failures=$((failures + 1))
fi

# Test: idempotency — running twice gives same result
result2=$(echo "$result" | ./modify_dot_zshrc)
if [[ "$result" != "$result2" ]]; then
    echo "FAIL: modify_dot_zshrc not idempotent"
    failures=$((failures + 1))
fi

# Test: preserves existing content
existing="my-custom-config"
result=$(echo "$existing" | ./modify_dot_zshrc)
if ! echo "$result" | grep -qF "$existing"; then
    echo "FAIL: modify_dot_zshrc lost existing content"
    failures=$((failures + 1))
fi

exit $failures
```

### 2. Shell Functions — PATH Manipulation (High Priority)

**File:** `dot_dotfiles/zsh/functions.sh`

The `path_remove`, `path_append`, and `path_prepend` functions manipulate `$PATH` using awk. These are pure functions with clear inputs/outputs — ideal for unit testing.

**What to test:**
- `path_remove` removes the correct entry and no others
- `path_remove` handles entries that don't exist (no-op)
- `path_remove` handles duplicate entries
- `path_append` adds to end, `path_prepend` adds to beginning
- `path_append`/`path_prepend` deduplicate (they call `path_remove` first)
- Edge cases: empty PATH, single-entry PATH, entries with spaces

### 3. Shell Functions — Utility Functions (Medium Priority)

**File:** `dot_dotfiles/zsh/aliases.sh`

The `up`, `mcd`, `jump`, and `xin` functions contain real logic worth testing.

**What to test:**
- `up` with no arguments goes up one directory
- `up 3` goes up 3 directories
- `up` with non-numeric argument prints error
- `up` with negative/zero argument prints error
- `up` at filesystem root stays at root (doesn't error)
- `mcd` creates directory and changes into it
- `jump` changes to the directory containing a file path

### 4. TOML Configuration Validation (Medium Priority)

**File:** `.chezmoiexternal.toml`

This file defines 24 external plugin archives. A malformed entry silently breaks plugin installation.

**What to test:**
- TOML is valid (parse check)
- All URLs are well-formed HTTPS GitHub archive URLs
- Every entry has the required fields (`type`, `url`, `exact`, `stripComponents`)
- No duplicate section keys

**Example approach:**
```bash
# Validate TOML syntax (using python or a toml linter)
python3 -c "import tomllib; tomllib.load(open('.chezmoiexternal.toml', 'rb'))"

# Validate URL format
grep -oP 'url = "\K[^"]+' .chezmoiexternal.toml | while read url; do
    [[ "$url" =~ ^https://github\.com/.+/archive/.+\.tar\.gz$ ]] || echo "Bad URL: $url"
done
```

### 5. Template Rendering Validation (Medium Priority)

**Files:** `*.tmpl` (5 template files)

Template files use Go template syntax (`{{ .name }}`, `{{ .email }}`, `{{ if eq .chezmoi.os "darwin" }}`). Syntax errors in these only surface at `chezmoi apply` time.

**What to test:**
- Templates render without error given mock data via `chezmoi execute-template`
- The `install-binaries` script's OS-conditional logic produces valid bash for each OS
- Rendered output is syntactically valid bash (`bash -n` check)

### 6. Linting — ShellCheck on All Scripts (High Priority)

Every shell script should pass ShellCheck. This catches real bugs like unquoted variables, incorrect conditionals, and POSIX portability issues.

**What to lint:**
- All 4 `modify_dot_*` scripts
- All 5 `run_once_*` / `run_onchange_*` scripts (after template rendering)
- `dot_dotfiles/zsh/functions.sh`
- `dot_dotfiles/zsh/aliases.sh`

**Known issues ShellCheck would catch:**
- `modify_dot_bashrc:7` — `echo "$contents" | grep` can be replaced with a here-string to avoid masking exit codes (applies to all modify scripts)

### 7. CI/CD Pipeline (High Priority)

None of the above matters without automation. A GitHub Actions workflow should:

1. **Lint**: Run ShellCheck on all shell scripts
2. **Validate**: Parse `.chezmoiexternal.toml`
3. **Test**: Run the modify-script and function unit tests
4. **Template check**: Render templates with mock data and validate syntax

---

## Recommended Implementation Order

| Priority | Area | Effort | Impact |
|----------|------|--------|--------|
| 1 | ShellCheck linting + CI workflow | Low | Catches bugs across all scripts |
| 2 | Modify script idempotency tests | Low | Prevents rc file corruption |
| 3 | PATH function unit tests | Low | Pure functions, easy to test |
| 4 | TOML validation | Low | Prevents silent plugin breakage |
| 5 | Utility function tests (up, mcd) | Medium | Less critical but real logic |
| 6 | Template rendering tests | Medium | Requires chezmoi or mock setup |

## Summary

The highest-value, lowest-effort improvements are: **(1)** adding a ShellCheck linting pass via GitHub Actions, **(2)** testing the 4 modify scripts for idempotency (these directly mutate user rc files), and **(3)** unit-testing the PATH manipulation functions. Together these three would cover the most critical and bug-prone parts of the codebase with minimal setup effort.
