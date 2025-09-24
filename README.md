# blackout 🖥️⬛

Toggle physical monitor to black while maintaining remote desktop visibility. Ubuntu 24.10+ optimized.

## Features

- **Physical-only blackout** - Monitor appears black locally, normal via VNC/RDP
- **State persistence** - Remembers toggle state across sessions  
- **Multi-backend support** - X11 (xrandr), Wayland (wlr-randr/ddcutil)
- **Emergency recovery** - Force restore command for stuck states
- **Race condition safe** - Lock-based concurrency protection

## Installation

### Quick Install
```bash
curl -sSL https://github.com/zudsniper/blackout/raw/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/zudsniper/blackout
cd blackout
chmod +x install.sh
./install.sh
```

### Location
Installs to `~/scripts/toggle_display/blackout` with symlink in `~/.local/bin/`

## Usage

```bash
blackout              # Toggle state
blackout on           # Enable blackout
blackout off          # Restore display
blackout status       # Check state
blackout restore      # Force recovery
```

## Dependencies

### X11
- `x11-xserver-utils` (xrandr)

### Wayland
- `wlr-randr` (preferred) OR
- `ddcutil` + i2c permissions:
  ```bash
  sudo apt install ddcutil
  sudo usermod -a -G i2c $USER
  # Logout/login required
  ```

## Technical Details

### Method
- **X11**: Gamma manipulation via xrandr (0.1:0.1:0.1)
- **Wayland**: wlr-randr gamma or DDC/CI brightness control
- **State**: Stored in `~/.local/state/blackout/`

### Security Note
Screen content remains in framebuffer - accessible to screen recording software. Not a security tool.

## Troubleshooting

### Display stuck black
```bash
blackout restore
# OR manually:
xrandr --output $(xrandr | grep " connected" | head -1 | awk '{print $1}') --gamma 1:1:1 --brightness 1
```

### Wayland issues
Install ddcutil for hardware control:
```bash
sudo apt install ddcutil i2c-tools
sudo modprobe i2c-dev
```

### State corruption
```bash
rm -rf ~/.local/state/blackout
blackout off
```

## Limitations

- No multi-monitor support (first display only)
- Wayland compositor-dependent
- Some GPUs ignore gamma values
- HDR displays may behave unexpectedly

## License

MIT

## Author

Jason [@zudsniper](https://github.com/zudsniper)