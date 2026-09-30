import {
  AbsoluteFill,
  CanvasImage,
  Composition,
  Easing,
  Interactive,
  interpolate,
  staticFile,
  useCurrentFrame,
  useVideoConfig,
} from "remotion";

export const MyComposition = () => {
  return (
    <Composition
      id="JedMidnightLoop"
      component={JedMidnightLoop}
      durationInFrames={360}
      fps={30}
      width={2560}
      height={1440}
    />
  );
};

export const JedMidnightLoop: React.FC = () => {
  const frame = useCurrentFrame();
  const {durationInFrames} = useVideoConfig();

  return (
    <AbsoluteFill style={{backgroundColor: "#050a18", overflow: "hidden"}}>
      <CanvasImage
        name="Stable midnight base plate"
        src={staticFile("jed-midnight-studio-clean.png")}
        width={2560}
        height={1440}
        style={{position: "absolute", inset: 0}}
      />

      <Interactive.Div
        name="Diagonal line drift"
        style={{
          position: "absolute",
          inset: -48,
          background:
            "repeating-linear-gradient(135deg, transparent 0px, transparent 152px, rgba(105, 147, 255, 0.22) 154px, transparent 157px, transparent 306px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 4, durationInFrames / 2, (durationInFrames * 3) / 4, durationInFrames - 1],
            [0.1, 0.23, 0.16, 0.27, 0.1],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            ["0px 0px", "22px -22px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Travelling diagonal sheen"
        style={{
          position: "absolute",
          width: 460,
          height: 2100,
          left: -520,
          top: -360,
          rotate: "-45deg",
          background:
            "linear-gradient(90deg, rgba(76, 125, 255, 0) 0%, rgba(76, 125, 255, 0.08) 30%, rgba(169, 199, 255, 0.24) 50%, rgba(128, 107, 255, 0.08) 70%, rgba(76, 125, 255, 0) 100%)",
          filter: "blur(34px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, 45, 135, 225, 315, durationInFrames - 1],
            [0, 0.34, 0.2, 0.34, 0.16, 0],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            ["0px 0px", "2700px 0px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Lower ribbon breathing light"
        style={{
          position: "absolute",
          width: 1500,
          height: 760,
          left: -360,
          bottom: -410,
          borderRadius: "50%",
          background:
            "radial-gradient(ellipse at 58% 28%, rgba(76, 125, 255, 0.56) 0%, rgba(128, 107, 255, 0.24) 31%, rgba(5, 10, 24, 0) 68%)",
          filter: "blur(46px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [0.18, 0.46, 0.18],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          scale: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [1, 1.04, 1],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
              output: "perceptual-scale",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            ["0px 0px", "18px -12px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Upper ribbon breathing light"
        style={{
          position: "absolute",
          width: 1100,
          height: 560,
          right: -330,
          top: -310,
          borderRadius: "50%",
          background:
            "radial-gradient(ellipse at 34% 72%, rgba(169, 199, 255, 0.54) 0%, rgba(76, 125, 255, 0.24) 24%, rgba(128, 107, 255, 0.1) 43%, rgba(5, 10, 24, 0) 72%)",
          filter: "blur(42px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, 120, 240, durationInFrames - 1],
            [0.16, 0.4, 0.25, 0.16],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          translate: interpolate(
            frame,
            [0, 120, 240, durationInFrames - 1],
            ["0px 0px", "-16px 10px", "9px -6px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Camera concentric tapered half orbit"
        style={{
          position: "absolute",
          width: 660,
          height: 660,
          left: 1920,
          top: 780,
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, 90, 180, 270, durationInFrames - 1],
            [0.42, 0.82, 0.52, 0.9, 0.42],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      >
        <svg width="660" height="660" viewBox="0 0 660 660">
          <defs>
            <linearGradient
              id="camera-orbit-gradient"
              x1="492"
              y1="50"
              x2="50"
              y2="492"
              gradientUnits="userSpaceOnUse"
            >
              <stop offset="0%" stopColor="#4c7dff" stopOpacity="0" />
              <stop offset="12%" stopColor="#4c7dff" stopOpacity="0.24" />
              <stop offset="46%" stopColor="#a9c7ff" stopOpacity="0.9" />
              <stop offset="76%" stopColor="#806bff" stopOpacity="0.48" />
              <stop offset="100%" stopColor="#806bff" stopOpacity="0" />
            </linearGradient>
            <filter id="camera-orbit-glow" x="-30%" y="-30%" width="160%" height="160%">
              <feGaussianBlur stdDeviation="7" result="blur" />
              <feMerge>
                <feMergeNode in="blur" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>
          </defs>
          <path
            d="M 491.5 50.26 A 323 323 0 1 1 50.26 491.5"
            fill="none"
            stroke="url(#camera-orbit-gradient)"
            strokeWidth="6"
            strokeLinecap="round"
            filter="url(#camera-orbit-glow)"
          />
          <path
            d="M 491.5 50.26 A 323 323 0 1 1 50.26 491.5"
            fill="none"
            stroke="#d2e2ff"
            strokeWidth="11"
            strokeLinecap="round"
            strokeDasharray="72 1960"
            style={{
              filter: "blur(0.8px) drop-shadow(0 0 10px rgba(169, 199, 255, 0.9))",
              opacity: interpolate(frame, [0, 28, 330, durationInFrames - 1], [0, 0.92, 0.92, 0], {
                easing: Easing.bezier(0.45, 0, 0.55, 1),
                extrapolateLeft: "clamp",
                extrapolateRight: "clamp",
              }),
              strokeDashoffset: interpolate(frame, [0, durationInFrames - 1], [100, -1120], {
                easing: Easing.linear,
                extrapolateLeft: "clamp",
                extrapolateRight: "clamp",
              }),
            }}
          />
        </svg>
      </Interactive.Div>

      <Interactive.Div
        name="Content readability veil"
        style={{
          position: "absolute",
          inset: 0,
          background:
            "radial-gradient(ellipse at 48% 46%, rgba(5, 10, 24, 0.05) 0%, rgba(5, 10, 24, 0.02) 52%, rgba(5, 10, 24, 0.1) 100%)",
        }}
      />
    </AbsoluteFill>
  );
};
