--[[
  ~ dumper · customs · dota2
  ~ credits: rou (a.k.a internetenemy), qfun(a.k.a qfun_g9s)
  ~ special for t.me/wildguild

  ~ build 7258af9 · 2026-07-23 21:55:46 UTC
  ~ auto-generated — do not edit
]]


# Task 面板内排行榜（UI_Rank）接口说明

排行榜数据由后端通过 **UI_Rank** 事件下发，在 **Task** 面板中展示。支持 5v5 / 1v1 两种模式切换。

## 1. 订阅事件

在 Task 的 JS 中订阅：

```js
GameEvents.Subscribe("UI_Rank", function(payload) {
  // payload 见下文
});
```

## 2. payload 结构（后端 SendData 下发）

| 字段 | 类型 | 说明 |
|------|------|------|
| `page` | boolean | 排行榜页是否打开 |
| `view_mode` | string | 当前视图模式：`"5v5"` 或 `"1v1"` |
| `list_5v5` | object | 5v5 排行榜列表，键为 `rank1`～`rank100` |
| `list_1v1` | object | 1v1 排行榜列表，键为 `rank1`～`rank100` |
| `list` | object | 当前视图对应的列表（= list_5v5 或 list_1v1） |
| `data` | object | 当前玩家信息：`pid`, `sid`, `rank`, `point`(5v5), `rank2`, `point2`(1v1) |

每条排行项（如 `list.rank1`）结构：

- `id`：玩家 pid（Steam ID 32）
- `sid`：Steam ID 64
- `rank`：名次（1～100）
- `point`：分数

## 3. 前端实现 5v5 / 1v1 切换

**方式 A：仅前端切换（推荐）**  
- 收到 `UI_Rank` 后保存 `list_5v5`、`list_1v1`、`data`。  
- 页面上提供两个 Tab/按钮：「5v5」「1v1」。  
- 点击后本地切换：当前视图用 `list_5v5` 或 `list_1v1` 渲染，当前玩家排名/分数用 `data.rank`/`data.point`（5v5）或 `data.rank2`/`data.point2`（1v1）。  
- 无需再发请求。

**方式 B：通知后端再收一次数据**  
- 切换时向服务器发事件，让后端更新 `view_mode` 并重发一次 `UI_Rank`（此时 `list` 会是对应模式）。  
- 发送示例（需带 PlayerID，具体字段名以你项目为准）：

```js
GameEvents.SendCustomGameEventToServer("Lua_Rank", {
  tp: "SwitchMode",
  mode: "5v5"   // 或 "1v1"
});
```

后端已支持 `tp == "SwitchMode"` 且 `mode == "5v5"|"1v1"`，会更新 `view_mode` 并再次 `SendData`。

## 4. 建议

- 使用 **方式 A**：用 `payload.list_5v5` / `payload.list_1v1` 在 Task 内做 5v5/1v1 视图切换，用 `payload.list` 或按当前 Tab 选用的列表渲染表格即可。  
- 若希望「下次打开面板时记住上次选的模式」，可再采用方式 B，在切换时发一次 `Lua_Rank`（SwitchMode）。