from importlib.util import find_spec
from pathlib import Path

from IPython import get_ipython  # type: ignore
import matplotlib as mpl
import matplotlib.pyplot as plt


def apply_scienceplots_style() -> None:
    spec = find_spec("scienceplots")
    if spec is None or spec.submodule_search_locations is None:
        return

    styles_dir = Path(next(iter(spec.submodule_search_locations))) / "styles"
    styles = [
        styles_dir / "science.mplstyle",
        styles_dir / "journals" / "ieee.mplstyle",
        styles_dir / "misc" / "no-latex.mplstyle",
    ]
    if all(style.is_file() for style in styles):
        plt.style.use([str(style) for style in styles])


def use_preferred_font() -> None:
    try:
        from mplfonts import use_font
    except ModuleNotFoundError:
        return

    use_font("Noto Serif CJK SC")


apply_scienceplots_style()
use_preferred_font()
mpl.use("pgf")
params = {"figure.dpi": 100, "savefig.transparent": True}
plt.rcParams.update(params)
ipython = get_ipython()

if ipython is not None:
    ipython.run_line_magic("load_ext", "autoreload")
    ipython.run_line_magic("autoreload", "1")
    ipython.run_line_magic("matplotlib", "inline")

del (
    Path,
    apply_scienceplots_style,
    find_spec,
    get_ipython,
    ipython,
    mpl,
    use_preferred_font,
)
