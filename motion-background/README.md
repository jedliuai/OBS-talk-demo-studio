# JED Midnight Loop

这是 OBS 工作台午夜蓝背景的 Remotion 源工程。成片为 12 秒、2560×1440、30fps 的无声循环视频。

底图不做任何整体缩放或位移。斜线只做 9px 以内的视差，下方光带做 1.8% 以内的独立呼吸，上方光带轻柔掠光，右下角圆环单独完成流光；第 0 帧与循环终点回到同一组参数，适合长时间录制而不会产生镜头晃动感。

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
npx remotion render JedMidnightLoop ..\assets\jed-midnight-studio-loop.mp4 --codec=h264 --crf=20 --pixel-format=yuv420p
```

输出文件由仓库根目录的 OBS 安装脚本复制到用户配置目录。
