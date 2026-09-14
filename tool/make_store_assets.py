"""Google Play 스토어 등록용 이미지 생성.
실행: python tool/make_store_assets.py
입력: assets/icon/icon.png, store/raw/*.png (에뮬레이터 스크린샷 720x1280)
출력: store/icon-512.png, store/feature-graphic.png, store/screenshots/NN.png (1080x1920)
"""
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.join(os.path.dirname(__file__), "..")
STORE = os.path.join(ROOT, "store")
RAW = os.path.join(STORE, "raw")
SHOTS = os.path.join(STORE, "screenshots")
os.makedirs(SHOTS, exist_ok=True)

TOP = (118, 84, 196)
BOTTOM = (58, 34, 110)
CREAM = (255, 246, 214)
GOLD = (255, 214, 86)

FONT_BOLD = r"C:\Windows\Fonts\malgunbd.ttf"
FONT_REG = r"C:\Windows\Fonts\malgun.ttf"


def font(path, size):
    return ImageFont.truetype(path, size)


def gradient(w, h):
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        for x in range(w):
            k = (y / max(h - 1, 1)) * 0.65 + (x / max(w - 1, 1)) * 0.35
            px[x, y] = tuple(int(TOP[i] + (BOTTOM[i] - TOP[i]) * k) for i in range(3))
    return img


def rounded_mask(size, radius):
    m = Image.new("L", size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return m


def shadow(base, box_size, pos, radius, blur=40, alpha=110):
    sh = Image.new("RGBA", base.size, (0, 0, 0, 0))
    layer = Image.new("RGBA", box_size, (0, 0, 0, alpha))
    sh.paste(layer, (pos[0], pos[1] + 24), rounded_mask(box_size, radius))
    sh = sh.filter(ImageFilter.GaussianBlur(blur))
    base.alpha_composite(sh)


# ---------------------------------------------------------------- 512 아이콘
icon = Image.open(os.path.join(ROOT, "assets", "icon", "icon.png")).convert("RGB")
icon.resize((512, 512), Image.LANCZOS).save(os.path.join(STORE, "icon-512.png"))

# ---------------------------------------------------------------- 피처 그래픽 1024x500
W, H = 1024, 500
fg = gradient(W, H).convert("RGBA")

# 왼쪽: 둥근 아이콘
isz = 300
ic = icon.resize((isz, isz), Image.LANCZOS).convert("RGBA")
ipos = (90, (H - isz) // 2)
shadow(fg, (isz, isz), ipos, 64)
fg.paste(ic, ipos, rounded_mask((isz, isz), 64))

# 오른쪽: 텍스트
d = ImageDraw.Draw(fg)
tx = 450
d.text((tx, 135), "오늘의 운세", font=font(FONT_BOLD, 88), fill=CREAM)
d.text((tx + 4, 250), "매일 아침, 나만의 운세와 명언", font=font(FONT_REG, 38), fill=(232, 224, 255))
d.text((tx + 4, 310), "띠별 운세 · 행운의 숫자 · 오늘의 명언", font=font(FONT_REG, 28), fill=(200, 188, 240))
fg.convert("RGB").save(os.path.join(STORE, "feature-graphic.png"))

# ---------------------------------------------------------------- 스크린샷 1080x1920
SW, SH = 1080, 1920
shots = [
    ("s_home.png", "매일 아침 확인하는", "나만의 오늘 운세"),
    ("s_detail.png", "애정·금전·직장·건강", "5가지 운세를 한눈에"),
    ("s_home2.png", "행운의 숫자와 색,", "그리고 오늘의 명언"),
    ("s_detail2.png", "마음에 안 들면", "운세 다시 뽑기"),
]
for n, (fname, line1, line2) in enumerate(shots, start=1):
    bg = gradient(SW, SH).convert("RGBA")
    d = ImageDraw.Draw(bg)

    # 상단 캡션
    f1 = font(FONT_REG, 58)
    f2 = font(FONT_BOLD, 76)
    for text, f, y in ((line1, f1, 150), (line2, f2, 230)):
        w = d.textlength(text, font=f)
        d.text(((SW - w) / 2, y), text, font=f, fill=CREAM)

    # 폰 스크린샷 (상태바 잘라내고 둥근 모서리)
    src = Image.open(os.path.join(RAW, fname)).convert("RGBA")
    src = src.crop((0, 48, src.width, src.height - 40))  # 상태바·내비 바 제거
    ph = SH - 420
    pw = int(src.width * ph / src.height)
    src = src.resize((pw, ph), Image.LANCZOS)
    ppos = ((SW - pw) // 2, 380)
    shadow(bg, (pw, ph), ppos, 48)
    # 테두리
    border = Image.new("RGBA", (pw + 16, ph + 16), (255, 255, 255, 60))
    bg.paste(border, (ppos[0] - 8, ppos[1] - 8), rounded_mask((pw + 16, ph + 16), 56))
    bg.paste(src, ppos, rounded_mask((pw, ph), 48))

    bg.convert("RGB").save(os.path.join(SHOTS, f"{n:02d}.png"))

print("done:", os.path.abspath(STORE))
