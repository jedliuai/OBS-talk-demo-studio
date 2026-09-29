# JED Emerald Loop

这是 OBS 工作台翡翠背景的 Remotion 源工程。成片为 12 秒、2560×1440、30fps 的无声循环视频。

动效刻意保持克制：最大缩放约 0.7%，水平漂移不超过 16px，环境光漂移不超过 28px；第 0 帧与第 359 帧回到同一组参数，适合长时间循环。

## 安装依赖

```console
npm install
```

## 打开预览

```console
npm run dev
```

## 渲染视频

```console
npx remotion render JedEmeraldLoop ..\assets\jed-emerald-studio-loop.mp4 --codec=h264 --crf=20 --pixel-format=yuv420p
```

输出文件由仓库根目录的 OBS 安装脚本复制到用户配置目录。
