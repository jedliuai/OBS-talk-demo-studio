// Shared geometry for the 2560×1440 OBS canvas. The OBS scene template uses the
// same numbers, so change both together.
export const CANVAS = {width: 2560, height: 1440, fps: 30, loopFrames: 360};

// Screen card (bezel baked into the background) and the window-capture bounds inside it.
export const CARD = {x: 56, y: 112, w: 2136, h: 1212, radius: 22};
export const WINDOW = {x: 68, y: 124, w: 2112, h: 1188};

// Camera circle: 440px video disc, bottom edge aligned with the card.
export const CAMERA = {cx: 2300, cy: 1104, r: 220};

// Brand dot floats above the camera circle, like the dot of the "j".
export const CAMERA_DOT = {cx: CAMERA.cx, cy: CAMERA.cy - 254, r: 14};

// Right rail above the camera, used for the wall sign.
export const RAIL = {x: CARD.x + CARD.w, w: 2560 - (CARD.x + CARD.w)};

// Logo raster (public/jed-strokes-mask.png) and its dot, in source pixels.
export const LOGO = {w: 953, h: 465, dot: {cx: 266.7, cy: 30.6, r: 30}};

// Seamless loop helpers: every animated value is a function of the loop phase.
export const phase = (frame: number, cycles = 1, offset = 0) =>
  ((frame / CANVAS.loopFrames) * cycles + offset) * Math.PI * 2;
export const wave = (frame: number, cycles = 1, offset = 0) =>
  (Math.sin(phase(frame, cycles, offset)) + 1) / 2;
