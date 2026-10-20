# Jed Studio 背景

OBS 工作台 `02 电脑录屏 + 真人小窗` 场景的背景源工程，两套成片都是 12 秒、2560×1440、30fps 的无声无缝循环：

- `JedSlateStudio` 深蓝工作室：头像里的灰蓝墙面、左下蓝色补光、背光 jed 墙标。
- `JedPaperDesk` 暖纸桌面：品牌片 v007 与领英 banner 的暖纸、陶土色、压印 jed 字标，窗光在纸面上缓慢移动。

两套共用 `src/layout.ts` 里的几何：顶栏名字、录屏卡片、真人圆窗与上方的品牌圆点。OBS 场景模板（`scripts/apply_studio_layout.py`）使用同一组数字，改布局时两边一起改。所有动画都是循环相位的周期函数，第 0 帧与第 360 帧完全一致。

真人圆窗边框 `../assets/camera-ring-jed.png` 两套背景通用，不在本工程里渲染。旧版午夜蓝背景 `JedMidnightLoop` 仍保留，用于回退。

字体使用系统已安装的 Noto Sans SC。

## 安装依赖

```console
npm ci
```

## 打开预览

```console
npm run dev
```

## 渲染视频

```console
npx remotion render JedSlateStudio ..\assets\jed-slate-studio-loop.mp4 --codec=h264 --crf=18 --pixel-format=yuv420p
npx remotion render JedPaperDesk ..\assets\jed-paper-desk-loop.mp4 --codec=h264 --crf=18 --pixel-format=yuv420p
```

输出文件由仓库根目录的 OBS 安装脚本复制到用户配置目录。
