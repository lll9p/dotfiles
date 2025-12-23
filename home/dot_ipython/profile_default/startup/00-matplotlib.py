from IPython import get_ipython  # type: ignore
import matplotlib as mpl
import matplotlib.pyplot as plt
import scienceplots  # noqa: F401
from mplfonts import use_font

use_font("Noto Serif CJK SC")
plt.style.use(["science", "ieee", "no-latex"])
mpl.use("pgf")
params = {"figure.dpi": 100, "savefig.transparent": True}
plt.rcParams.update(params)
ipython = get_ipython()

ipython.run_line_magic("load_ext", "autoreload")  # type: ignore
ipython.run_line_magic("autoreload", "1")  # type: ignore
ipython.run_line_magic("matplotlib", "inline")  # type: ignore

del mpl, use_font, get_ipython, ipython
