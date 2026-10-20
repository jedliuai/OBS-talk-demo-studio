import "./index.css";
import {Composition} from "remotion";
import {MyComposition} from "./Composition";
import {CANVAS} from "./layout";
import {PaperDesk} from "./PaperDesk";
import {SlateStudio} from "./SlateStudio";

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="JedSlateStudio"
        component={SlateStudio}
        durationInFrames={CANVAS.loopFrames}
        fps={CANVAS.fps}
        width={CANVAS.width}
        height={CANVAS.height}
      />
      <Composition
        id="JedPaperDesk"
        component={PaperDesk}
        durationInFrames={CANVAS.loopFrames}
        fps={CANVAS.fps}
        width={CANVAS.width}
        height={CANVAS.height}
      />
      {/* 旧版午夜蓝背景，保留用于回退。 */}
      <MyComposition />
    </>
  );
};
