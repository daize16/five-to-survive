# Character animation assets

`character_walk_sheet.png` is a transparent 3-column by 4-row sheet. Each frame is 32×64 pixels. Rows are ordered `down`, `left`, `right`, `up`, matching the animation names in `player.tscn`.

The individual `walk_<direction>_<frame>.png` files are the same frames as the sheet. `character_source_views.png` contains the two views from the screenshot with the editor grid removed.

The screenshot contained a front view and a three-quarter view, but no back-facing drawing. All directions use the original front view, mirrored for left and up, so the face keeps its original eye design. The three-frame walks use alternating leg poses. The sprite sheet keeps its original 32×64 frame size and renders at 1:1 with nearest-neighbour filtering. Colors are sampled from the screenshot; no smoothing or antialiasing is added.

To rebuild the PNGs from the original screenshot, run:

```sh
python3 tools/build_character_sprites.py "/path/to/Screenshot 2026-11-17 at 15.47.45.png"
```

The rebuild script uses Pillow (`python3 -m pip install Pillow`).
