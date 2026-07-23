function InitData() {
    var tp = "init";
    SendServer("Lua_EazyShop", { data: { tp: tp } });
}
var BookState = false;

var FREE_BOOK_COLS_PER_ROW = 7;

function SanitizeFbPanelId(s) {
    return ("" + s).replace(/[^a-zA-Z0-9_-]/g, "_");
}

function GetData(data) {
    if (!data) {
        return;
    }
    GetRoot().style.opacity = data.visible;
    var panel = GetPanel("free_book_grid");
    if (data.skills && data.visible == 1 && BookState == false) {
        var list = [];
        $.Each(data.skills, function (v) {
            list.push(v);
        });
        var n = list.length;
        var rowCount = Math.ceil(n / FREE_BOOK_COLS_PER_ROW);
        var r;
        var c;
        for (r = 0; r < rowCount; r++) {
            var rowPanel = NewPanel(panel, "free_book_row_wrap_" + r, "Panel");
            rowPanel.AddClass("free_book_grid_row");
            var slots = [];
            for (c = 0; c < FREE_BOOK_COLS_PER_ROW; c++) {
                var slot = NewPanel(rowPanel, "free_book_slot_" + r + "_" + c, "Panel");
                slot.AddClass("free_book_slot");
                slots[c] = slot;
            }
            for (c = 0; c < FREE_BOOK_COLS_PER_ROW; c++) {
                var idx = r * FREE_BOOK_COLS_PER_ROW + c;
                if (idx >= n) {
                    continue;
                }
                var v = list[idx];
                var cid = SanitizeFbPanelId(v);
                var sonpanel = NewPanel(slots[c], "fb_skill_" + r + "_" + c + "_" + cid, "Panel");
                sonpanel.BLoadLayoutSnippet("book");
                sonpanel.FindChildTraverse("item_image").SetImage(
                    "raw://resource/flash3/images/items/ability_scrolls/" + v + ".png"
                );
                var lbl = sonpanel.FindChildTraverse("item_name_label");
                if (lbl) {
                    var locKey = "#DOTA_Tooltip_ability_" + v;
                    var disp = $.Localize(locKey);
                    lbl.text = disp && disp !== locKey ? disp : v;
                }
                sonpanel.ItemName = v;
                BookFunc(sonpanel);
                TipBook(sonpanel, v);
            }
        }
        BookState = true;
    }
}

function BookFunc(pa) {
    WhenActive(pa, function () {
        var tp = "TianShuPick";
        var text = pa.ItemName;
        SendServer("Lua_EazyShop", { data: { tp, text } });
    });
}

function TipBook(panel, name) {
    WhenOver(panel, function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", panel, name);
    });
    WhenOut(panel, function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", panel);
    });
}

(function () {
    InitData();
    SubEvent("UI_FreeBook", GetData);
})();
