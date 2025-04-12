#!/usr/bin/env nu

export def main [] {
  let env_key = "TAPETE_CONFIG"
  let config_path = ($env | default ($nu.home-path | path join ".config" "tapete.toml") $env_key | get $env_key)

  let config = ($config_path | open --raw | from toml)
  mut select_index = 0
  let amount = ($config | get wallpaper | length)

  let fehbg_original_path = ($nu.home-path | path join ".fehbg")
  let fehbg_backup_path = ($nu.home-path | path join ".fehbg-backup") 
  cp $fehbg_original_path $fehbg_backup_path

  let wallpaper_path = {|index| ($config | get wallpaper | select $index | first | get path | glob $in | first)}

  loop {
    clear
    print $"(ansi yellow)q(ansi reset)uit | (ansi yellow)↑(ansi reset) up | (ansi yellow)↓(ansi reset) down"
    (do $wallpaper_path $select_index) | set-wallpaper

    for wallpaper_entry in ($config | get wallpaper | enumerate) {
      let prefix = if ($wallpaper_entry.index == $select_index) {
        $"(ansi yellow)> (ansi reset)"
      } else {
        "  "
      }
      print $"($prefix)($wallpaper_entry.item.name)"
      print
    }

    match (input listen) {
      { type: key, key_type: char, code: q} | { type: key, key_type: other, code: esc } => {
        run-external $fehbg_backup_path
        rm $fehbg_backup_path
        break
      }
      { type: key, key_type: other, code: up } => {
        $select_index -= 1
        if ($select_index < 0) {
          $select_index = $amount - 1
        }
      }
      { type: key, key_type: other, code: down} => {
        $select_index += 1
        if ($select_index > $amount - 1) {
          $select_index = 0
        }
      }
      { type: key, key_type: other, code: enter} => {
        break
      }
    }
  }
}

def set-wallpaper []: string -> nothing {
  feh --bg-scale $in
}
