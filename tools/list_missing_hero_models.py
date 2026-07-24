--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
alist = (ROOT / "scripts/npc/activelist.txt").read_text(encoding="utf-8")
heroes = sorted(set(re.findall(r'"(npc_dota_hero_[a-z0-9_]+)"', alist)))
heroes_txt = (ROOT / "scripts/npc/npc_heroes.txt").read_text(encoding="utf-8", errors="replace")
ms = (ROOT / "scripts/vscripts/init/precache/modelsets.lua").read_text(encoding="utf-8", errors="replace")
precache = {p.lower().replace("\\", "/") for p in re.findall(r'"([^"]+\.vmdl)"', ms)}


def hero_model(hero_key: str) -> str | None:
    pat = r'^[ \t]*"' + re.escape(hero_key) + r'"[ \t]*$\s*\n[ \t]*\{'
    m = re.search(pat, heroes_txt, re.M)
    if not m:
        return None
    start = m.end() - 1
    depth = 0
    i = start
    while i < len(heroes_txt):
        c = heroes_txt[i]
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                block = heroes_txt[start : i + 1]
                mm = re.search(r'"Model"\s+"([^"]+)"', block)
                if mm:
                    return mm.group(1).replace("\\", "/").strip()
                return None
        i += 1
    return None


def main() -> None:
    missing = []
    for h in heroes:
        mod = hero_model(h)
        if mod and mod.lower().replace("\\", "/") not in precache:
            missing.append(h)
    print("\n".join(missing))


if __name__ == "__main__":
    main()