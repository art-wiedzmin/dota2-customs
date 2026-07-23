function InitData() {
  var tp = "init";
  SendServer("Lua_EazyShop", { data: { tp: tp } });
}

function TianShuCancelClick() {
  SendServer("Lua_EazyShop", { data: { tp: "TianShuCancel" } });
}

/** Lua 发 table 可直接 $.Each；发 "a|b|c" 时先转成表再走同一套 $.Each */
function SkillsAsTab(skills) {
  if (!skills) {
    return {};
  }
  if (typeof skills === "string") {
    var out = {};
    var parts = skills.split("|");
    var j = 0;
    for (var i = 0; i < parts.length; i++) {
      if (parts[i]) {
        out[j] = parts[i];
        j++;
      }
    }
    return out;
  }
  return skills;
}

function GetData(data) {
  if (!data) {
    return;
  }
  GetRoot().style.opacity = data.visible ? 1 : 0;
  var pickRoot = GetPanel("tian_shu_pick_root");
  if (pickRoot) {
    pickRoot.style.visibility = data.visible ? "visible" : "collapse";
  }
  var panel = GetPanel("tian_shu_grid");
  if (!panel) {
    return;
  }
  panel.RemoveAndDeleteChildren();
  if (!data.visible) {
    return;
  }
  $.Each(SkillsAsTab(data.skills), function (v, k) {
    var sonpanel = NewPanel(panel, v, "Panel");
    sonpanel.BLoadLayoutSnippet("book");
    var img = sonpanel.FindChildTraverse("item_image");
    if (img && img.SetImage) {
      img.SetImage(
        "raw://resource/flash3/images/items/item_ability_scrolls/" + v + ".png"
      );
    }
    var nameLbl = sonpanel.FindChildTraverse("tian_name");
    if (nameLbl) {
      nameLbl.text = Local("DOTA_Tooltip_ability_" + v);
    }
    (function (name) {
      sonpanel.SetPanelEvent("onactivate", function () {
        SendServer("Lua_EazyShop", {
          data: { tp: "TianShuPick", text: name },
        });
      });
    })(v);
    (function (p, nm) {
      WhenOver(p, function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", p, nm);
      });
      WhenOut(p, function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", p);
      });
    })(sonpanel, v);
  });
}

(function () {
  InitData();
  SubEvent("UI_TianShuPick", GetData);
})();
