# 安装说明

## 1. 先退出 OBS

安装脚本需要写入 OBS 的配置文件。若 OBS 正在运行，它退出时可能覆盖刚安装的内容，因此脚本检测到 `obs64` 后会直接停止并提示。

## 2. 安装场景与配置

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

自定义录制目录：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -RecordPath "D:\Videos\OBS-talk-demo-studio"
```

脚本会把旧的同名配置备份到 `%APPDATA%\obs-studio\OBS-talk-demo-studio-backups\时间戳`。

## 3. 重新打开 OBS

依次确认：

1. 场景集合选择 `个人IP录制工作台`。
2. 配置文件选择 `个人IP录制_1440p30`。
3. 双击 `窗口捕获（手动选择）`，在“窗口”下拉框选择浏览器、PPT 或其他软件。
4. 双击 `摄像头（Camo/iPhone）`，选择 Camo 或其他摄像头。
5. 如需调整小窗人物大小，进入 `00 摄像头圆形近景`，只修改其中摄像头来源的大小和位置。
6. 在 `主麦克风` 中选择你的麦克风；默认设备也可以直接工作。
7. 做一次 10 秒试录，确认轨道 1、2、3 都有声音。

## 4. 安装水波版 Zoominator（可选）

推荐以管理员身份运行校验过发布包哈希的安装脚本：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-ripple-plugin.ps1
```

如果 OBS 不在标准安装目录，可指定路径：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-ripple-plugin.ps1 -ObsInstallRoot "D:\Program Files\obs-studio"
```

也可以从本仓库 Actions 的 `Build Zoominator Ripple` 工作流或 `v1.0.0` Release 手动下载 Windows x64 构建产物。将其中的 `zoominator.dll` 放入：

```text
<OBS 安装目录>\obs-plugins\64bit\zoominator.dll
```

替换前退出 OBS，并保留原 DLL 备份。仓库中的构建工作流会从上游 `2.0.6` 标签拉取源码、应用公开补丁后编译；不会使用不透明的预编译源代码。

## 5. 快速自检

- `Alt + 1/2/3/4` 能否依次切换真人、普通讲解、重点缩放和电脑全屏；
- `02` 与 `03` 的布局是否一致，而 `03` 中的软件内容明显放大；
- `Ctrl + Alt + Z` 能否在鼠标附近平滑放大和恢复；
- `Ctrl + Alt + F` 能否开关鼠标跟随；
- 鼠标点击是否出现柔和扩散水波；
- `Alt + R` 能否开始和停止录制；
- 录制文件是否写入指定目录。
