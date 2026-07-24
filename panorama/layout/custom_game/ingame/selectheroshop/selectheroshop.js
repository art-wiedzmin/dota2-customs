--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


var selectHeroShopActiveTag = 0;

/** 节日礼包页签开关 */
var CLRB_HOLIDAY_PACK_TAB_ENABLED = true;

function SelectHeroShopFind(id) {
  var root = GetRoot();
  if (!root || !id) {
    return null;
  }
  if (root.id === id) {
    return root;
  }
  if (root.FindChildTraverse) {
    return root.FindChildTraverse(id);
  }
  return null;
}

function SelectHeroShopApplyTabVisibility() {
  for (var i = 1; i <= 5; i++) {
    var tag = SelectHeroShopFind("tag_" + i);
    if (tag) {
      if (i === 2 && !CLRB_HOLIDAY_PACK_TAB_ENABLED) {
        tag.visible = false;
      } else {
        tag.visible = true;
      }
    }
  }
}

function SelectHeroShopGetPlayerData() {
  var playerid = Game.GetLocalPlayerID();
  var info = Game.GetPlayerInfo(playerid);
  if (!info) {
    return;
  }
  var sid = ClrbSteamIdOrEmpty(info.player_steamid);
  var img = SelectHeroShopFind("player_img_p");
  var name = SelectHeroShopFind("player_name_p");
  if (img) {
    img.steamid = sid;
  }
  if (name) {
    name.steamid = sid;
  }
}

function SelectHeroShopBloadPage(tag) {
  var pa = SelectHeroShopFind("container_box");
  if (!pa) {
    return;
  }
  pa.RemoveAndDeleteChildren();
  var panel = $.CreatePanel("Panel", pa, "container_son");
  panel.style.width = "100%";
  panel.style.height = "100%";
  panel.hittest = true;
  var tp = "OpenPage";
  if (tag === 1) {
    SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
    panel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/Shop/Shop.xml",
      false,
      false
    );
  } else if (tag === 2) {
    SendServer("Lua_Shop", { data: { tp: "ClosePage" } });
    panel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/HolidayPack/HolidayPack.xml",
      false,
      false
    );
  } else if (tag === 3) {
    SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
    panel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/BattlePass/BattlePass.xml",
      false,
      false
    );
    SendServer("Lua_Shop", { data: { tp } });
  } else if (tag === 4) {
    SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
    panel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/Person/Person.xml",
      false,
      false
    );
    SendServer("Lua_Shop", { data: { tp } });
  } else if (tag === 5) {
    SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
    panel.BLoadLayout(
      "file://{resources}/layout/custom_game/ingame/OutBag/OutBag.xml",
      false,
      false
    );
    SendServer("Lua_Shop", { data: { tp: "OpenPage" } });
    SendServer("Lua_Shop", { data: { tp: "OutBagSync" } });
  }
}

function SelectHeroShopRefreshActiveTab(num) {
  if (num === 1) {
    var boot = GameUI.CustomUIConfig().ShopBootstrap;
    if (typeof boot === "function") {
      boot();
      return;
    }
  }
  if (num === 2) {
    var hpBoot = GameUI.CustomUIConfig().HolidayPackBootstrap;
    if (typeof hpBoot === "function") {
      hpBoot();
      return;
    }
  }
  SendServer("Lua_Shop", { data: { tp: "OpenPage" } });
}

function SelectHeroShopClickTag(num) {
  if (num === 2 && !CLRB_HOLIDAY_PACK_TAB_ENABLED) {
    return;
  }
  if (selectHeroShopActiveTag === num) {
    SelectHeroShopRefreshActiveTab(num);
    return;
  }
  for (var i = 1; i <= 5; i++) {
    var tag = SelectHeroShopFind("tag_" + i);
    if (!tag) {
      continue;
    }
    if (i === num) {
      tag.AddClass("active");
    } else {
      tag.RemoveClass("active");
    }
  }
  SelectHeroShopBloadPage(num);
  selectHeroShopActiveTag = num;
}

function SelectHeroShopOpenPage() {
  var root = GetRoot();
  if (root && root.style) {
    root.style.opacity = "1";
    root.hittest = true;
  }
  var rootBox = SelectHeroShopFind("root_box");
  if (rootBox) {
    rootBox.hittest = true;
  }
  ClrbSetTextEntryEnabled(SelectHeroShopFind("entry_code"), true);
  SelectHeroShopGetPlayerData();
  SelectHeroShopApplyTabVisibility();
  SelectHeroShopClickTag(1);
}

function SelectHeroShopClosePage() {
  var root = GetRoot();
  if (root && root.style) {
    root.style.opacity = "0";
    root.hittest = false;
  }
  selectHeroShopActiveTag = 0;
  ClrbSetTextEntryEnabled(SelectHeroShopFind("entry_code"), false);
  ClrbDropInputFocusSafe();
  SendServer("Lua_Shop", { data: { tp: "ClosePage" } });
  SendServer("Lua_HolidayPack", { data: { tp: "ClosePage" } });
  var onClosed = GameUI.CustomUIConfig().SelectHeroShop_OnClosed;
  if (typeof onClosed === "function") {
    onClosed();
  }
}

function SelectHeroShopCode() {
  var ent = SelectHeroShopFind("entry_code");
  if (!ent) {
    return;
  }
  var text = (ent.text || "").trim();
  if (!text) {
    return;
  }
  SendServer("Lua_Shop", { data: { tp: "Code", text: text } });
}

function SelectHeroShopShuaxin() {
  SendServer("Lua_Shop", { data: { tp: "Refresh" } });
}

function SelectHeroShopOnServerData(data) {
  if (!data) {
    return;
  }
  GameUI.CustomUIConfig().AllShopData = data;
  var cost = SelectHeroShopFind("cost_text");
  if (cost && data.gold !== undefined && data.gold !== null) {
    cost.text = data.gold;
  }
}

(function () {
  SelectHeroShopGetPlayerData();
  SelectHeroShopApplyTabVisibility();
  ClrbSetTextEntryEnabled(SelectHeroShopFind("entry_code"), false);
  GameUI.CustomUIConfig().SelectHeroShop_OpenPage = SelectHeroShopOpenPage;
  GameUI.CustomUIConfig().SelectHeroShop_ClosePage = SelectHeroShopClosePage;
  SubEvent("UI_Shop", SelectHeroShopOnServerData);
})();