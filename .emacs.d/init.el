;; emacs directory
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;;; package.el
(when (require 'package nil t)
  ;; パッケージリポジトリに追加
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通してロードする
  (package-initialize)

  ;; package install
  (defun package-install-with-refresh (package)
    (unless (assq package package-alist)
      (package-refresh-contents))
    (unless (package-installed-p package)
      (package-install package)))

  (package-install-with-refresh 'evil)
  (package-install-with-refresh 'helm)
  (package-install-with-refresh 'helm-ag)
  (package-install-with-refresh 'helm-descbinds)
  (package-install-with-refresh 'helm-migemo)
  (package-install-with-refresh 'powerline)
  (package-install-with-refresh 'powerline-evil)
  (package-install-with-refresh 'auto-complete))


;; enable evil
(require 'evil)
(evil-mode 1)

;; helm
(require 'helm)
(require 'helm-config)
(require 'helm-ag)
(require 'helm-descbinds)
(require 'cl) ; for helm-migemo
(require 'helm-migemo)

(helm-descbinds-mode)
(setq helm-use-migemo t)

(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-c b") 'helm-descbinds)
(global-set-key (kbd "C-c o") 'helm-occur)
(global-set-key (kbd "C-c g") 'helm-ag)
(global-set-key (kbd "C-c y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c r") 'helm-resume)
(global-set-key (kbd "C-c f") 'helm-for-files)
(global-set-key (kbd "C-c m") 'helm-migemo)

;; power line
(require 'powerline)
(require 'powerline-evil)
(powerline-default-theme)
(powerline-evil-vim-color-theme)

;; auto complete
(require 'auto-complete-config)
(ac-config-default)

;; color theme setting
(load-theme 'misterioso t)

;;; MetaキーをOptionキーに設定
(when (eq system-type 'darwin)
  (setq mac-command-key-is-meta nil)
  (setq mac-option-modifier 'meta))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI
;; メニューバーを非表示
(menu-bar-mode 0)
;; ツールバーを非表示
(tool-bar-mode 0)

(custom-set-variables
  '(global-linum-mode t)
  '(initial-frame-alist (quote ((top . 0) (left . 600) (width . 250) (height . 100))))
  )

(set-frame-font "Ricty 14")

