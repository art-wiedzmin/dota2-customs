--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


//初始化加载加载
function InitData() {
    var tp = "init";
    SendServer("Lua_Book", { data: { tp } });
}

//打开页面
function OpenPage() {
    var tp = "OpenPage";
    SendServer("Lua_Book", { data: { tp } });
}

//关闭页面
function ClosePage() {
    var tp = "ClosePage";
    SendServer("Lua_Book", { data: { tp } });
}

function SelectPage(text) {
    var tp = "SelectPage";
    SendServer("Lua_Book", { data: { tp, text } });
}

function opennav(num) {
    for (var i = 1; i <= 3; i++) {
        var navpanel = GetPanel("nav_item_" + i);
        var panel = GetPanel("body_" + i);
        if (i == num) {
            panel.visible = true;
            navpanel.SetHasClass("active", true);
        } else {
            panel.visible = false;
            navpanel.SetHasClass("active", false);
        }
    }
}


//获取数据
function GetData(data) {
    if (!data) {
        return;
    }
    //  print(data);
    GetRoot().style.opacity = data.page;
    var list1 = data.list1;
    var list2 = data.list2;
    var list3 = data.list3;
    var listPublic = data.list_public;
    HeroBook(list1);
    PublicAbilityBook(listPublic);
    AbilityBook(list2);
    FightAbility(list3);
}

// 英雄图鉴
function HeroBook(data) {
    var list = Length(data);
    if (list <= 0) {
        return;
    }
    for (var i = 1; i <= list; i++) {
        var tplist = Length(data["tp" + i]);
        var panel = GetPanel("type_list_" + i);
        panel.RemoveAndDeleteChildren();
        for (var j = 1; j <= tplist; j++) {
            var sonpanel = NewPanel(panel, "hero_li_" + j, "Panel");
            sonpanel.BLoadLayoutSnippet("hero_snippet");
            sonpanel.FindChildTraverse("hero_image").heroname = data["tp" + i]["slot_" + j].name;
            if (data["tp" + i]["slot_" + j].state == 1) {
                sonpanel.FindChildTraverse("no_image").visible = false;
            } else {
                sonpanel.FindChildTraverse("no_image").visible = true;
            }
            sonpanel.typeindex = data["tp" + i]["slot_" + j].index;
            ShowHeroHover(sonpanel, data["tp" + i]["slot_" + j].name)
            // OfficialPreview(sonpanel,data["tp"+i]["slot_"+j].name);

            if (i <= 3) {
                if (j % 5 == 0) {
                    sonpanel.style.marginRight = "0";
                } else {
                    sonpanel.style.marginRight = "10px";
                }

            } else {

            }
        }
    }
}

// 设置英雄悬浮显示
function ShowHeroHover(panel, name) {
    WhenOver(panel, function () {
        var pa = GetPanel("hero_panel")
        pa.style.opacity = "1";
        pa.style.marginLeft = "0px";
        pa.style.marginTop = "0px";
        var screenPos = GetScreenOffset(panel);
        var x = screenPos.x / pa.actualuiscale_x - 50;
        var y = screenPos.y / pa.actualuiscale_y - 50;
        pa.style.marginLeft = x + "px";
        pa.style.marginTop = y + "px";
        pa.style.preTransformScale2d = "1";
        pa.FindChildTraverse("hero_movie").heroname = name;
        pa.FindChildTraverse("text_label_hover").text = Local(name);

    })
    WhenOut(panel, function () {
        var pa = GetPanel("hero_panel");
        pa.style.opacity = "0";
        pa.style.preTransformScale2d = "0.1";
    })
}

function LearnAbility(pa, name) {
    WhenActive(pa, function () {
        // print(pa)
        var tp = "LearnAbility";
        var text = name;
        SendServer("Lua_Book", { data: { tp, text } });
    });
}

// 获取当前panel离窗口的偏移量
function GetScreenOffset(panel) {
    var x = 0;
    var y = 0;
    var current = panel;

    // 1. 向上遍历父级
    while (current) {
        // 2. 累加每一层的偏移量
        x += current.actualxoffset;
        y += current.actualyoffset;

        // 3. 移动到父级
        current = current.GetParent();

        // 4. 安全退出条件
        // 如果到了最顶层，或者到达了 HUD/Menu 根节点，停止遍历
        if (!current || current.id === "Hud" || current.id === "Root") {
            break;
        }
    }

    return { x: x, y: y };
}

