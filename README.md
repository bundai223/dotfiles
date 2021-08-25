dotfiles
========
mydotfiles

## How to install

### Linux

```sh
curl https://raw.githubusercontent.com/bundai223/dotfiles/main/install | bash -s
```

### For Windows

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb https://raw.githubusercontent.com/bundai223/dotfiles/main/install.ps1 | iex
```

## For Developer.

### Windows install script is old. Is `install.ps1` cached?

Yes. Try to use this scripts.

```powershell
iwr -Headers @{"Cache-Control"="no-cache"} -useb https://raw.githubusercontent.com/bundai223/dotfiles/main/install.ps1 | iex
```
