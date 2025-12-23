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
    c.JupyterConsoleApp.connection_file = print(f"Connection {file}") or file  # pyright: ignore #noqa: F821

# font setting
c.ConsoleWidget.font_family = "Sarasa Mono SC Nerd Font"
c.ConsoleWidget.font_size = 10
c.ConsoleWidget.paging = "vsplit"
c.JupyterWidget.kind = "rich"

# Display banner
c.JupyterQtConsoleApp.display_banner = False

# Display menubar
# c.JupyterQtConsoleApp.hide_menubar = True

# Syntax highlighting (try pygmentize -L styles)
c.JupyterWidget.syntax_style = "solarized-light"

# Output from other
c.ConsoleWidget.include_other_output = True
c.ConsoleWidget.other_output_prefix = "[Other]\n"

# Never confirm exit
c.JupyterConsoleApp.confirm_exit = False
c.JupyterWidget.editor = 'Alacritty.exe -e nvim "{filename}"'

# Buffer size control
c.ConsoleWidget.buffer_size = 10000

## The visibility of the scrollar.
c.ConsoleWidget.scrollbar_visibility = False

c.JupyterWidget.enable_calltips = False