var colortab = {
    0: "#FF4482",
    1: "#FFEA00",
    2: "#F71AFF",
    3: "#008AFF",
    4: "#cccccc",
}
var EMPTY_SKILL_IMG = "file://{images}/custom_game/skill_null.png";

function SetAbilitySlotPanel(slotsonpanel, slotData) {
    var slotState = slotData.state;
    var noSelect = slotsonpanel.FindChildTraverse("no_select");
    noSelect.visible = false;
    if (slotState == 1 || slotState === true) {
        slotsonpanel.FindChildTraverse("ability_image").SetImage("raw://resource/flash3/images/skill/" + slotData.img + ".png");
        ShowTips(slotsonpanel, slotData.name);
        LearnAbility(slotsonpanel, slotData.name);
    } else {
        slotsonpanel.FindChildTraverse("ability_image").SetImage(EMPTY_SKILL_IMG);
    }
    if (slotData.rank < 0) {
        slotsonpanel.style.border = "0";
    } else {
        slotsonpanel.style.border = "2px solid " + colortab[slotData.rank];
    }
}
// 公共技能（置顶）
function PublicAbilityBook(data) {
    var box = GetPanel("public_skill_box");
    var label = GetPanel("public_skill_label");
    var panel = GetPanel("public_ability_list");
    panel.RemoveAndDeleteChildren();
    if (!data || !data.list) {
        box.visible = false;
        return;
    }
    var slotlist = Length(data.list);
    if (slotlist <= 0) {
        box.visible = false;
        return;
    }
    box.visible = true;
    label.text = data.display_name ? Local(data.display_name) : "";
    for (var j = 1; j <= slotlist; j++) {
        var slotsonpanel = NewPanel(panel, "public_slot_li_" + j, "Panel");
        slotsonpanel.BLoadLayoutSnippet("ability_slot_snippet");
        SetAbilitySlotPanel(slotsonpanel, data.list["slot_" + j]);
    }
}

// 技能图鉴
function AbilityBook(data) {

    var list = Length(data);
    if (list <= 0) {
        return;
    }
    var panel = GetPanel("ability_list_box");
    panel.RemoveAndDeleteChildren();
    for (var i = 1; i <= list; i++) {
        var sonpanel = NewPanel(panel, "ability_li_" + i, "Panel");
        sonpanel.BLoadLayoutSnippet("ability_snippet");
        sonpanel.FindChildTraverse("hero_image").heroname = data["num" + i].name;
        sonpanel.FindChildTraverse("hero_name").text = Local(data["num" + i].name);

        var slotpanel = sonpanel.FindChildTraverse("ability_list");
        slotpanel.RemoveAndDeleteChildren();
        var slotlist = Length(data["num" + i].list);
        if (slotlist <= 0) {
            continue;
        }

        for (var j = 1; j <= slotlist; j++) {
            var slotsonpanel = NewPanel(slotpanel, "slot_li_" + j, "Panel");
            slotsonpanel.BLoadLayoutSnippet("ability_slot_snippet");
            SetAbilitySlotPanel(slotsonpanel, data["num" + i].list["slot_" + j]);
        }
    }
}

function ShowTips(panel, name) {
    WhenOver(panel, function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", panel, name);
    });
    WhenOut(panel, function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", panel);
    });
}


// 战斗技能
function FightAbility(data) {
    var list = Length(data);
    if (list <= 0) {
        return;
    }
    for (var i = 1; i <= list; i++) {
        var panel = GetPanel("fight_" + i);
        panel.RemoveAndDeleteChildren();
        var slotlist = Length(data["tp" + i]);
        if (slotlist <= 0) {
            return;
        }

        $.Each(data["tp" + i], function (v, k) {
            var sonpanel = NewPanel(panel, "fight_li_" + k, "Panel");
            sonpanel.BLoadLayoutSnippet("fight_snippet");
            sonpanel.FindChildTraverse("fight_image").SetImage("raw://resource/flash3/images/ability/" + v.name + ".png");
            sonpanel.FindChildTraverse("fight_name").text = Local("DOTA_Tooltip_ability_" + v.name);
            sonpanel.FindChildTraverse("fight_text").text = Local(v.text);
        })

    }
}


(function () {
    InitData();
    SubEvent("UI_Book", GetData);

})();