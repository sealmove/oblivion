import terminal, strutils

proc colored*(text: string, color: ForegroundColor): string =
  ansiForegroundColorCode(color) & text & ansiResetCode

proc styled*(text: string, style: Style): string =
  ansiStyleCode(style) & text & ansiResetCode

proc styled*(text: string, style: Style, color: ForegroundColor): string =
  ansiForegroundColorCode(color) & ansiStyleCode(style) & text & ansiResetCode

proc pretty*(s: string): string =
  for word in s.split:
    if word == "sudo":
      result &= colored(word, fgRed)
    elif word.startsWith("-"):
      result &= colored(word, fgCyan)
    elif word.startsWith("@"):
      result &= colored(word, fgMagenta)
    else:
      result &= word
    result &= " "

proc error*(msg: string) =
  styledWriteLine(stderr, fgRed, styleBright, "Error: ", resetStyle, msg)

proc note*(msg: string) =
  styledWriteLine(stderr, fgYellow, styleBright, "Note: ", resetStyle, msg)
