#!/usr/bin/env python3
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def count_list(name, ext):
    p = ROOT / f"scripts/vscripts/init/precache/{name}"
    t = p.read_text(encoding="utf-8", errors="replace")
    return len(re.findall(rf'"([^"]+\.{ext})"', t))

def count_kv_resources():
    paths = []
    kv_files = [
        "scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_items_custom.txt",
        "scripts/npc/npc_heroes_custom.txt",
        "scripts/npc/npc_units_custom.txt",
    ]
    activelist = (ROOT / "scripts/npc/activelist.txt").read_text(encoding="utf-8", errors="replace")
    heroes = re.findall(r'"(npc_dota_hero_[^"]+)"', activelist)
    for h in heroes:
        fp = ROOT / f"scripts/npc/heroes/{h}.txt"
        if fp.exists():
            kv_files.append(str(fp.relative_to(ROOT)).replace("\\", "/"))

    vpcf = vmdl = vsnd = 0
    for rel in kv_files:
        fp = ROOT / rel
        if not fp.exists():
            continue
        t = fp.read_text(encoding="utf-8", errors="replace")
        vpcf += len(re.findall(r'[^\s"]+\.vpcf', t))
        vmdl += len(re.findall(r'[^\s"]+\.vmdl', t))
        vsnd += len(re.findall(r'[^\s"]+\.vsndevts', t))
    return vpcf, vmdl, vsnd, len(kv_files)

particles = count_list("particlessets.lua", "vpcf")
models = count_list("modelsets.lua", "vmdl")
sounds = count_list("soundsets.lua", "vsndevts")
kv_p, kv_m, kv_s, kv_n = count_kv_resources()

print("=== Manual precache lists ===")
print(f"  particles: {particles}")
print(f"  models:    {models}")
print(f"  sounds:    {sounds}")
print(f"  subtotal:  {particles + models + sounds}")
print()
print(f"=== KV scan ({kv_n} files, may overlap with lists) ===")
print(f"  vpcf refs:     {kv_p}")
print(f"  vmdl refs:     {kv_m}")
print(f"  vsndevts refs: {kv_s}")
print()
print(f"Naive upper bound (lists + KV, ignoring dedup): {particles + models + sounds + kv_p + kv_m + kv_s}")
print()
print("Engine limit: 32767 CLoadingResource entries (16-bit counter)")
