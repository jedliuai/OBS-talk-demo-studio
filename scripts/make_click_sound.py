"""Generate the soft click sound used by the Zoominator click feedback.

Deterministic and dependency-free (standard library only), so the WAV in the
repo can be rebuilt bit-for-bit and carries no third-party copyright.

    python scripts/make_click_sound.py

Writes assets/sounds/zoominator-click.wav: 48 kHz, mono, 16-bit, ~40 ms.
A short decaying sine that glides from about 2.1 kHz to 1.85 kHz gives the
soft "ta"; a touch of low-passed noise adds texture without the bright snap
of a mechanical key. Peak is normalised to -18 dBFS, with a raised-cosine
fade-in and fade-out so playback never pops.
"""

import math
import os
import random
import struct
import wave

RATE = 48000
DURATION_S = 0.040
PEAK_DBFS = -18.0
FADE_IN_S = 0.0012
FADE_OUT_S = 0.006

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                   'assets', 'sounds', 'zoominator-click.wav')


def synth():
    n = int(RATE * DURATION_S)
    rng = random.Random(20261021)
    lp = 0.0
    # One-pole low-pass around 2.5 kHz for the noise layer.
    alpha = 1.0 - math.exp(-2.0 * math.pi * 2500.0 / RATE)
    phase = 0.0
    samples = []
    for i in range(n):
        t = i / RATE
        freq = 1850.0 + 250.0 * math.exp(-t / 0.008)
        phase += 2.0 * math.pi * freq / RATE
        tone = math.sin(phase) * math.exp(-t / 0.0075)
        lp += alpha * (rng.uniform(-1.0, 1.0) - lp)
        noise = lp * math.exp(-t / 0.0025) * 0.35
        samples.append(tone + noise)

    fade_in = int(RATE * FADE_IN_S)
    fade_out = int(RATE * FADE_OUT_S)
    for i in range(fade_in):
        samples[i] *= 0.5 - 0.5 * math.cos(math.pi * i / fade_in)
    for i in range(fade_out):
        samples[n - 1 - i] *= 0.5 - 0.5 * math.cos(math.pi * i / fade_out)

    peak = max(abs(s) for s in samples)
    target = 10.0 ** (PEAK_DBFS / 20.0)
    return [s / peak * target for s in samples]


def main():
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    data = b''.join(struct.pack('<h', int(round(s * 32767.0))) for s in synth())
    with wave.open(OUT, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(data)
    print(OUT)


if __name__ == '__main__':
    main()
