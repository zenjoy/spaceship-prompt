#
# Node.js
#
# Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.
# Link: https://nodejs.org/

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_NODE_SHOW="${SPACESHIP_NODE_SHOW=true}"
SPACESHIP_NODE_PREFIX="${SPACESHIP_NODE_PREFIX="$SPACESHIP_PROMPT_DEFAULT_PREFIX"}"
SPACESHIP_NODE_SUFFIX="${SPACESHIP_NODE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_NODE_SYMBOL="${SPACESHIP_NODE_SYMBOL="⬢ "}"
SPACESHIP_NODE_DEFAULT_VERSION="${SPACESHIP_NODE_DEFAULT_VERSION=""}"
SPACESHIP_NODE_COLOR="${SPACESHIP_NODE_COLOR="green"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

spaceship_async_job_load_node() {
  [[ $SPACESHIP_NODE_SHOW == false ]] && return

  async_job spaceship spaceship_async_job_node_version
}

spaceship_async_job_node_version() {
  # Show NODE status only for JS-specific folders
  [[ -f package.json || -d node_modules ]] || return

  local 'node_version'

  if spaceship::exists nvm; then
    node_version=$(nvm current 2>/dev/null)
    [[ $node_version == "system" || $node_version == "node" ]] && return
  elif spaceship::exists nodenv; then
    node_version=$(nodenv version-name)
    [[ $node_version == "system" || $node_version == "node" ]] && return
  elif spaceship::exists node; then
    node_version=$(node -v 2>/dev/null)
  else
    return
  fi

  [[ $node_version == $SPACESHIP_NODE_DEFAULT_VERSION ]] && return

  spaceship::section \
    "$SPACESHIP_NODE_COLOR" \
    "${SPACESHIP_NODE_SYMBOL}${node_version}"
}

# Show current version of node, exception system.
spaceship_node() {
  [[ $SPACESHIP_NODE_SHOW == false ]] && return

  local node_version="${SPACESHIP_ASYNC_RESULTS[spaceship_async_job_node_version]}"

  [[ $node_version == $SPACESHIP_NODE_DEFAULT_VERSION ]] && return

  spaceship::section \
    'white' \
    "$SPACESHIP_NODE_PREFIX" \
    "${node_version}" \
    "$SPACESHIP_NODE_SUFFIX"
}
