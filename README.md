# tapete

Simple script to switch between wallpapers with `feh`.

## Configuration

In `~/.config/tapete.toml` you can add multiple wallpaper entries with the
following structure:

```toml
[[wallpaper]]
name = "Name of wallpaper"
path = "~/Wallpapers/car.jpg" # Nushell glob pattern is supported
```

## Desktop Shortcut

```desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Tapete
Comment=Simple wallpaper switcher.
Exec=/home/jonas/Projects/tapete/tapete.nu
Path=
Terminal=true
StartupNotify=false
```
