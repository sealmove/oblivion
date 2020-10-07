import os, terminal, tables, strformat, strutils, parsecfg, parseopt
import oblivion/utils

# Get XDG directory
if not existsEnv("XDG_CONFIG_DIRS"):
  error("Env var 'XDG_CONFIG_DIRS' is not set")
  quit QuitFailure

let
  xdg = getEnv("XDG_CONFIG_DIRS")
  cfgdir = xdg / "oblivion"
  cfgfile = cfgdir / "config.ini"

if not existsDir(xdg):
  error("Env var 'XDG_CONFIG_DIRS' points to non-existent directory")
  quit QuitFailure

# Find config file
if not existsDir(cfgdir):
  try:
    createDir(cfgdir)
    note(fmt"Created dir: {cfgdir}")
  except:
    error(fmt"Could not create dir: {cfgdir}")
    quit QuitFailure

if not existsFile(cfgfile):
  try: 
    writeFile(cfgfile, "")
    note(fmt"Created empty file: {cfgfile}")
  except:
    error(fmt"Could not file: {cfgdir}")
    quit QuitFailure

# Parse config file
let cfg = loadConfig(cfgfile)

proc findGroup(arg: string): string =
  var matches = newSeq[string]()
  for g in cfg.keys:
    if g.startsWith(arg):
      matches.add(g)
  case matches.len
  of 0:
    error("Group not found")
  of 1:
    result = matches[0]
  else:
    error("Ambiguous group; multiple matches:")
    for m in matches:
      echo "  " & colored(m, fgYellow)
    quit QuitFailure

proc findAlias(group, arg: string): tuple[alias, cmd: string] =
  var matches = initTable[string, string]()
  for alias, cmd in cfg[group]:
    if alias.startsWith(arg):
      matches.add(alias, cmd)
  case matches.len
  of 0:
    error("Alias not found")
  of 1:
    for k, v in matches.pairs:
      result = (k, v)
  else:
    error("Ambiguous alias; multiple matches:")
    for alias, cmds in matches.pairs:
      echo "  " & colored(alias, fgYellow)
    quit QuitFailure

proc printGroup(group: string) =
  echo "\n" & styled("[" & group & "]", styleBright, fgYellow)
  for alias, cmd in cfg[group]:
    echo fmt" {alias:<10}" & styled("| ", styleBright, fgYellow) & pretty(cmd)

if paramCount() == 0:
  echo "Available groups:"
  for g in cfg.keys:
    echo "  " & styled(g, styleBright, fgYellow)
  quit QuitFailure
let g = findGroup(paramStr(1))
if paramCount() == 1:
  printGroup(g)
  quit QuitSuccess
let (alias, cmd) = findAlias(g, paramStr(2))
echo "[+] " & pretty(cmd)
let ret = execShellCmd(cmd & "  " & commandLineParams()[1..^1].join(" "))
if ret != 0:
  quit QuitFailure
