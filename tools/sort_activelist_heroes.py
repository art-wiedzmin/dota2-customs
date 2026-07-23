"""Parse scripts/npc/activelist.txt and print heroes sorted by unit name A→Z."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
text = (ROOT / "scripts/npc/activelist.txt").read_text(encoding="utf-8")

rows = []
for line in text.splitlines():
    m = re.match(
        r'^\s*"(npc_dota_hero_[a-z0-9_]+)"\s+".*?//(.*)$',
        line,
    )
    if m:
        key, note = m.group(1), m.group(2).strip()
        rows.append((key, note))

rows.sort(key=lambda x: x[0])
for i, (k, note) in enumerate(rows, 1):
    print(f"{i}\t{k}\t{note}")
