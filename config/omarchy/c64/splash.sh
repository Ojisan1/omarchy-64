# Sourced by ~/.bashrc when OMARCHY_C64=1 (foot C64 profile).
# Prints the boot banner, then a C64-style prompt: nothing at $HOME, path elsewhere.

_omarchy_c64_cols() {
  local cols="${COLUMNS:-0}"
  if [[ -z "$cols" || "$cols" -lt 1 ]]; then
    cols=$(stty size 2>/dev/null | awk '{print $2}')
  fi
  if [[ -z "$cols" || "$cols" -lt 1 ]]; then
    cols=80
  fi
  printf '%s' "$cols"
}

_omarchy_c64_center() {
  local text="$1"
  local cols len pad
  cols=$(_omarchy_c64_cols)
  len=${#text}
  pad=$(( (cols - len) / 2 ))
  (( pad < 0 )) && pad=0
  printf '%*s%s\n' "$pad" '' "$text"
}

_omarchy_c64_splash() {
  local ver major title ram_line mem_kb mem_avail_kb mem_g mem_free_bytes

  ver=$(omarchy version 2>/dev/null | head -n1 || true)
  major=${ver%%.*}
  [[ "$major" =~ ^[0-9]+$ ]] || major=4
  title="**** OMARCHY 64 BASH V${major} ****"

  mem_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
  mem_avail_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
  mem_g=$(( (mem_kb + 524288) / 1048576 ))
  mem_free_bytes=$(( mem_avail_kb * 1024 ))
  ram_line="${mem_g}G RAM SYSTEM  ${mem_free_bytes} BYTES FREE"

  printf '\n'
  _omarchy_c64_center "$title"
  printf '\n'
  _omarchy_c64_center "$ram_line"
  printf '\nREADY.\n'
}

_omarchy_c64_prompt() {
  local home="${HOME%/}"
  if [[ "$PWD" == "$home" ]]; then
    PS1=""
  elif [[ "$PWD" == "$home"/* ]]; then
    PS1="~${PWD#"$home"} "
  else
    PS1="${PWD} "
  fi
}

# Force Commodore text: no rainbow ls/git/grep on the blue screen.
export NO_COLOR=1
export CLICOLOR=0
unset COLORTERM
export LS_COLORS=
export EZA_COLORS=
export EXA_COLORS=
export GREP_COLOR=
export GREP_COLORS=
export GIT_CONFIG_COUNT=1
export GIT_CONFIG_KEY_0=color.ui
export GIT_CONFIG_VALUE_0=never

if command -v eza &>/dev/null; then
  alias ls='eza -lh --group-directories-first --color=never --icons=never'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --git --color=never --icons=never'
  alias lta='lt -a'
fi
alias grep='grep --color=never'
alias fgrep='fgrep --color=never'
alias egrep='egrep --color=never'

trap - DEBUG 2>/dev/null || true
unset PROMPT_COMMAND
PROMPT_COMMAND=_omarchy_c64_prompt
_omarchy_c64_prompt

_omarchy_c64_splash
unset -f _omarchy_c64_cols _omarchy_c64_center _omarchy_c64_splash
