# Blackout Scripts - WORKING SOLUTIONS

## 🔴 Your Screen Color is Fixed!
I've reset your display to normal. The red tint was caused by incorrect gamma values.

## 📦 Available Scripts

### 1. **blackout-v3** (RECOMMENDED)
Brightness-only approach - no color issues!
```bash
# Turn screen black
DISPLAY=:1 ~/scripts/toggle_display/blackout-v3 on

# Restore screen
DISPLAY=:1 ~/scripts/toggle_display/blackout-v3 off

# Fix color issues
DISPLAY=:1 ~/scripts/toggle_display/blackout-v3 fix
```

### 2. **blackout-window** (Alternative)
Creates fullscreen black window
```bash
# Show black window
DISPLAY=:1 ~/scripts/toggle_display/blackout-window on

# Remove window  
DISPLAY=:1 ~/scripts/toggle_display/blackout-window off
```

### 3. **test-blackout-methods.sh** (Find what works)
Interactive test to find best method for your hardware
```bash
DISPLAY=:1 ~/scripts/toggle_display/test-blackout-methods.sh
```

## 🚨 If Colors Get Messed Up Again

Quick fix command:
```bash
DISPLAY=:1 xrandr --output DP-0 --gamma 1:1:1 --brightness 1 && DISPLAY=:1 xgamma -gamma 1.0
```

Or use:
```bash
DISPLAY=:1 ~/scripts/toggle_display/blackout-v3 fix
```

## ⚙️ Why v3 Works Better

**Old approach (v1/v2):** 
- Used gamma manipulation (--gamma 0.01:0.01:0.01)
- ❌ Caused color channel issues (red tint)
- ❌ Some drivers handle low gamma incorrectly

**New approach (v3):**
- Uses ONLY brightness (--brightness 0)
- ✅ No color distortion
- ✅ Clean on/off toggle
- ✅ Reliable restoration

## 🎯 Quick Start

Best option for your system:
```bash
# Blackout
DISPLAY=:1 xrandr --output DP-0 --brightness 0

# Restore
DISPLAY=:1 xrandr --output DP-0 --brightness 1
```

## 📝 Notes

- Your display: **:1** (not :0)
- Your output: **DP-0**
- Remote desktop will still show normal screen
- This only affects physical monitor visibility