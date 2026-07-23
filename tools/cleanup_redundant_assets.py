--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


#!/usr/bin/env python3
"""Remove local copies of Valve built-in assets; keep custom CLRB resources."""
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOTA_BETA = ROOT.parent.parent.parent  # .../dota 2 beta
CONTENT = DOTA_BETA / "content/dota_addons/clrb"
ADDON_ROOTS = [ROOT, CONTENT]

# Entire trees that are Valve copies (relative to particles/)
VALVE_PARTICLE_DIRS = {
    "units",
    "econ",
    "status_fx",
    "msg_fx",
    "item_fx",
    "item2_fx",
    "neutral_fx",
    "models",  # particles/models/...
    "basic_ambient",
    "basic_explosion",
    "basic_projectile",
    "basic_rope",
    "basic_trail",
    "generic_gameplay",
    "generic_hero_status",
    "world_creature_fx",
    "world_environmental_fx",
}

# Custom particle dirs — never delete
CUSTOM_PARTICLE_DIRS = {
    "clrb",
    "scrolls",
    "items",  # except items/death_aura
    "myfx",
    "ziyuan",
    "texiao",
    "jump",
    "ring",
    "spin",
    "mingshi",
    "ui",
    "rain_fx",
    "death_ring",
}

# Valve-only subpath under custom parent
VALVE_PARTICLE_SUBDIRS = [
    ("items", "death_aura"),
]

# Root particle files in precache that are Valve (delete local if present)
VALVE_PRECACH_ROOT_PREFIXES = (
    "particles/units/",
    "particles/econ/",
    "particles/status_fx/",
    "particles/generic_",
    "particles/msg_fx/",
    "particles/items_fx/",
    "particles/items2_fx/",
    "particles/neutral_fx/",
    "particles/models/",
    "particles/dev/",
    "particles/test_",
    "particles/bp_",
    "particles/items/death_aura/",
    "particles/events/",
)

CUSTOM_PRECACH_PREFIXES = (
    "particles/clrb/",
    "particles/scrolls/",
    "particles/death_ring",
    "particles/item_rank",
    "particles/myfx/",
    "particles/ziyuan/",
    "particles/wings_",
    "particles/zuus_g",
    "particles/flame.",
    "particles/num.",
    "particles/respawn_circle",
    "particles/scrolls/",
    "terrain/",
)

VALVE_MODEL_DIRS = {"heroes", "creeps", "courier", "items", "props_gameplay", "props_structures", "econ"}


def collect_precache_paths() -> set[str]:
    paths = set()
    for name, ext in [
        ("particlessets.lua", "vpcf"),
        ("modelsets.lua", "vmdl"),
        ("soundsets.lua", "vsndevts"),
    ]:
        fp = ROOT / f"scripts/vscripts/init/precache/{name}"
        if not fp.exists():
            continue
        text = fp.read_text(encoding="utf-8", errors="replace")
        for m in re.finditer(rf'"([^"]+\.{ext})"', text):
            paths.add(m.group(1).replace("\\", "/"))
    return paths


def is_valve_precache_path(p: str) -> bool:
    if any(p.startswith(x) for x in CUSTOM_PRECACH_PREFIXES):
        return False
    if p.startswith("particles/items/") and not p.startswith("particles/items/death_aura/"):
        return False
    if any(p.startswith(x) for x in VALVE_PRECACH_ROOT_PREFIXES):
        return True
    if p.startswith("models/heroes/") or p.startswith("models/items/"):
        return True
    if p.startswith("models/creeps/") or p.startswith("models/courier/"):
        return True
    if p.startswith("models/props_"):
        return True
    return False


