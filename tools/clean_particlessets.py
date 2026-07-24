#!/usr/bin/env python3
"""Generate cleaned particlessets.lua: dedup + remove clearly unused entries."""
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTENT = ROOT.parent.parent / "content/dota_addons/clrb"
PARTICLES_FILE = ROOT / "scripts/vscripts/init/precache/particlessets.lua"

HERO_FOLDER_ALIASES = {
    "npc_dota_hero_drow_ranger": ["hero_drow", "hero_drow_ranger"],
    "npc_dota_hero_storm_spirit": ["hero_stormspirit", "hero_storm_spirit"],
    "npc_dota_hero_witch_doctor": ["hero_witchdoctor", "hero_witch_doctor"],
    "npc_dota_hero_shadow_shaman": ["hero_shadowshaman", "hero_shadow_shaman"],
    "npc_dota_hero_vengefulspirit": ["hero_vengeful", "hero_vengefulspirit"],
    "npc_dota_hero_sand_king": ["hero_sandking", "hero_sand_king"],
    "npc_dota_hero_crystal_maiden": ["hero_crystalmaiden", "hero_crystal_maiden"],
    "npc_dota_hero_abyssal_underlord": ["heroes_underlord", "hero_abyssal_underlord"],
    "npc_dota_hero_phantom_assassin": ["hero_phantom_assassin", "hero_phantom_assassin_persona"],
    "npc_dota_hero_antimage": ["hero_antimage", "hero_antimage_female"],
    "npc_dota_hero_enchantress": ["hero_enchantress", "hero_ench"],
    "npc_dota_hero_obsidian_destroyer": ["hero_obsidian_destroyer", "hero_outworld_devourer"],
    "npc_dota_hero_nevermore": ["hero_nevermore", "hero_shadow_fiend"],
    "npc_dota_hero_wisp": ["hero_wisp", "hero_io"],
    "npc_dota_hero_life_stealer": ["hero_life_stealer", "hero_lifestealer"],
    "npc_dota_hero_queenofpain": ["hero_queenofpain", "hero_queen_of_pain"],
    "npc_dota_hero_troll_warlord": ["hero_troll_warlord", "hero_troll"],
    "npc_dota_hero_spirit_breaker": ["hero_spirit_breaker", "hero_bara"],
    "npc_dota_hero_rattletrap": ["hero_rattletrap", "hero_clockwerk"],
    "npc_dota_hero_doom_bringer": ["hero_doom_bringer", "hero_doom"],
    "npc_dota_hero_skeleton_king": ["hero_skeletonking", "hero_wraith_king"],
    "npc_dota_hero_magnataur": ["hero_magnataur", "hero_magnus"],
    "npc_dota_hero_shredder": ["hero_shredder", "hero_timbersaw"],
    "npc_dota_hero_zuus": ["hero_zuus", "hero_zues"],
}

FORCE_REMOVE_EXACT = {
    "particles/arena_ring.vpcf",
    "particles/arena_ring_1.vpcf",
    "particles/test_arena_ring.vpcf",
    "particles/test_ring_new.vpcf",
    "particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf",
}
FORCE_REMOVE_PREFIXES = ("particles/test_", "particles/dev/")

ECON_KEEP = {
    "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf",
    "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",
    "particles/econ/courier/courier_trail_lava/courier_trail_lava.vpcf",
    "particles/econ/courier/courier_babyroshan_ti10/courier_babyroshan_ti10_ambient.vpcf",
    "particles/econ/courier/courier_babyroshan_ti10/courier_babyroshan_ti10_ambient_eyes_a.vpcf",
    "particles/econ/items/monkey_king/arcana/monkey_arcana_cloud.vpcf",
    "particles/econ/items/omniknight/omni_2021_immortal/omni_2021_immortal.vpcf",
    "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf",
}

KEEP_PREFIXES = (
    "particles/clrb/",
    "particles/status_fx/",
    "particles/generic_",
    "particles/msg_fx/",
    "particles/items",
    "particles/items2",
    "particles/scrolls/",
    "particles/death_ring",
    "particles/item_drop",
    "particles/respawn",
    "particles/wings_",
    "particles/zuus_",
    "terrain/",
    "particles/item_rank",
)


def hero_folders_for_key(hero_key: str) -> list[str]:
    if hero_key in HERO_FOLDER_ALIASES:
        return HERO_FOLDER_ALIASES[hero_key]
    prefix = "npc_dota_hero_"
    if hero_key.startswith(prefix):
        return ["hero_" + hero_key[len(prefix):]]
    return []


