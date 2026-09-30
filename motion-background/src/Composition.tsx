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
        name="Midnight studio artwork"
        src={staticFile("jed-midnight-studio.png")}
        width={2560}
        height={1440}
        style={{position: "absolute", inset: 0}}
      />

      <Interactive.Div
        name="Diagonal line parallax"
        style={{
          position: "absolute",
          inset: -32,
          background:
            "repeating-linear-gradient(135deg, transparent 0px, transparent 154px, rgba(105, 147, 255, 0.10) 155px, transparent 157px, transparent 310px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [0.08, 0.15, 0.08],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            ["0px 0px", "9px -9px", "0px 0px"],
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
          width: 1480,
          height: 720,
          left: -360,
          bottom: -390,
          borderRadius: "50%",
          background:
            "radial-gradient(ellipse at 58% 28%, rgba(76, 125, 255, 0.30) 0%, rgba(128, 107, 255, 0.12) 31%, rgba(5, 10, 24, 0) 68%)",
          filter: "blur(48px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [0.15, 0.27, 0.15],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          scale: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [1, 1.018, 1],
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
            ["0px 0px", "8px -6px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Upper ribbon soft shimmer"
        style={{
          position: "absolute",
          width: 1060,
          height: 520,
          right: -310,
          top: -290,
          borderRadius: "50%",
          background:
            "radial-gradient(ellipse at 34% 72%, rgba(169, 199, 255, 0.34) 0%, rgba(76, 125, 255, 0.15) 24%, rgba(128, 107, 255, 0.06) 42%, rgba(5, 10, 24, 0) 72%)",
          filter: "blur(44px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 3, (durationInFrames * 2) / 3, durationInFrames - 1],
            [0.13, 0.22, 0.17, 0.13],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 3, (durationInFrames * 2) / 3, durationInFrames - 1],
            ["0px 0px", "-7px 5px", "4px -3px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Camera circle halo"
        style={{
          position: "absolute",
          width: 660,
          height: 660,
          right: 4,
          bottom: 36,
          borderRadius: "50%",
          background:
            "radial-gradient(circle, rgba(5, 10, 24, 0) 51%, rgba(76, 125, 255, 0.12) 61%, rgba(128, 107, 255, 0.08) 70%, rgba(5, 10, 24, 0) 79%)",
          filter: "blur(26px)",
          mixBlendMode: "screen",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [0.22, 0.38, 0.22],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          scale: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [1, 1.016, 1],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
              output: "perceptual-scale",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Camera ring travelling highlight"
        style={{
          position: "absolute",
          width: 622,
          height: 622,
          right: 23,
          bottom: 55,
          borderRadius: "50%",
          background:
            "conic-gradient(from 0deg, rgba(169, 199, 255, 0) 0deg, rgba(169, 199, 255, 0) 268deg, rgba(169, 199, 255, 0.62) 302deg, rgba(128, 107, 255, 0.22) 326deg, rgba(169, 199, 255, 0) 352deg)",
          WebkitMask:
            "radial-gradient(farthest-side, transparent calc(100% - 4px), #000 calc(100% - 3px))",
          mask: "radial-gradient(farthest-side, transparent calc(100% - 4px), #000 calc(100% - 3px))",
          mixBlendMode: "screen",
          opacity: 0.34,
          rotate: interpolate(frame, [0, durationInFrames - 1], ["0deg", "360deg"], {
            easing: Easing.linear,
            extrapolateLeft: "clamp",
            extrapolateRight: "clamp",
          }),
        }}
      />

      <Interactive.Div
        name="Content readability veil"
        style={{
          position: "absolute",
          inset: 0,
          background:
            "radial-gradient(ellipse at 48% 46%, rgba(5, 10, 24, 0.08) 0%, rgba(5, 10, 24, 0.03) 52%, rgba(5, 10, 24, 0.12) 100%)",
        }}
      />
    </AbsoluteFill>
  );
};
