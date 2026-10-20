"""渲染真人圆窗边框 assets/camera-ring-jed.png（两套背景通用）。

600×600，圆心 (300, 300)；圆窗画面半径 220，暖白环 219–228px，上亮下暗，
内外各一圈极淡细线，投影只落在圆外。OBS 中放在 (2000, 804)。
"""

import numpy as np
from PIL import Image, ImageFilter

SS, N, C = 4, 600, 300.0
R_IN, R_OUT = 219.0, 228.0


def ring_layer():
    n = N * SS
    y, x = np.mgrid[0:n, 0:n].astype(np.float32)
    r = np.hypot(x / SS - C + 0.5 / SS, y / SS - C + 0.5 / SS)
    band = lambda r0, r1: ((r >= r0) & (r < r1)).astype(np.float32)
    t = np.clip(((y / SS - C) / R_OUT + 1) / 2, 0, 1)[..., None]
    top, bottom = np.array([255, 254, 250], np.float32), np.array([226, 222, 212], np.float32)
    rgba = np.zeros((n, n, 4), np.float32)
    rgba[..., :3] = top * (1 - t) + bottom * t
    rgba[..., 3] = band(R_IN, R_OUT) * 255

    def over(rgb, a):
        a = a[..., None]
        rgba[..., :3] = np.array(rgb, np.float32) * a + rgba[..., :3] * (1 - a)
        rgba[..., 3:] = a * 255 + rgba[..., 3:] * (1 - a)

    over((18, 20, 28), band(R_IN, R_IN + 1.4) * 0.42)
    over((20, 18, 14), band(R_OUT - 0.8, R_OUT + 0.6) * 0.14)
    return np.asarray(Image.fromarray(rgba.clip(0, 255).astype(np.uint8)).resize((N, N), Image.LANCZOS)).astype(np.float32)


def shadow_alpha():
    y, x = np.mgrid[0:N, 0:N]
    disc = lambda dy, r: Image.fromarray(((np.hypot(x - C, y - C - dy) < r) * 255).astype(np.uint8))
    drop = np.asarray(disc(14, R_OUT).filter(ImageFilter.GaussianBlur(22))).astype(np.float32) / 255 * 0.34
    ambient = np.asarray(disc(0, R_OUT + 1).filter(ImageFilter.GaussianBlur(5))).astype(np.float32) / 255 * 0.16
    a = np.maximum(drop, ambient)
    a[np.hypot(x - C, y - C) < R_IN] = 0  # never darken the camera picture
    return a


def main():
    ring = ring_layer()
    a = ring[..., 3:] / 255
    sa = shadow_alpha()[..., None]
    out = np.zeros((N, N, 4), np.float32)
    out[..., 3:] = ring[..., 3:] + sa * 255 * (1 - a)
    cover = np.maximum(out[..., 3:] / 255, 1e-6)
    out[..., :3] = (ring[..., :3] * a + np.array([10, 12, 20], np.float32) * sa * (1 - a)) / cover
    Image.fromarray(out.clip(0, 255).astype(np.uint8)).save("assets/camera-ring-jed.png")


if __name__ == "__main__":
    main()