def parse_activelist() -> set[str]:
    text = (ROOT / "scripts/npc/activelist.txt").read_text(encoding="utf-8", errors="replace")
    return set(re.findall(r'"(npc_dota_hero_[^"]+)"', text))


def parse_skill_config_heroes() -> set[str]:
    fp = ROOT / "scripts/vscripts/ingame/Skill/Config.lua"
    if not fp.exists():
        return set()
    text = fp.read_text(encoding="utf-8", errors="replace")
    return set(re.findall(r'hero\s*=\s*"(npc_dota_hero_[^"]+)"', text))


def build_active_folders(activelist: set[str]) -> set[str]:
    skill_heroes = parse_skill_config_heroes()
    all_heroes = activelist | skill_heroes
    folders = set()
    for h in all_heroes:
        folders.update(hero_folders_for_key(h))
    heroes_dir = ROOT / "scripts/npc/heroes"
    for h in all_heroes:
        fp = heroes_dir / f"{h}.txt"
        if not fp.exists():
            continue
        content = fp.read_text(encoding="utf-8", errors="replace")
        for m in re.finditer(r"particles/units/heroes/([^/]+)/", content):
            folders.add(m.group(1))
    return folders


def collect_referenced_vpcf() -> set[str]:
    refs = set()
    dirs = [ROOT / "scripts", CONTENT / "panorama"] if CONTENT.exists() else [ROOT / "scripts"]
    for d in dirs:
        if not d.exists():
            continue
        for fp in d.rglob("*"):
            if not fp.is_file() or fp.name == "particlessets.lua":
                continue
            if fp.suffix.lower() not in {".lua", ".txt", ".xml", ".js", ".vpcf"}:
                continue
            try:
                content = fp.read_text(encoding="utf-8", errors="replace")
            except OSError:
                continue
            refs.update(re.findall(r"(?:particles|models|terrain)/[^\s\"']+\.vpcf", content))
    return refs


def extract_hero_folder(path: str) -> str | None:
    m = re.search(r"/units/heroes/([^/]+)/", path)
    return m.group(1) if m else None


def should_remove(path: str, seen: set[str], active_folders: set[str], referenced: set[str]) -> str | None:
    if path.endswith(".vmdl"):
        return "vmdl_in_particles"
    if path in seen:
        return "duplicate"
    if path in FORCE_REMOVE_EXACT or any(path.startswith(p) for p in FORCE_REMOVE_PREFIXES):
        return "test_or_dev"
    if path.startswith("models/"):
        return "invalid_models_path"
    if path in referenced or path in ECON_KEEP:
        return None
    if any(path.startswith(p) for p in KEEP_PREFIXES):
        return None
    folder = extract_hero_folder(path)
    if folder:
        if folder not in active_folders:
            return f"hero_not_in_activelist:{folder}"
        return None
    if path.startswith("particles/econ/"):
        return "econ_unreferenced"
    if path.startswith("particles/bp_") or path.startswith("particles/events/"):
        return "misc_unreferenced"
    return None


def main():
    activelist = parse_activelist()
    active_folders = build_active_folders(activelist)
    referenced = collect_referenced_vpcf()

    raw = PARTICLES_FILE.read_text(encoding="utf-8", errors="replace")
    lines = raw.splitlines()
    kept = []
    removed = []
    seen = set()

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("--") or stripped in ("return {", "}"):
            kept.append(line)
            continue

        paths = re.findall(r'"([^"]+\.(?:vpcf|vmdl))"', line)
        if not paths:
            kept.append(line)
            continue

        kept_paths = []
        for path in paths:
            reason = should_remove(path, seen, active_folders, referenced)
            if reason:
                removed.append((path, reason))
                continue
            seen.add(path)
            kept_paths.append(path)

        if not kept_paths:
            continue

        indent = re.match(r"^(\s*)", line).group(1)
        if len(kept_paths) == 1:
            kept.append(f'{indent}"{kept_paths[0]}",')
        else:
            joined = ", ".join(f'"{p}"' for p in kept_paths)
            kept.append(f"{indent}{joined},")

    out = "\n".join(kept) + "\n"
    out_path = ROOT / "tools/particlessets_cleaned.lua"
    out_path.write_text(out, encoding="utf-8")

    rc = Counter(r for _, r in removed)
    orig = len(re.findall(r'"([^"]+\.(?:vpcf|vmdl))"', raw))
    print(f"Original entries: {orig}")
    print(f"Kept unique: {len(seen)}")
    print(f"Removed: {len(removed)}")
    for reason, count in rc.most_common(20):
        print(f"  {count:4d} {reason}")
    print(f"Wrote {out_path}")


if __name__ == "__main__":
    main()
