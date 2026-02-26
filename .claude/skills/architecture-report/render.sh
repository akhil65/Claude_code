#!/usr/bin/env bash
# Render all .mmd files in docs/architecture/ to SVG
# Usage: bash render.sh [output-dir] [theme] [width]
#   output-dir  default: docs/architecture
#   theme       default: dark  (dark | default | forest | neutral | base)
#   width       default: 1200
set -euo pipefail

ARCH_DIR="${1:-docs/architecture}"
THEME="${2:-dark}"
WIDTH="${3:-1200}"

# --- preflight ---
if ! command -v npx &>/dev/null; then
  echo "Error: npx not found. Install Node.js to continue." >&2
  exit 1
fi

mkdir -p "$ARCH_DIR"

shopt -s nullglob
files=("$ARCH_DIR"/*.mmd)

if [ ${#files[@]} -eq 0 ]; then
  echo "No .mmd files found in $ARCH_DIR"
  exit 0
fi

echo "Rendering ${#files[@]} diagram(s)  [dir: $ARCH_DIR  theme: $THEME  width: ${WIDTH}px]"
echo ""

rendered=0
failed=0

for mmd_file in "${files[@]}"; do
  svg_file="${mmd_file%.mmd}.svg"
  echo "  $(basename "$mmd_file") → $(basename "$svg_file")"

  if npx --yes mmdc -i "$mmd_file" -o "$svg_file" -t "$THEME" --width "$WIDTH"; then
    if [ -s "$svg_file" ]; then
      size=$(du -h "$svg_file" | cut -f1)
      echo "  ✓ $(basename "$svg_file") ($size)"
      ((rendered++)) || true
    else
      echo "  ✗ $(basename "$svg_file") rendered but is empty — skipping" >&2
      rm -f "$svg_file"
      ((failed++)) || true
    fi
  else
    echo "  ✗ Failed to render $(basename "$mmd_file")" >&2
    ((failed++)) || true
  fi

  echo ""
done

# --- summary ---
echo "────────────────────────────────────"
echo "  Rendered: $rendered   Failed: $failed"
echo ""

if [ "$failed" -gt 0 ]; then
  exit 1
fi

ls -lh "$ARCH_DIR"/*.svg
