#!/bin/bash
# Misst den Test-Mac und schreibt inputs/ENVIRONMENT.json neu.
# Aufruf auf dem Mac aus dem Ordner MorphDemo: ./tools/umgebung-messen.sh
set -u
cd "$(dirname "$0")/.."
ziel=inputs/ENVIRONMENT.json

ver() { command -v "$1" >/dev/null 2>&1 && { "$@" 2>&1 | head -1; } || echo "not installed"; }
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr -d '\n'; }

os="$(sw_vers -productName) $(sw_vers -productVersion) ($(sw_vers -buildVersion)), $(uname -m)"
kern="Darwin $(uname -r)"
cpu="$(sysctl -n machdep.cpu.brand_string)"
kerne="$(sysctl -n hw.perflevel0.physicalcpu 2>/dev/null) performance + $(sysctl -n hw.perflevel1.physicalcpu 2>/dev/null) efficiency cores"
ram=$(( $(sysctl -n hw.memsize) / 1073741824 ))
gpu="$(system_profiler SPDisplaysDataType 2>/dev/null | awk -F': ' '/Chipset Model/{c=$2} /Total Number of Cores/{n=$2} END{print c ", " n " GPU cores"}')"
metal="$(system_profiler SPDisplaysDataType 2>/dev/null | awk -F': ' '/Metal Support/{print $2; exit}')"
aufl="$(system_profiler SPDisplaysDataType 2>/dev/null | awk -F': ' '/Resolution/{gsub(/^ +/,"",$2); printf "%s%s", s, $2; s="; "}')"
clt="$(xcode-select -p 2>/dev/null || echo 'not installed')"
cc="$(ver clang --version)"
ld="$(ld -v 2>&1 | head -1)"
py="$(ver python3 --version)"
mk="$(ver make --version)"
brew="$(command -v brew >/dev/null 2>&1 && brew --version | head -1 || echo 'not installed')"
rust="$(ver rustc --version)"
datum="$(date +%Y-%m-%d)"

cat > "$ziel" <<JSON
{
  "schema_version": 1,
  "benchmark": "MorphDemo (mac adaptation of v1.1)",
  "measured_on": "$datum",
  "note": "Measured values of the test machine. Runs and evaluation happen on this machine.",
  "host": {
    "os": "$(esc "$os")",
    "kernel": "$(esc "$kern")",
    "cpu": "$(esc "$cpu"), $(esc "$kerne")",
    "ram_gib": $ram,
    "gpu": "$(esc "$gpu"), unified memory"
  },
  "graphics_runtime": {
    "metal": "Metal.framework, MetalKit.framework ($(esc "$metal"))",
    "opengl": "OpenGL.framework, OpenGL 4.1 core profile (deprecated by Apple, still shipped)",
    "vulkan": "not available (no MoltenVK installed)",
    "cuda": "not available",
    "windowing": "Cocoa / AppKit (WindowServer). No X11, no Wayland, no SDL, no GLFW"
  },
  "display": {
    "target": "1920x1080",
    "actual": "$(esc "$aufl")"
  },
  "audio_runtime": {
    "server": "Core Audio",
    "libraries": "CoreAudio.framework, AudioToolbox.framework (AudioQueue, AudioUnit)"
  },
  "native_executables": {
    "format": "Mach-O 64-bit arm64, loaded by /usr/lib/dyld",
    "signing": "Apple Silicon requires a code signature; ad-hoc (codesign -s -) is enough for local runs. The arm64 linker signs ad-hoc by default.",
    "rosetta": "not to be used"
  },
  "build_tools": {
    "developer_dir": "$(esc "$clt")",
    "cc": "$(esc "$cc")",
    "ld": "$(esc "$ld")",
    "python": "$(esc "$py")",
    "make": "$(esc "$mk")",
    "rust": "$(esc "$rust")",
    "other": "codesign, otool, lipo, strip, xxd (system tools)",
    "package_managers": "Homebrew: $(esc "$brew"). Do not rely on it for the build unless it is installed."
  },
  "limits": {
    "development_time": "none",
    "tokens_or_cost": "none",
    "iterations": "none"
  }
}
JSON
echo "geschrieben: $ziel"
