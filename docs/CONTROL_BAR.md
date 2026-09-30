# 屏幕悬浮控制条

运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\start-control-bar.ps1
```

控制条提供六个可点击动作：真人、录屏 + 真人、电脑全屏、平滑缩放、鼠标跟随切换和录制。拖动按钮之间的深色空白可以移动位置，点击右侧 `×` 可关闭。

窗口启用了 Windows `WDA_EXCLUDEFROMCAPTURE`，因此不会进入 OBS 的窗口捕获或 Windows 图形屏幕捕获。它仍会真实显示在操作者屏幕上；某些较老的第三方截图驱动如果不遵守 Windows 捕获排除标记，使用前需要自行试录确认。

控制条只是触发同一套快捷键，不会保存 OBS WebSocket 密码，也不依赖网络：

```text
Alt + 1  真人全屏
Alt + 2  电脑录屏 + 真人小窗
Alt + 3  电脑录屏全屏
Alt + Z  平滑缩放 / 恢复
Alt + X  鼠标跟随 开 / 关（与 Z 相邻）
Alt + R  录制 开 / 关
```

为了避免重复启动，脚本使用了单实例锁；再次运行不会产生第二条控制条。
