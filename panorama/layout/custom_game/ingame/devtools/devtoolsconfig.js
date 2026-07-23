/**
 * 客户端扩展配置（可选）
 * - CLRB_DEVTOOLS_EXTRA：追加按钮；cmd 须在服务端 ingame/DevTools/Custom.lua 中 RegisterTool
 * - CLRB_DEVTOOLS_UI.start_collapsed：true 时初始只显示左侧「工具」标签
 */
var CLRB_DEVTOOLS_EXTRA = [
  // 客户端追加按钮（cmd 须在服务端 RegisterTool）
];

var CLRB_DEVTOOLS_UI = {
  /** true = 初始只显示左侧「工具」标签，点击后滑出面板 */
  start_collapsed: true,
};
