# Specter
Roblox Specter Hacks.

Edit the individual files under `src/client`; `full_code.lua` is generated.
Build the bundle from any working directory with Python 3:

```powershell
python .\compile.py
```

The default build removes comments and excess whitespace while preserving string
contents. Shared modules are bundled as functions, avoiding a second compilation
when loaded. Optional game integrations, developer tools, and scripts remain
source strings so unused code is not compiled at startup. Module initialization
is still lazy and results are cached.

Keep the output readable, with original comments, formatting, and module labels:

```powershell
python .\compile.py --clean --verify
```

`--verify` checks the bundle and every embedded module with the official
`luau-compile` before replacing the existing output. Set `LUAU_COMPILE` to its
executable, install it on PATH, or place it in `.tools/luau/luau-compile.exe`.
`--source-bundle` retains the original source-string bundling behavior.

The build sorts modules for reproducible output, validates the entry-point
placeholder, and replaces the bundle only after it has been written successfully.
The compactor scans code spans with regular expressions rather than visiting
every character in Python. A 10-run rendering comparison improved from 219 ms
to 70 ms. Compact and clean builds use the same module-loading behavior.

Run regression checks from the repository root:

```powershell
python -m unittest discover -s tests -v
```

Luau runtime checks require the official Luau CLI. Set the `LUAU` environment
variable to `luau.exe`, or place it at `.tools/luau/luau.exe`. Without it, runtime
checks are reported as skipped; Python build checks still run. Validation here
uses Luau 0.742. The tools and Python caches are ignored by Git.

The regression suite executes isolated source sections and a small Roblox
data-model mock. It checks serialization, module loading, profile changes,
event replay, keybindings, cleanup, camera listeners, and bundle source integrity.
It does not replace live Roblox Studio testing of UI, respawns, or game behavior.
The suite also compares compiler instruction listings and constants for every
original and compacted module, with debug metadata disabled.

Reproduce the performance comparison with:

```powershell
python tests/benchmark_bundle.py
```

The loader avoids building remote URLs and assertion messages on successful
preloaded loads. When module logging is disabled, it skips display-name decoding
and log-message formatting. It retains timing and rechecks logging after
initialization, so a module can enable logging while it loads.

On this machine, the latest 30-run medians for 100,000 uncached dispatches improved
from 284.75 ms to 23.55 ms (12.09x), compared with the frozen pre-optimization
loader in `tests/loader_baseline.luau`. This isolates loader overhead: the module
body is already initialized and the public result cache is cleared each time.
It does not measure Roblox startup or gameplay.

Bundle parsing, registry creation, and compilation of normal startup modules
measured 28.73 ms for legacy strings versus 26.63 ms for the current bundle.
Output is about 622 KB versus 891 KB (30% smaller). Loading only core modules
remains slower (22.77 ms versus 29.61 ms), because shared categories are compiled
up front. Compiling all modules measured 51.15 ms versus 49.81 ms. A steady-state
table comparison showed no meaningful improvement. These isolated CLI
measurements do not establish higher Roblox FPS or faster gameplay.
