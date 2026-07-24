"""
Rebuild modelsets.lua: keep all existing quoted resource paths, union with
every file under addons/clrb/models/heroes (logical path under models/).

- *.vmdl_c -> models/.../*.vmdl
- Other *._c (e.g. vmat_c, vtex_c) are NOT valid for PrecacheResource("model");
  they are listed only in a comment block at EOF of the Lua table for reference.
"""

import re
from pathlib import Path

ADDON_GAME = Path(r"D:/steam/steamapps/common/dota 2 beta/game/dota_addons/clrb")
MODELS_HEROES = ADDON_GAME / "models/heroes"
MODELSETS = ADDON_GAME / "scripts/vscripts/init/precache/modelsets.lua"

SUFFIX_DROP = "_c"


def logical_path(rel_posix: str) -> tuple[str | None, str]:
    """
    Return (precache_model_string_or_none, comment_line_for_materials).

    Only .vmdl_c maps to model precache. vmat_c/vtex_c get comment-only entries.
    """
    base = f"models/{rel_posix}"
    if rel_posix.endswith(".vmdl_c"):
        return base[: -len(".vmdl_c")] + ".vmdl", ""
    if rel_posix.endswith(".vmat_c"):
        logical = base[: -len(".vmat_c")] + ".vmat"
        return None, f"-- (材质，非 model 预载) {logical}"
    if rel_posix.endswith(".vtex_c"):
        logical = base[: -len(".vtex_c")] + ".vtex"
        return None, f"-- (贴图，非 model 预载) {logical}"
    # unknown extension — document only
    return None, f"-- (未映射预载类型) models/{rel_posix}"


def scan_heroes_models() -> tuple[set[str], list[str]]:
    precache_models: set[str] = set()
    extra_comments: list[str] = []

    if not MODELS_HEROES.is_dir():
        return precache_models, extra_comments

    for f in MODELS_HEROES.rglob("*"):
        if not f.is_file():
            continue
        rel = f.relative_to(ADDON_GAME / "models")
        posix = rel.as_posix()
        pc, cm = logical_path(posix)
        if pc:
            precache_models.add(pc)
        if cm:
            extra_comments.append(cm)

    extra_comments.sort()
    return precache_models, extra_comments


def parse_existing_lua_paths(text: str) -> set[str]:
    return set(re.findall(r'"([^"]+\.vmdl)"', text))


def main() -> None:
    old_text = MODELSETS.read_text(encoding="utf-8")
    existing = parse_existing_lua_paths(old_text)

    hero_models, hero_extra = scan_heroes_models()

    merged = sorted(existing | hero_models)

    lines_body = ['    "' + p + '",' for p in merged]

    extra_block = ""
    if hero_extra:
        extra_block = (
            "\n\n    "
            + "\n\n    ".join(
                ["-- ===== models/heroes 下非 .vmdl_c 的资源（仅占位注释，不参与 PrecacheResource model）===== "]
                + hero_extra
            )
            + "\n"
        )

    out = (
        "return {\n"
        + "\n".join(lines_body)
        + extra_block
        + "}\n"
    )

    MODELSETS.write_text(out, encoding="utf-8")
    print("total unique .vmdl precache paths:", len(merged))
    print("from models/heroes scan (.vmdl_c -> .vmdl):", len(hero_models))
    print("non-vmdl sidecar comment lines:", len(hero_extra))


if __name__ == "__main__":
    main()
