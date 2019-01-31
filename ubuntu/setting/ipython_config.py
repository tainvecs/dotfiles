

c = get_config()

c.TerminalIPythonApp.display_banner = True
c.InteractiveShellApp.log_level = 30
c.InteractiveShellApp.exec_files = []
c.InteractiveShellApp.extensions = []
c.InteractiveShell.confirm_exit = False
c.InteractiveShell.autoindent = True
c.InteractiveShell.colors = 'Linux' # 'NoColor'|'LightBG'|'Linux'
c.InteractiveShell.editor = 'vim'
c.InteractiveShell.xmode = 'Context'

c.AliasManager.user_aliases = [
    ('la', 'ls -aG')
]

#c.InteractiveShellApp.matplotlib = 'auto'
#c.InteractiveShellApp.exec_lines = [
#    'import numpy as np',
#    'import matplotlib.pyplot as plt'
#]