def local_candidates(base: Path, engine_path: str) -> list[Path]:
    """Map engine path to possible local files."""
    rel = engine_path
    if rel.startswith("particles/") or rel.startswith("models/") or rel.startswith("terrain/"):
        pass
    else:
        return []
    out = []
    stem = rel
    for suffix in ("", "_c"):
        if stem.endswith(".vpcf"):
            out.append(base / (stem + ("_c" if suffix == "_c" else "")))
        elif stem.endswith(".vmdl"):
            out.append(base / (stem.replace(".vmdl", ".vmdl" + suffix if suffix else ".vmdl")))
        else:
            out.append(base / stem)
    # source formats in content
    p = base / stem
    out.append(p)
    if stem.endswith(".vmdl"):
        out.append(p.with_suffix(".fbx"))
        out.append(p.parent / (p.stem + ".fbx"))
    return [x for x in out if x.is_file()]


def plan_removals(precache: set[str]) -> tuple[list[Path], list[Path]]:
    """Returns (files_to_delete, dirs_to_delete)."""
    files: set[Path] = set()
    dirs: set[Path] = set()

    for addon in ADDON_ROOTS:
        particles = addon / "particles"
        models = addon / "models"

        if particles.exists():
            for name in VALVE_PARTICLE_DIRS:
                d = particles / name
                if d.exists():
                    dirs.add(d)
            for parent, child in VALVE_PARTICLE_SUBDIRS:
                d = particles / parent / child
                if d.exists():
                    dirs.add(d)

        if models.exists():
            for name in VALVE_MODEL_DIRS:
                d = models / name
                if d.exists():
                    dirs.add(d)
            pg = models / "props_gameplay"
            if pg.exists():
                dirs.add(pg)
            ps = models / "props_structures"
            if ps.exists():
                dirs.add(ps)

        for p in precache:
            if not is_valve_precache_path(p):
                continue
            for fp in local_candidates(addon, p):
                if fp.is_file():
                    files.add(fp.resolve())

        # Root-level compiled valve particles (e.g. test_arena_ring.vpcf_c)
        if particles.exists():
            for fp in particles.glob("*"):
                if not fp.is_file():
                    continue
                rel = fp.relative_to(addon).as_posix()
                if rel.endswith("_c"):
                    rel = rel[:-2]
                if is_valve_precache_path(rel):
                    files.add(fp.resolve())

    # Remove files that live inside dirs slated for deletion
    final_files = []
    for fp in files:
        if not any(str(fp).startswith(str(d.resolve())) for d in dirs):
            final_files.append(fp)

    # Sort dirs deepest first
    dir_list = sorted(dirs, key=lambda p: len(p.parts), reverse=True)
    return sorted(final_files), dir_list


def main():
    apply = "--apply" in sys.argv
    precache = collect_precache_paths()
    valve_precache = [p for p in precache if is_valve_precache_path(p)]
    files, dirs = plan_removals(precache)

    def count_files_in_dirs(dir_paths):
        n = 0
        for d in dir_paths:
            if d.exists():
                n += sum(1 for _ in d.rglob("*") if _.is_file())
        return n

    dir_file_count = count_files_in_dirs(dirs)
    print(f"Precache paths: {len(precache)} (valve: {len(valve_precache)})")
    print(f"Directories to remove: {len(dirs)} (~{dir_file_count} files inside)")
    print(f"Extra root files to remove: {len(files)}")

    print("\n--- Directories ---")
    for d in dirs[:30]:
        n = sum(1 for _ in d.rglob("*") if _.is_file()) if d.exists() else 0
        print(f"  [{n:5d} files] {d}")
    if len(dirs) > 30:
        print(f"  ... and {len(dirs) - 30} more dirs")

    if files[:20]:
        print("\n--- Sample files ---")
        for fp in files[:20]:
            print(f"  {fp}")

    if not apply:
        print("\nDry run. Pass --apply to delete.")
        return

    deleted_files = 0
    for fp in files:
        try:
            fp.unlink()
            deleted_files += 1
        except OSError as e:
            print(f"FAIL file {fp}: {e}")

    deleted_dirs = 0
    for d in dirs:
        if not d.exists():
            continue
        try:
            shutil.rmtree(d)
            deleted_dirs += 1
        except OSError as e:
            print(f"FAIL dir {d}: {e}")

    print(f"\nDone: removed {deleted_dirs} dirs (~{dir_file_count} files), {deleted_files} loose files")


if __name__ == "__main__":
    main()