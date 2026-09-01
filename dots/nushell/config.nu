$env.config.show_banner = false

$env.config.hooks.command_not_found = {
  |command_name|
  print (command-not-found $command_name | str trim)
}

def prompt_dir [] {
  mut text = ""
  if ($env.PWD | str contains $nu.home-dir) {
    $text = $"~/($env.PWD | path relative-to $nu.home-dir)"
  }

  {
    text: $text
    fg: lud
    bg: grey19
  }
}

def render_segment [segment: record] {
  let style = {
    fg: $segment.fg
    bg: $segment.bg
  }

  $"(ansi $style)($segment.text)"
}

def render_divider [left_bg: record, right_bg: record] {
  let style = {
    fg: $left_bg.fg
    bg: $right_bg.bg
  }

  $"(ansi $style)"
}

def render_start_seg [seg: record] {
  let style = {
    fg: $seg.bg
    bg: $seg.bg
  }
  $"(ansi $style)"
}

def create_left_prompt [] {
  $"$(ansi )"
}
