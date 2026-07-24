--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 5411fca · 2026-07-24 06:14:29 UTC
  ~ auto-generated — do not edit
]]


// 暂时关闭邀请码；恢复时改为 true，并取消 Menu.xml 中对应入口注释
var INVITE_ENABLED = false;

function InitData() {
  if (!INVITE_ENABLED) return;
  SendServer("Lua_Invite", { data: { tp: "init" } });
}

function OpenPage() {
  SendServer("Lua_Invite", { data: { tp: "OpenPage" } });
}

function ClosePage() {
  SendServer("Lua_Invite", { data: { tp: "ClosePage" } });
}

function WriteInvite() {
  var text = GetPanel("entry_code").text;
  if (!text || text === "") {
    return;
  }
  SendServer("Lua_Invite", { data: { tp: "WriteInvite", text: text } });
}

function GetInvite(panel,num) {
  WhenActive(panel,function(){
    if(panel.getstate=="undisabled"){
      SendServer("Lua_Invite", { data: { tp: "GetInvite", text: num } });
    }

  })
}

// 更新整页：显隐、状态、邀请人数、奖励列表
function UpdateUI(data) {
  if (!data) return;
  var root = GetRoot();
  var container = $("#Invite");
  if (data.page !== undefined) {
    if (root) {
      root.style.opacity = data.page ? "1" : "0";
    }
    if (container) {
      container.visible = data.page;
      container.hittest = data.page;
    }
  }
  if (data.vid !== undefined) {
    GetPanel("my_text").text = data.vid;
  }
  var statusText = GetPanel("invite_status_text");
  var inputWrap = GetPanel("invite_input_wrap");
  if (statusText && data.invited !== undefined) {
    if (data.invited === 1) {
      // statusText.text = "已填写邀请码";
      if (inputWrap) inputWrap.visible = false;
      GetPanel("bd_btn").SetHasClass("over", true);
      GetPanel("entry_code").visible=false;
      GetPanel("over_input_text").visible=true;
    } else {
      // statusText.text = "请输入邀请码";
      if (inputWrap) inputWrap.visible = true;
      GetPanel("bd_btn").SetHasClass("over", false);
      GetPanel("entry_code").visible=true;
      GetPanel("over_input_text").visible=false;
    }
  }
 
  if (data.fans !== undefined) {
    var invitedCountText = GetPanel("invite_invited_count_text");
    if (invitedCountText) {
      invitedCountText.text = "当前已成功邀请：" + data.fans + " 人";
    }
  }

  if (data.list) {
    BuildRewardList(data.list, data.fans);
  }
}

// 下方邀请奖励列表：每档用 XML 内联 onactivate="GetInvite(N)" 的 snippet，保证点击能触发
function BuildRewardList(list, fans) {
  var listpanel = GetPanel("invite_reward_list");
  if (!listpanel) return;
  listpanel.RemoveAndDeleteChildren();
  for (var i = 1; i <= 10; i++) {
    var panel = NewPanel(listpanel, "invite_row_" + i, "Panel");
    panel.BLoadLayoutSnippet("reward_row_snippet");
    panel.FindChildTraverse("text_1").text="邀请第"+i+"位好友";
    panel.FindChildTraverse("text_2").text="每邀请一位好友奖励1000金豆";
    var btn = panel.FindChildTraverse("invite_reward_btn");
    // 领取状态
    if(list["award" + i] === 1) {
      panel.SetHasClass("over", true);
      btn.getstate="disabled";
    } else if (fans !== undefined && fans < i) {
      panel.SetHasClass("over", false);
      btn.getstate="disabled";
    } else {
      panel.SetHasClass("over", false);
      btn.getstate="undisabled";
    }
    GetInvite(btn,i);
  }
}

function GetData(data) {
  UpdateUI(data);
  // print(data)
}

(function () {
  if (!INVITE_ENABLED) return;
  InitData();
  SubEvent("UI_Invite", GetData);
})();