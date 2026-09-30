# JED Midnight Loop

这是 OBS 工作台午夜蓝背景的 Remotion 源工程。成片为 12 秒、2560×1440、30fps 的无声循环视频。

底图不做任何整体缩放或位移。斜线在 22px 内缓慢漂移，斜向柔光会穿过画面，上下光带分别呼吸；右下角不再使用完整背景圆，而是以真人圆窗的 `(2250, 1110)` 为圆心绘制渐隐半环，让高光沿半环移动。第 0 帧与循环终点回到同一组参数，适合长时间录制而不会产生镜头晃动感。

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
npx remotion render JedMidnightLoop ..\assets\jed-midnight-studio-loop-v2.mp4 --codec=h264 --crf=18 --pixel-format=yuv420p
```

输出文件由仓库根目录的 OBS 安装脚本复制到用户配置目录。
