import React from "react";
import {AbsoluteFill, useCurrentFrame} from "remotion";
import {CAMERA_DOT, RAIL, phase, wave} from "./layout";
import {Card, Grain, Header, Logo} from "./shared";

// 暖纸桌面：延续品牌片 v007 与领英 banner 的暖纸、陶土色和炭黑字。
const CLAY = "#c56d52";
const INK = "#292722";

const WindowLight: React.FC<{frame: number}> = ({frame}) => {
  // Four soft panes of window light falling across the upper right, drifting slowly.
  const dx = Math.sin(phase(frame)) * 80;
  const dy = Math.cos(phase(frame)) * 26;
  const panes = [
    [0, 0],
    [430, 0],
    [0, 560],
    [430, 560],
  ];
  return (
    <div
      style={{
        position: "absolute",
        left: 1500 + dx,
        top: -420 + dy,
        width: 1000,
        height: 1300,
        rotate: "-24deg",
        filter: "blur(46px)",
        opacity: 0.5 + wave(frame, 1, 0.2) * 0.35,
      }}
    >
      {panes.map(([x, y]) => (
        <div
          key={`${x}-${y}`}
          style={{
            position: "absolute",
            left: x,
            top: y,
            width: 380,
            height: 510,
            background: "rgba(255,252,243,0.9)",
          }}
        />
      ))}
    </div>
  );
};

export const PaperDesk: React.FC = () => {
  const frame = useCurrentFrame();
  const dot = wave(frame, 1, 0.8);

  const signWidth = 240;
  const signLeft = RAIL.x + (RAIL.w - signWidth) / 2;
  const signTop = 310;

  return (
    <AbsoluteFill style={{background: "#ece9e0", overflow: "hidden"}}>
      <AbsoluteFill style={{background: "linear-gradient(168deg,#efece4 0%,#e7e3d8 58%,#dfdacd 100%)"}} />
      <AbsoluteFill
        style={{
          background:
            "radial-gradient(1500px 1100px at 2380px 140px, rgba(255,251,240,0.6), rgba(255,251,240,0) 70%)",
        }}
      />
      <WindowLight frame={frame} />

      {/* Large quiet arcs, echoing the LinkedIn banner. */}
      {[
        [-640, 620, 1520],
        [-320, 980, 1120],
      ].map(([x, y, d]) => (
        <div
          key={x}
          style={{
            position: "absolute",
            left: x,
            top: y,
            width: d,
            height: d,
            borderRadius: "50%",
            border: "1.5px solid rgba(163,78,56,0.14)",
          }}
        />
      ))}

      <Grain opacity={0.13} blend="multiply" />

      {/* Debossed wordmark in the rail: a highlight below, a soft ink fill on top. */}
      <Logo width={signWidth} stroke="rgba(255,255,255,0.9)" dot="transparent" style={{left: signLeft, top: signTop + 2}} />
      <Logo
        width={signWidth}
        stroke="rgba(110,92,66,0.32)"
        dot={CLAY}
        style={{left: signLeft, top: signTop}}
      />

      <Header name={INK} tag="#6b665c" rule="rgba(41,39,34,0.2)" dot={CLAY} />

      <Card
        style={{
          background: "#faf9f5",
          border: "1px solid rgba(41,39,34,0.10)",
          boxShadow: "0 30px 70px rgba(70,55,30,0.18), 0 6px 16px rgba(70,55,30,0.08)",
        }}
      />

      <div
        style={{
          position: "absolute",
          left: CAMERA_DOT.cx - CAMERA_DOT.r,
          top: CAMERA_DOT.cy - CAMERA_DOT.r,
          width: CAMERA_DOT.r * 2,
          height: CAMERA_DOT.r * 2,
          borderRadius: "50%",
          background: CLAY,
          boxShadow: `0 ${4 + dot * 3}px ${8 + dot * 6}px rgba(163,78,56,${0.22 + dot * 0.12})`,
          scale: `${1 + dot * 0.06}`,
        }}
      />
    </AbsoluteFill>
  );
};
