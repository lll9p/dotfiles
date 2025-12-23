#--------------------------------  Import Module BEGIN  --------------------------------
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
#--------------------------------  Import Module END  ----------------------------------
# 设置控制台编码为UTF-8
[Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
#-------------------------------  Set Complitions BEGIN  -------------------------------
# 自动补全历史命令，逐字补全

if (($Host.Name -eq 'ConsoleHost') -or ($Env:TERM_PROGRAM -eq 'vscode'))
{
  Import-Module PSReadLine
  Import-Module CompletionPredictor
  # 设置预测文本来源为历史记录
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin

  # 菜单形显示
  Set-PSReadLineOption -PredictionViewStyle ListView

  # 每次回溯输入历史，光标定位于输入内容末尾
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  # vim 模式
  Set-PSReadLineOption -EditMode Vi

  # 设置 Tab 为菜单补全和 Intellisense
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

  # 设置 Ctrl+z 为撤销
  Set-PSReadLineKeyHandler -Key Ctrl+z -Function Undo

  # 设置向上键为后向搜索历史记录
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

  # 设置向下键为前向搜索历史纪录
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadLineKeyHandler -Chord 'Ctrl+d,s' -Function CaptureScreen
  Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
  #-------------------------------  Set Complitions END    -------------------------------
}

#-------------------------------  Functions BEGIN    -----------------------------------
# 更新系统组件
function Update-Packages
{
  # update pip
  Write-Host "Step 1: 更新 pip" -ForegroundColor Magenta -BackgroundColor Cyan
  $a = pip list --outdated
  $num_package = $a.Length - 2
  for ($i = 0; $i -lt $num_package; $i++)
  {
    $tmp = ($a[2 + $i].Split(" "))[0]
    python -m pip install -U $tmp
  }
  # update msys2
  Write-Host "Step 2: 更新 msys2" -ForegroundColor Magenta -BackgroundColor Cyan
  pacman -Syyu
  # update npm
  Write-Host "Step 3: 更新 npm" -ForegroundColor Magenta -BackgroundColor Cyan
  npm upgrade -g
}
# 编译函数 make
#function MakeThings
#{
#  nmake.exe $args -nologo
#}

# List things
function MsysList
{
  if (Test-Path Env:\MSYS64)
  {
    $Command = "$Env:MSYS64\usr\bin\ls.exe --color=tty --show-control-chars " + $args
    Invoke-Expression -Command $Command

  } else
  {
    Get-ChildItem -Path .
  }
}
#打开当前工作目录
function OpenFolder
{
  # 输入要打开的路径
  # 用法示例：open C:\
  # 默认路径：当前工作文件夹
  param ($Path = '.')
  Invoke-Item $Path
}

# 获取所有 Network Interface
function Get-AllNic
{
  Get-NetAdapter | Sort-Object -Property MacAddress
}

# 获取 IPv4 关键路由
function Get-IPv4Routes
{
  Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript { $_.NextHop -ne '0.0.0.0' }
}

# 获取 IPv6 关键路由
function Get-IPv6Routes
{
  Get-NetRoute -AddressFamily IPv6 | Where-Object -FilterScript { $_.NextHop -ne '::' }
}

function git_shallow_clone
{
  git clone --depth=1 --recursive $args
}
function git_shallow_fetch
{
  git fetch --depth=1 --recursive --recurse-submodules=yes
}

function sudo
{
  Start-Process -Verb RunAs -FilePath "pwsh" -ArgumentList (@("-NoExit", "-Command") + $args)
}

function Set-Proxy
{
  $env:all_proxy = "socks5://127.0.0.1:1081"
}
function UnSet-Proxy
{
  $env:all_proxy = ""
}
function Test-Cloudflare
{
  Push-Location
  Set-Location $Env:LOCALAPPDATA\Programs\CloudflareST
  .\cfst.exe
  # -url https://download.parallels.com/desktop/v15/15.1.5-47309/ParallelsDesktop-15.1.5-47309.dmg
  # .\CloudflareST.exe -dn 500 -dt 5 -url https://testfiles.blockly.cf/100mb.zip -httping
  Pop-Location
}
# Set MSVC Env
function Set-MSVC
{
  Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2026\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell 7da02bb5
  # $Env:OPENCV_LINK_LIBS = "opencv_world490"
  # $Env:OPENCV_LINK_PATHS = "$Env:LOCALAPPDATA\Programs\opencv\4.9\build\x64\vc16\lib"
  # $Env:OPENCV_INCLUDE_PATHS = "$Env:LOCALAPPDATA\Programs\opencv\4.9\build\include"
  # $Env:OPENCV_HEADER_DIR = "$Env:LOCALAPPDATA\Programs\opencv\4.9\build\include"
  # $Env:Path = "$Env:Path;$Env:LOCALAPPDATA\Programs\opencv\4.9\build\x64\vc16\bin"
  # Get it
  $path = $Env:Path
  $unwanted = ("$Env:MSYS64\mingw64", "$Env:MSYS64\mingw64\bin", "$Env:MSYS64\mingw64\lib",
    "$Env:MSYS64\include", "$Env:MSYS64\usr\bin", "$Env:MSYS64\lib")
  # Remove unwanted elements
  $path = ($path.Split(';') | Where-Object { $_ -notin $unwanted }) -join ';'
  $Env:Path = "$path;$Env:LOCALAPPDATA\Programs\LLVM\bin"
  Set-Item Env:\LIBCLANG_PATH -Value "$Env:LOCALAPPDATA\Programs\LLVM\lib"
  Remove-Item -Path Env:\MSYS64
  Remove-Item -Path Env:\MSYSTEM_PREFIX
  Remove-Item -Path Env:\MSYS2_PATH_TYPE
  Remove-Item -Path Env:\PKG_CONFIG_PATH

}
# Set MSYS2 Env
function Set-MSYS2
{
  Set-Item -Path Env:\MSYS64 -Value "$Env:LOCALAPPDATA\Programs\msys64"
  Set-Item -Path Env:\MSYSTEM_PREFIX -Value "$Env:MSYS64"
  Set-Item -Path Env:\MSYS2_PATH_TYPE -Value "inherit"
  Set-Item -Path Env:\PKG_CONFIG_PATH -Value "/mingw64/lib/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig:/lib/pkgconfig"
  $Env:Path = "$Env:Path;$Env:MSYS64\cmd;$Env:MSYS64\mingw64;$Env:MSYS64\mingw64\bin;$Env:MSYS64\mingw64\lib;$Env:MSYS64\include;$Env:MSYS64\usr\bin;$Env:MSYS64\lib"
}
# Python set venv
function SetV
{
  param(
    [string]
    $venv_name
  )
  $module = ""
  if ($venv_name -eq ".")
  {
    $module = "$PWD\.venv\Scripts\Activate.ps1"
  } else
  {
    $module = "$venv_dir\$venv_name\Scripts\Activate.ps1"
  }
  Import-Module -Name $module
}
# python venv auto completion
Register-ArgumentCompleter -CommandName SetV -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  Get-ChildItem -Path $venv_dir | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_.BaseName)
  }

}

