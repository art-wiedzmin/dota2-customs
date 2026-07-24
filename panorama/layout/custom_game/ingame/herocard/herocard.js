var heroCardLayoutContext = null;
var heroCardAutoCloseSeq = 0;
var heroCardHovering = false;
var heroCardIsOpen = false;
var HERO_CARD_AUTO_CLOSE_SECONDS = 3;
var HERO_CARD_SLIDE_X_HIDDEN = -380;
var HERO_CARD_ANIM_SHOW_SEC = "0.32s";
var HERO_CARD_ANIM_HIDE_SEC = "0.28s";

function HeroCardShowAnimated(root) {
    if (!root || !root.IsValid()) {
        return;
    }
    root.style.transitionDuration = "0s";
    root.style.transitionProperty = "none";
    root.style.transform = "translateX(" + HERO_CARD_SLIDE_X_HIDDEN + "px)";
    root.style.opacity = "0";
    $.Schedule(0.02, function () {
        if (!root || !root.IsValid()) {
            return;
        }
        root.style.transitionDuration = HERO_CARD_ANIM_SHOW_SEC;
        root.style.transitionProperty = "transform, opacity";
        root.style.transitionTimingFunction = "ease-out";
        root.style.transform = "translateX(0px)";
        root.style.opacity = "1";
    });
}

function HeroCardHideAnimated(root) {
    if (!root || !root.IsValid()) {
        return;
    }
    root.style.transitionDuration = HERO_CARD_ANIM_HIDE_SEC;
    root.style.transitionProperty = "transform, opacity";
    root.style.transitionTimingFunction = "ease-in";
    root.style.transform = "translateX(" + HERO_CARD_SLIDE_X_HIDDEN + "px)";
    root.style.opacity = "0";
}

function HeroCardGetRootPanel() {
    var p = FindHeroCardPanel("hero_card_root");
    if (p && p.IsValid()) {
        return p;
    }
    return GetRoot();
}

function HeroCardOnMouseLeave() {
    if (!heroCardIsOpen) {
        return;
    }
    var root = HeroCardGetRootPanel();
    if (root && root.IsValid()) {
        HeroCardHideAnimated(root);
    }
    heroCardIsOpen = false;
    ClosePage();
}

function FindHeroCardPanel(id) {
    var ctx = heroCardLayoutContext;
    if (ctx && ctx.IsValid()) {
        var t = ctx.FindChildTraverse(id);
        if (t && t.IsValid()) {
            return t;
        }
    }
    var g = GetPanel(id);
    if (g && g.IsValid()) {
        return g;
    }
    return null;
}

function InitData() {
    var tp = "init";
    SendServer("Lua_HeroCard", { data: { tp } });
}

function OpenPage() {
    var tp = "OpenPage";
    SendServer("Lua_HeroCard", { data: { tp } });
}

function ClosePage() {
    heroCardAutoCloseSeq++;
    var tp = "ClosePage";
    SendServer("Lua_HeroCard", { data: { tp } });
}

function ScheduleHeroCardAutoClose() {
    heroCardAutoCloseSeq++;
    var mySeq = heroCardAutoCloseSeq;
    $.Schedule(HERO_CARD_AUTO_CLOSE_SECONDS, function () {
        if (mySeq !== heroCardAutoCloseSeq) {
            return;
        }
        if (heroCardHovering) {
            return;
        }
        ClosePage();
    });
}

function GetData(data) {
    if (!data) {
        return;
    }
    if (data.j && typeof data.j === "string") {
        try {
            data = { page: true, data: JSON.parse(data.j) };
        } catch (e) {
            return;
        }
    }
    var isPageOpen = data.page === true || data.page === 1 || data.page === "1";
    var root = HeroCardGetRootPanel();
    var d = data.data;

    if (!d || typeof d !== "object") {
        if (root && root.IsValid() && !isPageOpen) {
            heroCardIsOpen = false;
            HeroCardHideAnimated(root);
        }
        return;
    }
    var hasField = false;
    for (var k in d) {
        if (Object.prototype.hasOwnProperty.call(d, k)) {
            hasField = true;
            break;
        }
    }
    if (!hasField) {
        if (root && root.IsValid() && !isPageOpen) {
            heroCardIsOpen = false;
            HeroCardHideAnimated(root);
        }
        return;
    }

    SetHeroImage(d.hero_name);
    SetHeroHeader(d);
    SetHeroHpMana(d);
    SetHeroStats(d);
    SetHeroItemSlots(d.item_list);

    if (root && root.IsValid()) {
        if (isPageOpen) {
            heroCardIsOpen = true;
            HeroCardShowAnimated(root);
            ScheduleHeroCardAutoClose();
        } else {
            heroCardIsOpen = false;
            HeroCardHideAnimated(root);
        }
    }
}


