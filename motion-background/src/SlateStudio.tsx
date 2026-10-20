import React from "react";
import {AbsoluteFill, useCurrentFrame} from "remotion";
import {CAMERA_DOT, RAIL, wave} from "./layout";
import {Card, Grain, Header, Logo} from "./shared";

// 深蓝工作室：延续头像里的灰蓝墙面、左下蓝色补光和背光 jed 墙标。
const BLUE = "#3d7bff";

export const SlateStudio: React.FC = () => {
  const frame = useCurrentFrame();
  const wall = wave(frame, 1, 0.1);
  const lamp = wave(frame, 1, 0.55);
  const halo = wave(frame, 2, 0.3);
  const dot = wave(frame, 1, 0.8);

  const signWidth = 250;
  const signLeft = RAIL.x + (RAIL.w - signWidth) / 2;
  const signTop = 300;

  return (
    <AbsoluteFill style={{background: "#22304d", overflow: "hidden"}}>
      <AbsoluteFill style={{background: "linear-gradient(160deg,#4b5f88 0%,#33466c 44%,#1c2946 100%)"}} />

      {/* Soft wall light around the sign, breathing very slowly. */}
      <AbsoluteFill
        style={{
          background:
            "radial-gradient(1250px 950px at 2330px 330px, rgba(158,178,212,0.62), rgba(158,178,212,0) 70%)",
          opacity: 0.78 + wall * 0.22,
        }}
      />

      {/* Blue practical lamp in the lower left, drifting a few pixels. */}
      <AbsoluteFill
        style={{
          background:
            "radial-gradient(950px 720px at 110px 1400px, rgba(45,107,255,0.62), rgba(45,107,255,0) 70%)",
          opacity: 0.62 + lamp * 0.38,
          translate: `${Math.sin((frame / 360) * Math.PI * 2) * 18}px ${Math.cos((frame / 360) * Math.PI * 2) * 10}px`,
        }}
      />

      <AbsoluteFill
        style={{background: "radial-gradient(ellipse at 45% 45%, rgba(10,16,32,0) 55%, rgba(10,16,32,0.38) 100%)"}}
      />
      <Grain opacity={0.2} blend="overlay" />

      {/* Backlit wall sign, same as the one behind Jed in the avatar. */}
      <div
        style={{
          position: "absolute",
          left: signLeft - 120,
          top: signTop - 110,
          width: signWidth + 240,
          height: 340,
          borderRadius: "50%",
          background:
            "radial-gradient(closest-side, rgba(255,255,255,0.78), rgba(224,233,255,0.34) 48%, rgba(224,233,255,0) 100%)",
          filter: "blur(16px)",
          opacity: 0.82 + halo * 0.18,
        }}
      />
      <Logo
        width={signWidth}
        stroke="#1c212d"
        dot={BLUE}
        dotStyle={{boxShadow: `0 0 ${10 + halo * 8}px rgba(61,123,255,0.85)`}}
        style={{left: signLeft, top: signTop, filter: "drop-shadow(0 6px 10px rgba(10,16,32,0.35))"}}
      />

      <Header name="#f4f6fa" tag="rgba(230,236,248,0.72)" rule="rgba(255,255,255,0.24)" dot={BLUE} />

      <Card
        style={{
          background: "#0d1322",
          border: "1px solid rgba(255,255,255,0.09)",
          boxShadow: "0 40px 90px rgba(4,8,20,0.55), inset 0 1px 0 rgba(255,255,255,0.06)",
        }}
      />

      {/* Brand dot above the camera circle. */}
      <div
        style={{
          position: "absolute",
          left: CAMERA_DOT.cx - CAMERA_DOT.r,
          top: CAMERA_DOT.cy - CAMERA_DOT.r,
          width: CAMERA_DOT.r * 2,
          height: CAMERA_DOT.r * 2,
          borderRadius: "50%",
          background: BLUE,
          boxShadow: `0 0 ${14 + dot * 14}px rgba(61,123,255,${0.55 + dot * 0.3})`,
        }}
      />
    </AbsoluteFill>
  );
};
