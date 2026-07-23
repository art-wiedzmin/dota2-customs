#!/usr/bin/env python3
"""Generate cleaned modelsets.lua: dedup + remove clearly unused entries."""
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTENT = ROOT.parent.parent / "content/dota_addons/clrb"
MODELS_FILE = ROOT / "scripts/vscripts/init/precache/modelsets.lua"

# npc_dota_hero_* -> models/heroes/<folder>/ fragments
HERO_MODEL_ALIASES = {
    "npc_dota_hero_drow_ranger": ["drow"],
    "npc_dota_hero_storm_spirit": ["stormspirit", "storm_spirit"],
    "npc_dota_hero_witch_doctor": ["witchdoctor", "witch_doctor"],
    "npc_dota_hero_shadow_shaman": ["shadowshaman", "shadow_shaman"],
    "npc_dota_hero_vengefulspirit": ["vengeful", "vengefulspirit"],
    "npc_dota_hero_sand_king": ["sandking", "sand_king"],
    "npc_dota_hero_crystal_maiden": ["crystalmaiden", "crystal_maiden"],
    "npc_dota_hero_abyssal_underlord": ["abyssal_underlord", "underlord"],
    "npc_dota_hero_phantom_assassin": ["phantom_assassin", "phantom_assassin_persona"],
    "npc_dota_hero_antimage": ["antimage", "antimage_female"],
    "npc_dota_hero_enchantress": ["enchantress", "ench"],
    "npc_dota_hero_obsidian_destroyer": ["obsidian_destroyer", "outworld_devourer"],
    "npc_dota_hero_nevermore": ["nevermore", "shadow_fiend"],
    "npc_dota_hero_wisp": ["wisp", "io"],
    "npc_dota_hero_life_stealer": ["life_stealer", "lifestealer"],
    "npc_dota_hero_queenofpain": ["queenofpain", "queen_of_pain"],
    "npc_dota_hero_troll_warlord": ["troll_warlord", "troll"],
    "npc_dota_hero_spirit_breaker": ["spirit_breaker", "bara"],
    "npc_dota_hero_rattletrap": ["rattletrap", "clockwerk"],
    "npc_dota_hero_doom_bringer": ["doom_bringer", "doom"],
    "npc_dota_hero_skeleton_king": ["skeletonking", "wraith_king"],
    "npc_dota_hero_magnataur": ["magnataur", "magnus"],
    "npc_dota_hero_shredder": ["shredder", "timbersaw"],
    "npc_dota_hero_zuus": ["zuus", "zues", "zeus"],
    "npc_dota_hero_gyrocopter": ["gyro", "gyrocopter"],
    "npc_dota_hero_necrolyte": ["necrolyte", "necro"],
    "npc_dota_hero_legion_commander": ["legion_commander"],
    "npc_dota_hero_dragon_knight": ["dragon_knight"],
    "npc_dota_hero_faceless_void": ["faceless_void"],
    "npc_dota_hero_death_prophet": ["death_prophet"],
    "npc_dota_hero_night_stalker": ["night_stalker", "nightstalker"],
    "npc_dota_hero_treant": ["treant", "treant_protector"],
    "npc_dota_hero_riki": ["riki", "rikimaru"],
    "npc_dota_hero_bloodseeker": ["bloodseeker", "blood_seeker"],
    "npc_dota_hero_templar_assassin": ["templar_assassin", "lanaya"],
    "npc_dota_hero_winter_wyvern": ["winter_wyvern", "winterwyvern"],
    "npc_dota_hero_nyx_assassin": ["nyx_assassin", "nerubian_assassin"],
    "npc_dota_hero_jakiro": ["jakiro", "twin_headed_dragon"],
    "npc_dota_hero_phantom_lancer": ["phantom_lancer"],
    "npc_dota_hero_naga_siren": ["naga_siren", "siren"],
    "npc_dota_hero_mirana": ["mirana"],
    "npc_dota_hero_broodmother": ["broodmother"],
    "npc_dota_hero_beastmaster": ["beastmaster"],
    "npc_dota_hero_furion": ["furion", "nature_prophet"],
    "npc_dota_hero_undying": ["undying"],
    "npc_dota_hero_phoenix": ["phoenix"],
    "npc_dota_hero_hoodwink": ["hoodwink"],
    "npc_dota_hero_marci": ["marci"],
    "npc_dota_hero_primal_beast": ["primal_beast"],
    "npc_dota_hero_largo": ["largo"],
    "npc_dota_hero_kez": ["kez"],
    "npc_dota_hero_brewmaster": ["brewmaster"],
    "npc_dota_hero_earthshaker": ["earthshaker"],
    "npc_dota_hero_tusk": ["tusk", "tuskarr"],
    "npc_dota_hero_keeper_of_the_light": ["keeper_of_the_light", "kotl"],
}

FORCE_REMOVE_EXACT = {
    "particles/units/heroes/hero_batrider/batrider_flamebreak_dummy.vpcf",
}
FORCE_REMOVE_PREFIXES = (
    "models/items/razor/razor_arcana/",
    "models/items/razor/frostivus2018_razor_",
)

