autoload -U promptinit && promptinit

#
# Inspired by https://github.com/miekg/lean/
# Built using `Blox`: https://github.com/yardnsm/blox-zsh-theme
#

# ---------------------------------------------
# Blox settings

BLOX_CONF__ONELINE=true
BLOX_CONF__NEWLINE=true

# BLOX_CONF__BLOCK_PREFIX='('
# BLOX_CONF__BLOCK_SUFFIX=')'

BLOX_BLOCK__SYMBOL_SYMBOL='λ'
BLOX_BLOCK__SYMBOL_EXIT_SYMBOL='λ'
BLOX_BLOCK__SYMBOL_COLOR=140

BLOX_BLOCK__GIT_CLEAN_SYMBOL='+'
BLOX_BLOCK__GIT_DIRTY_SYMBOL='-'

BLOX_SEG__UPPER_LEFT=(blox_block__tmux blox_block__bgjobs blox_block__symbol)
BLOX_SEG__UPPER_RIGHT=(blox_block__exec_time blox_block__vi blox_block__cwd_ng blox_block__nodejs blox_block__git)

# ---------------------------------------------
# Custom blocks

blox_block__tmux() {
  [[ -n "$TMUX" ]] && echo "%F{yellow}t%f"
}

blox_block__cwd_ng() {
  echo "%F{140}%(4~|.../%3~|%~)%f"
}

blox_block__vi() {
  local vim_mode_format="%F{yellow}[NORMAL]%f"
  echo "${${KEYMAP/vicmd/$vim_mode_format}/(main|viins)/}"
}

# The following were taken from https://github.com/miekg/lean/
# cmd_timestamp_start: start
# cmd_timestamp_stop: stop
# cmd_timstatmp_persist: persist the timestamp to next redraw
blox_block__exec_time() {
  local stop=${cmd_timestamp_stop:-$EPOCHSECONDS}
  local start=${cmd_timestamp_start:-$stop}
  integer elapsed=$stop-$start
  (($elapsed > 5)) && echo "%F{yellow}$(blox_helper__humen_time $elapsed)%f"
}

blox_helper__humen_time() {
  local tmp=$1
  local days=$(( tmp / 60 / 60 / 24 ))
  local hours=$(( tmp / 60 / 60 % 24 ))
  local minutes=$(( tmp / 60 % 60 ))
  local seconds=$(( tmp % 60 ))
  (( $days > 0 )) && echo -n "${days}d "
  (( $hours > 0 )) && echo -n "${hours}h "
  (( $minutes > 0 )) && echo -n "${minutes}m "
  echo "${seconds}s"
}

blox_hook__preexec() {
  unset cmd_timestamp_stop
  cmd_timestamp_start=$EPOCHSECONDS
}

blox_hook__precmd_exec_time() {
  [[ $cmd_timestamp_persist != 1 ]] && unset cmd_timestamp_start
}

# ---------------------------------------------
# Async 'git fetch'

ASYNC_PROC=0

blox_hook__precmd_git_fetch() {
  async() {
    git fetch &> /dev/null
    kill -s USR2 $$
  }

  # Kill child if necessary
  if [[ "${ASYNC_PROC}" != 0 ]]; then
    kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
  fi

  if blox_block__git_helper__is_git_repo; then
    async &!
    ASYNC_PROC=$!

    # After the async process to prompt will be redrawer, so
    # we need to persist the current execution information
    # till the next redraw
    cmd_timestamp_persist=1
    cmd_timestamp_stop=$EPOCHSECONDS
  else
    cmd_timestamp_persist=0
  fi
}

function TRAPUSR2() {
  ASYNC_PROC=0
  blox_helper__redraw_prompt

  cmd_timestamp_persist=0
  blox_hook__precmd_exec_time
}

# ---------------------------------------------
# Set Vi mode

bindkey -v
export KEYTIMEOUT=1

function zle-keymap-select {
  blox_helper__redraw_prompt
}

zle -N zle-keymap-select

# ---------------------------------------------

blox_helper__redraw_prompt() {
  local tmp=$BLOX_CONF__NEWLINE
  BLOX_CONF__NEWLINE=false

  blox_hook__build_prompt
  zle && zle reset-prompt

  BLOX_CONF__NEWLINE=true
}

# ---------------------------------------------

prompt blox

# Should be added lastly!
add-zsh-hook precmd blox_hook__precmd_git_fetch
add-zsh-hook precmd blox_hook__precmd_exec_time
add-zsh-hook preexec blox_hook__preexec
