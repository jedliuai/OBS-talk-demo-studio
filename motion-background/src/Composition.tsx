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
      id="JedEmeraldLoop"
      component={JedEmeraldLoop}
      durationInFrames={360}
      fps={30}
      width={2560}
      height={1440}
    />
  );
};

export const JedEmeraldLoop: React.FC = () => {
  const frame = useCurrentFrame();
  const {durationInFrames} = useVideoConfig();

  return (
    <AbsoluteFill style={{backgroundColor: "#03110d", overflow: "hidden"}}>
      <CanvasImage
        name="Emerald studio artwork"
        src={staticFile("jed-emerald-studio.png")}
        width={2664}
        height={1498}
        style={{
          position: "absolute",
          left: -52,
          top: -29,
          scale: interpolate(
            frame,
            [0, durationInFrames / 4, durationInFrames / 2, (durationInFrames * 3) / 4, durationInFrames - 1],
            [1, 1.004, 1.007, 1.004, 1],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
              output: "perceptual-scale",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 4, durationInFrames / 2, (durationInFrames * 3) / 4, durationInFrames - 1],
            ["0px 0px", "-16px 8px", "0px 16px", "16px 8px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Soft emerald ambience"
        style={{
          position: "absolute",
          width: 900,
          height: 900,
          right: -260,
          bottom: -330,
          borderRadius: 9999,
          background:
            "radial-gradient(circle, rgba(53, 232, 159, 0.24) 0%, rgba(24, 146, 100, 0.08) 38%, rgba(0, 0, 0, 0) 72%)",
          filter: "blur(55px)",
          opacity: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            [0.18, 0.28, 0.18],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
          translate: interpolate(
            frame,
            [0, durationInFrames / 2, durationInFrames - 1],
            ["0px 0px", "-28px -18px", "0px 0px"],
            {
              easing: Easing.bezier(0.45, 0, 0.55, 1),
              extrapolateLeft: "clamp",
              extrapolateRight: "clamp",
            },
          ),
        }}
      />

      <Interactive.Div
        name="Readability veil"
        style={{
          position: "absolute",
          inset: 0,
          background:
            "linear-gradient(115deg, rgba(0, 8, 6, 0.10), rgba(0, 16, 12, 0.02) 58%, rgba(0, 8, 6, 0.12))",
        }}
      />
    </AbsoluteFill>
  );
};
