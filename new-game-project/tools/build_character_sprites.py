"""Extract and pack the character shown in the supplied pixel-editor screenshot.

Each screenshot grid cell becomes one pixel. The editor grid is removed by taking
the most common colour from the interior of each 13-by-13 screen-pixel cell.
The script then builds a small four-direction Godot sprite sheet and individual
transparent PNG frames. It does not invent colours or smooth the pixel edges.
"""

from __future__ import annotations

import argparse
from collections import Counter
from pathlib import Path

from PIL import Image, ImageDraw


CELL_SIZE = 13
CELL_BACKGROUND = (243, 243, 243)
FRAME_WIDTH = 32
FRAME_HEIGHT = 64
FRAME_ORIGIN = (3, 3)


def colour_in_cell(image: Image.Image, column: int, row: int) -> tuple[int, int, int]:
    """Return the dominant colour, ignoring the one-pixel editor grid lines."""
    left = column * CELL_SIZE + 1
    top = row * CELL_SIZE + 1
    pixels = [
        image.getpixel((x, y))
        for y in range(top, top + CELL_SIZE - 2)
        for x in range(left, left + CELL_SIZE - 2)
    ]
    return Counter(pixels).most_common(1)[0][0]


def extract_view(
    image: Image.Image,
    columns: range,
    rows: range,
) -> Image.Image:
    """Read a character view from screenshot grid cells and make its backdrop clear."""
    cells = {
        (column, row): colour_in_cell(image, column, row)
        for row in rows
        for column in columns
    }
    occupied = [
        (column, row)
        for (column, row), colour in cells.items()
        if colour != CELL_BACKGROUND
    ]
    left = min(column for column, _row in occupied)
    right = max(column for column, _row in occupied)
    top = min(row for _column, row in occupied)
    bottom = max(row for _column, row in occupied)

    sprite = Image.new("RGBA", (right - left + 1, bottom - top + 1), (0, 0, 0, 0))
    for (column, row), colour in cells.items():
        if colour != CELL_BACKGROUND:
            sprite.putpixel((column - left, row - top), (*colour, 255))
    return sprite


def put_view_in_frame(sprite: Image.Image, *, mirror: bool = False) -> Image.Image:
    """Place a source view on the fixed 32-by-64 transparent animation canvas."""
    if mirror:
        sprite = sprite.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    frame = Image.new("RGBA", (FRAME_WIDTH, FRAME_HEIGHT), (0, 0, 0, 0))
    x = (FRAME_WIDTH - sprite.width) // 2
    frame.alpha_composite(sprite, (x, FRAME_ORIGIN[1]))
    return frame


def draw_legs(frame: Image.Image, left_step: int, right_step: int) -> None:
    """Draw two short trouser legs and boots in opposite steps on the pixel grid."""
    draw = ImageDraw.Draw(frame)
    transparent = (0, 0, 0, 0)
    outline = (34, 34, 34, 255)
    trouser = (51, 51, 51, 255)
    trouser_shadow = (34, 34, 34, 255)
    leather = (72, 45, 29, 255)
    boot = (125, 68, 50, 255)
    boot_highlight = (180, 110, 73, 255)

    # Replace the merged lower-body pixels with two alternating legs.
    draw.rectangle((8, 42, 23, 63), fill=transparent)

    for x1, x2, step in ((10, 16, left_step), (16, 22, right_step)):
        draw.polygon(
            [(x1, 42), (x2, 42), (x2, 48 + step), (x2 - 1, 51 + step),
             (x1, 51 + step), (x1 - 1, 48 + step)],
            fill=outline,
        )
        draw.polygon(
            [(x1 + 1, 43), (x2 - 2, 43), (x2 - 2, 48 + step),
             (x2 - 3, 50 + step), (x1 + 1, 49 + step)],
            fill=trouser,
        )
        draw.line((x1 + 4, 44, x1 + 4, 49 + step), fill=trouser_shadow)

        top = 50 + step
        shoe_left = x1 - 1
        shoe_right = x2 - 1
        draw.polygon(
            [(shoe_left + 1, top), (shoe_right - 1, top),
             (shoe_right, top + 2), (shoe_right - 1, top + 5),
             (shoe_left + 1, top + 5), (shoe_left, top + 3)],
            fill=outline,
        )
        draw.polygon(
            [(shoe_left + 1, top + 1), (shoe_right - 2, top + 1),
             (shoe_right - 1, top + 3), (shoe_left + 1, top + 4)],
            fill=leather,
        )
        draw.line((shoe_left + 2, top + 2, shoe_left + 3, top + 2), fill=boot_highlight)
        draw.point((shoe_right - 2, top + 4), fill=boot)


def make_frames(
    sprite: Image.Image,
    *,
    mirror: bool = False,
) -> list[Image.Image]:
    """Make a three-frame walk with alternating legs and the original face artwork."""
    base = put_view_in_frame(sprite, mirror=mirror)
    poses = ((-2, 2), (0, 0), (2, -2))
    frames = []
    for left_step, right_step in poses:
        frame = base.copy()
        draw_legs(frame, left_step, right_step)
        frames.append(frame)
    return frames


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("screenshot", type=Path, help="the pixel-editor screenshot with both character views")
    parser.add_argument("--output", type=Path, default=Path(__file__).resolve().parents[1] / "assets" / "character")
    args = parser.parse_args()

    screenshot = Image.open(args.screenshot).convert("RGB")
    args.output.mkdir(parents=True, exist_ok=True)

    front = extract_view(screenshot, range(8, 42), range(4, 62))
    three_quarter = extract_view(screenshot, range(60, 94), range(4, 62))

    directions = {
        "down": make_frames(front),
        "up": make_frames(front, mirror=True),
        "right": make_frames(front),
        "left": make_frames(front, mirror=True),
    }

    sheet = Image.new("RGBA", (FRAME_WIDTH * 3, FRAME_HEIGHT * 4), (0, 0, 0, 0))
    for row, direction in enumerate(("down", "left", "right", "up")):
        for column, frame in enumerate(directions[direction]):
            filename = args.output / f"walk_{direction}_{column + 1}.png"
            frame.save(filename)
            sheet.alpha_composite(frame, (column * FRAME_WIDTH, row * FRAME_HEIGHT))

    sheet.save(args.output / "character_walk_sheet.png")

    # Keep the two extracted source poses available as clean, transparent PNGs.
    source_views = Image.new("RGBA", (front.width + three_quarter.width + 8, max(front.height, three_quarter.height)), (0, 0, 0, 0))
    source_views.alpha_composite(front, (0, 0))
    source_views.alpha_composite(three_quarter, (front.width + 8, 0))
    source_views.save(args.output / "character_source_views.png")


if __name__ == "__main__":
    main()