function FmtAttrNum(n) {
    var x = Number(n);
    if (isNaN(x)) {
        x = 0;
    }
    return String(Math.floor(x));
}

function SetHeroLine(panelId, prefix, valueStr) {
    var p = FindHeroCardPanel(panelId);
    if (p && p.IsValid()) {
        p.text = prefix + " " + valueStr;
    }
}

function SetHeroHpMana(d) {
    var h = d.hp != null ? d.hp : 0;
    var hm = d.hp_max != null ? d.hp_max : 0;
    var m = d.mana != null ? d.mana : 0;
    var mm = d.mana_max != null ? d.mana_max : 0;
    SetHeroLine("stat_hp", "生命", FmtAttrNum(h) + "/" + FmtAttrNum(hm));
    SetHeroLine("stat_mana", "魔法", FmtAttrNum(m) + "/" + FmtAttrNum(mm));
}

function SetHeroStats(d) {
    SetHeroLine("stat_atk", "攻击", FmtAttrNum(d.atk != null ? d.atk : 0));
    SetHeroLine("stat_armor", "护甲", FmtAttrNum(d.armor != null ? d.armor : 0));
    SetHeroLine("stat_str", "力量", FmtAttrNum(d.str != null ? d.str : 0));
    SetHeroLine("stat_agi", "敏捷", FmtAttrNum(d.agi != null ? d.agi : 0));
    SetHeroLine("stat_int", "智力", FmtAttrNum(d.int != null ? d.int : 0));
}

function SetHeroImage(hero_name) {
    if (!hero_name) {
        hero_name = "";
    }
    var heroImage = FindHeroCardPanel("portrait");
    if (heroImage && heroImage.IsValid()) {
        heroImage.heroname = hero_name;
    }
}

function SetHeroHeader(d) {
    var hero_name = d.hero_name || "";
    var nameLabel = FindHeroCardPanel("name_label");
    if (nameLabel && nameLabel.IsValid()) {
        var loc = $.Localize("#" + hero_name);
        nameLabel.text = loc === "#" + hero_name ? hero_name : loc;
    }
    var subLabel = FindHeroCardPanel("sub_label");
    if (subLabel && subLabel.IsValid()) {
        var sub = "等级 " + (d.level != null ? d.level : 1);
        if (d.bot === 1 || d.bot === true) {
            sub += " · 电脑";
        }
        subLabel.text = sub;
    }
}

function SetHeroItemSlots(itemList) {
    for (var i = 1; i <= 6; i++) {
        var p = FindHeroCardPanel("item_slot_" + i);
        if (!p || !p.IsValid()) {
            continue;
        }
        var nm = "";
        if (itemList && itemList["slot_" + i] != null && itemList["slot_" + i] !== "") {
            nm = String(itemList["slot_" + i]).trim();
        }
        p.itemname = nm;
    }
}

(function () {
    heroCardLayoutContext = $.GetContextPanel();
    InitData();
    SubEvent("UI_HeroCard", GetData);
    $.Schedule(0, function () {
        var btn = FindHeroCardPanel("btn_close");
        if (btn && btn.IsValid()) {
            btn.SetPanelEvent("onactivate", ClosePage);
        }
        var hoverTarget = FindHeroCardPanel("card_inner");
        if (hoverTarget && hoverTarget.SetPanelEvent) {
            hoverTarget.SetPanelEvent("onmouseover", function () {
                heroCardHovering = true;
            });
            hoverTarget.SetPanelEvent("onmouseout", function () {
                heroCardHovering = false;
                HeroCardOnMouseLeave();
            });
        }
    });
})();