KEEP_PREFIXES = (
    "models/creeps/",
    "models/courier/",
    "models/props_",
    "models/clrb/",
    "models/items/lycan/",
    "models/items/lone_druid/",
    "models/items/muerta/",
    "models/items/dragon_knight/",
    "models/items/windrunner/windrunner_arcana/",
    "models/items/drow/drow_arcana/",
)


def hero_model_folders(hero_key: str) -> list[str]:
    if hero_key in HERO_MODEL_ALIASES:
        return HERO_MODEL_ALIASES[hero_key]
    prefix = "npc_dota_hero_"
    if hero_key.startswith(prefix):
        return [hero_key[len(prefix):]]
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


def build_active_hero_folders(all_heroes: set[str]) -> set[str]:
    folders = set()
    for h in all_heroes:
        folders.update(hero_model_folders(h))
    # persona / alternate hero model dirs
    for f in list(folders):
        folders.add(f + "_persona")
    heroes_dir = ROOT / "scripts/npc/heroes"
    for h in all_heroes:
        fp = heroes_dir / f"{h}.txt"
        if not fp.exists():
            continue
        content = fp.read_text(encoding="utf-8", errors="replace")
        for m in re.finditer(r'"models/heroes/([^/]+)/', content):
            folders.add(m.group(1))
        for m in re.finditer(r'"models/items/[^/]+/([^/]+)/', content):
            pass  # item paths vary
    return folders


def collect_referenced_models() -> set[str]:
    refs = set()
    dirs = [ROOT / "scripts", CONTENT / "panorama"] if CONTENT.exists() else [ROOT / "scripts"]
    for d in dirs:
        if not d.exists():
            continue
        for fp in d.rglob("*"):
            if not fp.is_file() or fp.name == "modelsets.lua":
                continue
            if fp.suffix.lower() not in {".lua", ".txt", ".xml", ".js"}:
                continue
            try:
                content = fp.read_text(encoding="utf-8", errors="replace")
            except OSError:
                continue
            refs.update(re.findall(r'models/[^\s"\']+\.vmdl', content))
            refs.update(re.findall(r'particles/models/[^\s"\']+\.vmdl', content))
    return refs


def extract_hero_model_folder(path: str) -> str | None:
    m = re.search(r"models/heroes/([^/]+)/", path)
    return m.group(1) if m else None


def should_remove(path: str, seen: set[str], active_folders: set[str], referenced: set[str]) -> str | None:
    if not path or path.strip() == "":
        return "empty"
    if path.endswith(".vpcf"):
        return "vpcf_in_models"
    if path.startswith("particles/"):
        return "invalid_particles_path"
    if not path.endswith(".vmdl"):
        return "not_vmdl"
    if path in seen:
        return "duplicate"
    if path in referenced:
        return None
    if path in FORCE_REMOVE_EXACT or any(path.startswith(p) for p in FORCE_REMOVE_PREFIXES):
        return "force_remove"
    if path.startswith("models/heroes/pedestal/"):
        return "pedestal_unreferenced"
    if any(path.startswith(p) for p in KEEP_PREFIXES):
        return None
    folder = extract_hero_model_folder(path)
    if folder:
        if folder not in active_folders:
            return f"hero_not_active:{folder}"
        return None
    if path.startswith("models/items/"):
        return "items_unreferenced"
    if path.startswith("models/heroes/"):
        return None  # hero sub-model, folder check above
    return None


def main():
    activelist = parse_activelist()
    skill_heroes = parse_skill_config_heroes()
    all_heroes = activelist | skill_heroes
    active_folders = build_active_hero_folders(all_heroes)
    referenced = collect_referenced_models()

    raw = MODELS_FILE.read_text(encoding="utf-8", errors="replace")
    lines = raw.splitlines()
    kept = []
    removed = []
    seen = set()

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("--") or stripped in ("return {", "}"):
            kept.append(line)
            continue

        paths = re.findall(r'"([^"]*\.(?:vmdl|vpcf)?)"', line)
        # also catch empty strings
        paths += ["" for _ in re.findall(r'""', line) if "" not in paths]
        if not paths:
            if stripped:
                kept.append(line)
            continue

        kept_paths = []
        for path in paths:
            if path == "" and '""' in line:
                removed.append((path, "empty"))
                continue
            reason = should_remove(path, seen, active_folders, referenced)
            if reason:
                removed.append((path or "(empty)", reason))
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
    out_path = ROOT / "tools/modelsets_cleaned.lua"
    out_path.write_text(out, encoding="utf-8")

    rc = Counter(r for _, r in removed)
    orig = len(re.findall(r'"([^"]+\.vmdl)"', raw))
    print(f"Active hero model folders: {len(active_folders)}")
    print(f"Referenced models in codebase: {len(referenced)}")
    print(f"Original vmdl entries: {orig}")
    print(f"Kept unique: {len(seen)}")
    print(f"Removed: {len(removed)}")
    for reason, count in rc.most_common(25):
        print(f"  {count:4d} {reason}")
    print(f"Wrote {out_path}")


if __name__ == "__main__":
    main()
