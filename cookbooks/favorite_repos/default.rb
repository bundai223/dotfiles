include_cookbook 'dotfiles'
include_cookbook 'ghq'

repos = %w[
  dylanaraps/neofetch
  mzyy94/RictyDiminished-for-Powerline
  rupa/z
  yuru7/HackGen
  zsh-users/zsh-completions
  zplug/zplug
  zk-phi/sky-color-clock
]
repos.each { |name| get_repo name }

pip_pkgs = %w[
  powerline-status
  powerline-gitstatus
  python-language-server
]
%w[pip pip3].each do |pip|
  pip_pkgs.each do |pkg|
    execute ". /etc/profile.d/asdf.sh; #{pip} install #{pkg}" do
      user node[:user]
      only_if ". /etc/profile.d/asdf.sh; which #{pip}>/dev/null"
    end
  end
end

package 'fontforge'
