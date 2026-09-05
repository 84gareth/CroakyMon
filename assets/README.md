# CroakyMon 3D Models

Drop Meshy `.glb` exports in here, one per species. The game auto-loads any it finds and falls back to polygon art for any it doesn't.

Expected filenames (case-sensitive):
- `crimson-fungus.glb` — fire starter (Crimson Fungus)
- `vinehop.glb` — grass starter (sprout turtle) — optional
- `tidefrog.glb` — water starter (ink squid) — optional
- `bolttoad.glb` — electric wild-only (lightning bird) — optional

To add more species, edit the `Mon3D.CONFIG` map in `croakymon.html`.

## How to export from Meshy
1. Open the textured model in the Meshy viewer.
2. Tap the green **download** button (bottom right of the viewer action bar).
3. Choose format **GLB** (or glTF binary). Include textures.
4. Rename the file to the exact species name above and drop it in this folder.

## How to play locally
`.glb` files can't be loaded from a `file://` path — the browser blocks it. Run a tiny local server from the folder that contains `croakymon.html`:

```
python3 -m http.server 8000
```

Then open http://localhost:8000/croakymon.html in the browser.

## How to host for the tablet
Push the whole folder (including `assets/`) to `84gareth.github.io` as usual — GitHub Pages serves everything over HTTPS, so the `.glb` loads fine on the iPad.
