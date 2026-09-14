"""앱 아이콘 생성 스크립트. 실행: python tool/make_icon.py
assets/icon/icon.png (1024x1024, 배경 포함) 과
assets/icon/icon_fg.png (Android adaptive 전경, 투명 배경) 을 만든다."""
import math
import os

from PIL import Image, ImageDraw, ImageFilter

SIZE = 1024
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "icon")
os.makedirs(OUT, exist_ok=True)

# 앱 시드 컬러(0xFF6750A4) 계열 그라데이션
TOP = (118, 84, 196)
BOTTOM = (58, 34, 110)
GOLD = (255, 214, 86)
CREAM = (255, 246, 214)


def gradient_bg(size):
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        t = y / (size - 1)
        for x in range(size):
            # 대각선 그라데이션
            k = (t * 0.7 + (x / (size - 1)) * 0.3)
            px[x, y] = tuple(int(TOP[i] + (BOTTOM[i] - TOP[i]) * k) for i in range(3))
    return img


def star4(draw, cx, cy, r, inner_ratio, fill):
    """4각 반짝이 별."""
    pts = []
    for i in range(8):
        ang = math.pi / 4 * i - math.pi / 2
        rr = r if i % 2 == 0 else r * inner_ratio
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    draw.polygon(pts, fill=fill)


def draw_symbol(layer, scale=1.0, offset=(0, 0)):
    """초승달 + 별들. layer 는 RGBA."""
    s = SIZE * scale
    ox, oy = offset
    d = ImageDraw.Draw(layer)

    # 초승달: 큰 원에서 작은 원을 빼서 만든다 (마스크 방식)
    moon = Image.new("L", (SIZE, SIZE), 0)
    md = ImageDraw.Draw(moon)
    cx, cy = SIZE * 0.46 + ox, SIZE * 0.52 + oy
    r = s * 0.30
    md.ellipse([cx - r, cy - r, cx + r, cy + r], fill=255)
    # 빼는 원 (오른쪽 위로 치우침)
    bx, by, br = cx + r * 0.42, cy - r * 0.30, r * 0.86
    md.ellipse([bx - br, by - br, bx + br, by + br], fill=0)
    moon_col = Image.new("RGBA", (SIZE, SIZE), CREAM + (255,))
    layer.paste(moon_col, (0, 0), moon)

    # 별들
    star4(d, SIZE * 0.66 + ox, SIZE * 0.30 + oy, s * 0.11, 0.38, GOLD + (255,))
    star4(d, SIZE * 0.76 + ox, SIZE * 0.52 + oy, s * 0.055, 0.38, GOLD + (255,))
    star4(d, SIZE * 0.80 + ox, SIZE * 0.70 + oy, s * 0.04, 0.38, CREAM + (255,))


def with_glow(symbol):
    glow = symbol.filter(ImageFilter.GaussianBlur(SIZE * 0.03))
    glow = Image.eval(glow, lambda v: int(v * 0.55))
    out = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    out.alpha_composite(glow)
    out.alpha_composite(symbol)
    return out


# 1) 풀 아이콘 (iOS / 스토어용, 불투명)
bg = gradient_bg(SIZE).convert("RGBA")
sym = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_symbol(sym)
bg.alpha_composite(with_glow(sym))
bg.convert("RGB").save(os.path.join(OUT, "icon.png"))

# 2) Adaptive 전경 (Android): 안전 영역(중앙 66%)에 들어가도록 축소
fg = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
small = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_symbol(small)
small = with_glow(small)
k = 1.0  # flutter_launcher_icons 가 16% 인셋을 넣으므로 여기선 축소하지 않는다
small = small.resize((int(SIZE * k), int(SIZE * k)), Image.LANCZOS)
fg.alpha_composite(small, (int(SIZE * (1 - k) / 2), int(SIZE * (1 - k) / 2)))
fg.save(os.path.join(OUT, "icon_fg.png"))

print("written:", os.path.abspath(OUT))
