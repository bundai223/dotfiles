dotfiles
========
mydotfiles
  
## How to install

### For Windows

```powershell
iwr -useb https://raw.githubusercontent.com/bundai223/dotfiles/master/install.ps1 | iex
```

### Others(Not Windows)

```sh
curl https://raw.githubusercontent.com/bundai223/dotfiles/master/install | bash -s
```

## For Developer.

### Windows install script is old. Is `install.ps1` cached?

Yes. Try to use this scripts.

```powershell
iwr -Headers @{"Cache-Control"="no-cache"} -useb https://raw.githubusercontent.com/bundai223/dotfiles/master/install.ps1 | iex
```
