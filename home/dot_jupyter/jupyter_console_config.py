# Auto connection file
from jupyter_core.paths import jupyter_runtime_dir
from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from traitlets.config.application import get_config


c = get_config()
index = 1
while (
    Path(jupyter_runtime_dir())
    / (file := f"kernel-{Path().absolute().name}-{index:02d}.json")
).is_file():
    index += 1
else:
    c.JupyterConsoleApp.connection_file = print(f"Connection {file}") or file

# Required for jupyter-vim
c.ZMQTerminalInteractiveShell.include_other_output = True

# Message for jupyter-vim
c.ZMQTerminalInteractiveShell.other_output_prefix = "[jupyter-vim]\n"

# Improve banner
c.ZMQTerminalInteractiveShell.banner = "Jupyter Console {version}\n{kernel_banner}"

# Syntax highlighting (try pygmentize -L styles)
c.ZMQTerminalInteractiveShell.highlighting_style = "monokai"

# Never confirm exit
c.JupyterConsoleApp.confirm_exit = False
