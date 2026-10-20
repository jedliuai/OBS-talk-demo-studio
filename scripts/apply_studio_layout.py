"""把场景集合迁移到 Jed Studio 布局（深蓝工作室 / 暖纸桌面两套背景）。

既可用于仓库里的脱敏模板，也可用于本机 OBS 场景集合：只改背景、录屏区、
真人圆窗和边框的来源与位置，摄像头、窗口、麦克风等设备选择原样保留。
运行前请先退出 OBS。

    python scripts/apply_studio_layout.py <scene.json> [--assets <dir>]

不传 --assets 时写入安装脚本使用的占位符。
"""

import argparse
import copy
import json
import uuid
from pathlib import Path

W, H = 2560, 1440
WINDOW = {"x": 68, "y": 124, "w": 2112, "h": 1188}
CAMERA_POS, CAMERA_SCALE = (2080, 884), 0.44  # 1000×1000 crop → 440px disc
RING_POS = (2000, 804)

OLD_BG = "背景 - JED午夜蓝动态"
OLD_LABEL = "JED 品牌签名"
BACKGROUNDS = [
    ("背景 · 深蓝工作室", "jed-slate-studio-loop.mp4", "{{SLATE_VIDEO_PATH}}", True),
    ("背景 · 暖纸桌面", "jed-paper-desk-loop.mp4", "{{PAPER_VIDEO_PATH}}", False),
]
RING_FILE, RING_PLACEHOLDER = "camera-ring-jed.png", "{{FRAME_ASSET_PATH}}"
SCENE_SPLIT = "02 电脑录屏 + 真人小窗"
SCENE_FULL = "03 电脑录屏全屏"
CAPTURES = ("窗口捕获（手动选择）", "屏幕捕获")


def place(item, x, y, *, scale=1.0, bounds=None):
    """Set an item's transform, keeping OBS's canvas-relative copies in sync."""
    item["pos"] = {"x": float(x), "y": float(y)}
    item["pos_rel"] = {"x": (x - W / 2) / (H / 2), "y": (y - H / 2) / (H / 2)}
    item["scale"] = item["scale_rel"] = {"x": float(scale), "y": float(scale)}
    item["rot"] = 0.0
    item["align"] = 5
    if bounds:
        bw, bh = bounds
        item["bounds_type"] = 2
        item["bounds_align"] = 0
        item["bounds"] = {"x": float(bw), "y": float(bh)}
        item["bounds_rel"] = {"x": bw / (H / 2), "y": bh / (H / 2)}
        for side in ("left", "top", "right", "bottom"):
            item[f"crop_{side}"] = 0


def asset(assets_dir, name, placeholder):
    return str(Path(assets_dir) / name) if assets_dir else placeholder


def migrate(data, assets_dir=None):
    sources = data["sources"]
    by_name = {s["name"]: s for s in sources}
    split = by_name[SCENE_SPLIT]["settings"]["items"]

    if OLD_BG in by_name:
        old = by_name[OLD_BG]
        old_index = next(i for i, it in enumerate(split) if it["name"] == OLD_BG)
        old_item = split.pop(old_index)
        next_id = max(it["id"] for it in split + [old_item]) + 1
        for offset, (name, file, placeholder, visible) in enumerate(BACKGROUNDS):
            src = copy.deepcopy(old)
            src["name"] = name
            src["uuid"] = str(uuid.uuid4())
            src["settings"]["local_file"] = asset(assets_dir, file, placeholder)
            sources.append(src)
            item = copy.deepcopy(old_item)
            item.update(name=name, source_uuid=src["uuid"], visible=visible, id=next_id + offset)
            split.insert(old_index + offset, item)
        sources.remove(old)

    if OLD_LABEL in by_name:
        sources.remove(by_name[OLD_LABEL])
        split[:] = [it for it in split if it["name"] != OLD_LABEL]

    settings = by_name[SCENE_SPLIT]["settings"]
    settings["id_counter"] = max(settings.get("id_counter", 0), *(it["id"] for it in split))

    by_name = {s["name"]: s for s in sources}
    by_name["摄像头圆形边框"]["settings"]["file"] = asset(assets_dir, RING_FILE, RING_PLACEHOLDER)

    for item in split:
        if item["name"] in CAPTURES:
            place(item, WINDOW["x"], WINDOW["y"], bounds=(WINDOW["w"], WINDOW["h"]))
        elif item["name"] == "00 摄像头圆形近景":
            place(item, *CAMERA_POS, scale=CAMERA_SCALE)
        elif item["name"] == "摄像头圆形边框":
            place(item, *RING_POS)

    # Undo any zoom transform left behind by a crash or by closing OBS mid-zoom.
    for item in by_name[SCENE_FULL]["settings"]["items"]:
        if item["name"] in CAPTURES:
            place(item, 0, 0, bounds=(W, H))
    return data


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("scene_json")
    parser.add_argument("--assets", help="installed asset folder; omit to write template placeholders")
    args = parser.parse_args()
    path = Path(args.scene_json)
    data = migrate(json.loads(path.read_text(encoding="utf-8")), args.assets)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=4) + "\n", encoding="utf-8", newline="\n")
    print(f"updated {path}")


if __name__ == "__main__":
    main()
