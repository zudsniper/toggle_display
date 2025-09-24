# Blackout v2.0 - Fixed for DISPLAY :1

## Key Fixes
- ✅ Auto-detects DISPLAY :1 (was hardcoded to :0)
- ✅ More aggressive gamma values (0.01 vs 0.1)
- ✅ Multiple fallback methods
- ✅ Detects DP-0 output correctly

## Quick Test

```bash
# Direct with display
DISPLAY=:1 ~/scripts/toggle_display/blackout on

# Or use wrapper (auto-detects display)
~/scripts/toggle_display/blackout-wrapper on

# Emergency restore
DISPLAY=:1 ~/scripts/toggle_display/blackout restore
```

## Methods Used (in order)
1. xrandr gamma 0.01:0.01:0.01 + brightness 0.01
2. xgamma -gamma 0.01 (if available)
3. xcalib contrast manipulation (if installed)
4. DDC/CI hardware control (if installed)

## Install Optional Tools for Better Control
```bash
# For xcalib (better color control)
sudo apt install xcalib

# For DDC/CI (hardware-level control)
sudo apt install ddcutil
sudo usermod -a -G i2c $USER
# Then logout/login
```

## Troubleshooting
If screen doesn't go black enough:
1. Install xcalib: `sudo apt install xcalib`
2. Try: `DISPLAY=:1 xcalib -co 1 -a` (sets contrast to minimum)
3. Or combine: `DISPLAY=:1 xrandr --output DP-0 --brightness 0 --gamma 0:0:0`

Note: Some GPUs/drivers reject gamma 0, so script uses 0.01 as minimum.