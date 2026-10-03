在操作 OBS 之前，请先研究能否通过 MCP 直接控制我本机的 OBS Studio，尽量避免大量使用 Computer Use。

OBS 28+ 已经内置 obs-websocket。请检查我的 OBS 是否支持并开启 WebSocket Server。

然后搜索当前可靠、活跃、开源的 OBS MCP Server，优先选择能够完整控制 Scene、Source、Scene Item、Audio、Filter、Transition、Recording、Hotkey 和 Scene Collection 的实现。

请检查项目来源、近期维护情况、安装方式和代码安全性后再安装口碑好使用量多的，不要执行来源可疑的脚本。

如果合适，把 OBS MCP 配置到 Codex 中，并测试：

- 能否读取当前 OBS 版本
- 能否读取当前 Scene Collection
- 能否列出 Scenes 和 Sources
- 能否创建测试 Scene
- 能否修改 Source
- 能否切换 Scene

MCP 能完成的操作优先使用 MCP；只有 MCP 无法完成或者需要视觉判断时才使用 Computer Use。

配置成功以后，再继续帮我创建我的 OBS 口播与软件演示模板。