# ssh hosts auto completion
Register-ArgumentCompleter -CommandName ssh -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $sshConfigFile = "~\.ssh\config"
  $sshConfigContent = Get-Content -Path $sshConfigFile -ErrorAction SilentlyContinue
  $pattern = "^Host\s+([\w|_|\.|\d|-]*)$"
  $sshConfigContent.ForEach({
      $matches = [Regex]::Matches($_.Trim(), $pattern)
      if ($matches.Success)
      {
        [System.Management.Automation.CompletionResult]::new($matches.Groups[1].Value)
      }
    })
}
# Prompt
function global:prompt
{
  #$venv_prefix = ""
  #if ($Env:VIRTUAL_ENV)
  #{
  #  $venv_prefix = Split-Path -Path $Env:VIRTUAL_ENV -Leaf
  #  Write-Host -NoNewline -ForegroundColor Green "(@$venv_prefix)"
  #}
  Write-Host -NoNewline "["
  Write-Host -NoNewline -ForegroundColor Green $(Get-Item $(Get-Location)).BaseName
  Write-Host -NoNewline "]"
  Write-Host -NoNewline "<"
  Write-Host -NoNewline -ForegroundColor Yellow $(Get-Date -Format "MM-dd HH:mm:ss")
  Write-Host ">"
  ">"
}
function OpenNvim
{
  Alacritty --command nvim $args
}
#-------------------------------  Functions END  ---------------------------------------


#-------------------------------  Set Alias BEGIN  -------------------------------------
Set-Alias -Name make -Value MakeThings
Set-Alias -Name os-update -Value Update-Packages
# Unset Alias `ls`
Remove-Item alias:\ls
Set-Alias -Name ls -Value MsysList
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name open -Value OpenFolder
# 获取所有 Network Interface
Set-Alias -Name getnic -Value Get-AllNic
# 获取 IPv4 关键路由
Set-Alias -Name getip -Value Get-IPv4Routes
# 获取 IPv6 关键路由
Set-Alias -Name getip6 -Value Get-IPv6Routes
Set-Alias z Search-NavigationHistory
Set-Alias -Name nvim -Value OpenNvim
#-------------------------------  Set Alias END  ---------------------------------------

$global:venv_dir = "$Env:LOCALAPPDATA\Programs\virtualenvs"
#$Env:VIRTUAL_ENV_DISABLE_PROMPT = 1
SetV work
$Env:RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup"
# Start gpg service
$gpg_pid = Get-Process -Name gpg-agent -ErrorAction SilentlyContinue
if (! $gpg_pid)
{
  Invoke-Command -Script {
    $ErrorActionPreference = "silentlycontinue"
    & gpg-connect-agent updatestartuptty /bye *>$null | Out-Null
  } -ErrorAction SilentlyContinue

}

(& uv generate-shell-completion powershell) | Out-String | Invoke-Expression
(& uvx --generate-shell-completion powershell) | Out-String | Invoke-Expression
