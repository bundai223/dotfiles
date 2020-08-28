;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(python
     windows-scripts
     sql
     php
     csv
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     auto-completion
     better-defaults
     chrome
     emacs-lisp
     dap
     docker
     git
     ;; ghq
     (gtags :variables gtags-enable-by-default t)
     html
     (ivy :variables ivy-enable-advanced-buffer-information t)
     japanese
     javascript
     lsp
     markdown
     multiple-cursors
     org
     rust
     (ruby :variables
           ruby-enable-ruby-on-rails-support t
           ruby-enable-enh-ruby-mode t
           )
     (shell :variables
            shell-default-shell 'multi-term
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-term-shell "/bin/bash"
            multi-term-program "/bin/bash")
     shell-scripts
     ;; spell-checking
     syntax-checking
     ;; tabbar
     treemacs
     twitter
     (typescript :variables typescript-fmt-on-save t)
     (version-control :variables version-control-diff-side 'left)
     yaml
   )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages
   '(
     all-the-icons
     all-the-icons-ivy
     all-the-icons-dired
     beacon
     blgrep
     clmemo
     elscreen
     evil-tabs
     flymake
     minimap
     quickrun
     undohist
     vue-mode
     )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default spacemacs-27.1.pdmp)
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("HackGen35Nerd Console"
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers `relative
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup `nil

   ;; If non nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfer with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  (add-to-list 'exec-path "~/.asdf/shims/")
  (add-to-list 'exec-path "~/.asdf/bin/")

  ;; for vcxsrv on windows
  (add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

  ;; basic setting
  (setq tags-revert-without-query 1)  ; TAGS reload automatically when TAGS updated.
  (setq vc-follow-symlinks t)         ; automatically follow symlink

  (defun setup-indent (n)
    ;; java/c/c++
    (setq c-basic-offset n)
    ;; web development
    (setq coffee-tab-width n)              ; coffeescript
    (setq javascript-indent-level n)       ; javascript-mode
    (setq js-indent-level n)               ; js-mode
    (setq js2-basic-offset n)              ; js2-mode, in latest js2-mode, it's alias of js-indent-level
    (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
    (setq web-mode-css-indent-offset n)    ; web-mode, css in html file
    (setq web-mode-code-indent-offset n)   ; web-mode, js code in html file
    (setq css-indent-offset n)             ; css-mode
    (setq typescript-indent-level n)       ; typescript
    )
  (setq-default indent-tabs-mode nil)      ; set expandtab
  (setq tab-width 2)                       ; set tabwidth=4
  (setup-indent 2)                         ; set tabwidth=4

  ;; tab
  (require 'evil-tabs)
  (global-evil-tabs-mode t)

  (define-key evil-normal-state-map (kbd "tn") 'elscreen-create)
  (define-key evil-normal-state-map (kbd "tc") 'elscreen-kill)

  ;; completion
  (define-key evil-insert-state-map (kbd "C-n") 'company-select-next-if-tooltip-visible-or-complete-selection)
  (define-key evil-insert-state-map (kbd "C-p") 'company-select-previous)

  (setq locale-coding-system 'utf-8)
  ;; set font HackGen53
  (set-fontset-font
   nil 'japanese-jisx0208
   (font-spec :family "HackGen35Nerd Console"))
  ;; (setq powerline-default-separator 'arrow)
  ;; (set-fontset-font t 'symbol (font-spec :name "Noto Color Emoji")) ;; fallback font
  ;; (set-face-attribute 'mode-line nil :family "Noto Color Emoji")
  (set-fontset-font "fontset-default" nil (font-spec :family "Noto Color Emoji"))

  ;; all-the-icon
  (use-package all-the-icons-ivy
    :ensure t
    :config
    (all-the-icons-ivy-setup)
    )
  (use-package all-the-icons-dired
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
    )

  ;; sky-color-clock
  (use-package sky-color-clock
    :load-path "~/repos/github.com/zk-phi/sky-color-clock"
    :config
      (sky-color-clock-initialize 35)
      (sky-color-clock-initialize-openweathermap-client "fcc2b1ff22bf1eda5821034a037383ab" 1850144)
      (setq sky-color-clock-format "%k:%M")
      (setq sky-color-clock-enable-emoji-icon t)
      ; (push '(:eval (sky-color-clock)) (default-value 'mode-line-format))
      (add-to-list 'global-mode-string '(:eval (sky-color-clock)))
      (display-time-mode -1)
    )

  ;; requirement: win32yank (https://github.com/equalsraf/win32yank)
  ;; (when (and (executable-find "uname")
  ;;           (executable-find "win32yank.exe")
  ;;           (string-match-p "Microsoft"
  ;;                           (shell-command-to-string "uname -r")))
  ;;   (setq interprogram-paste-function
  ;;         (lambda ()
  ;;           (replace-regexp-in-string
  ;;           "\r" "" (shell-command-to-string "win32yank.exe -o"))))
  ;;   (setq interprogram-cut-function
  ;;         (lambda (text &optional rest)
  ;;           (let* ((process-connection-type nil)
  ;;                 (proc (start-process
  ;;                         "win32yank-cut" "*Messages*" "win32yank.exe" "-i")))
  ;;             (process-send-string proc text)
  ;;             (process-send-eof proc)))))

  (autoload 'clmemo "clmemo" "ChangeLog memo mode." t)
  (setq user-full-name "bundai223")
  (setq user-mail-address "bundai223@gmail.com")
  (setq clmemo-file-name "~/repos/gitlab.com/bundai223/private-memo/ChangeLog")
  (setq clmemo-time-string-with-weekday t) ;; 曜日付ける
  (global-set-key "\C-xM" 'clmemo)
  (setq clmemo-title-list '(
          "memo"
          "dialy"
          "bookmark"
          "dev"
          ("word" . "格言")
          "idea"
          ("buy". "購入")
          ("will_buy" . "購入予定")
          "game"
          "learn"
          "linux" "windows" "macos"
          "android" "ios"
          "ruby"
          "rust"
          "devops"
          "frontend" "backend"
          "rails" "nodejs" "rust" "ruby" "javascript" "typescript"
          "ml"
          "vim" "emacs" "neovim" "spacemacs" "vscode"
          ))

  (autoload 'clgrep "clgrep" "grep mode for ChangeLog file." t)
  (autoload 'clgrep-title "clgrep" "grep first line of entry in ChangeLog." t)
  (autoload 'clgrep-header "clgrep" "grep header line of ChangeLog." t)
  (autoload 'clgrep-other-window "clgrep" "clgrep in other window." t)
  (autoload 'clgrep-clmemo "clgrep" "clgrep directly ChangeLog MEMO." t)
  (add-hook 'change-log-mode-hook
            '(lambda ()
               (define-key change-log-mode-map "\C-c\C-g" 'clgrep)
               (define-key change-log-mode-map "\C-c\C-t" 'clgrep-title)))

  ;; ruby
  (setq ruby-insert-encoding-magic-comment nil)

  ;; Vue.js
  (require 'vue-mode)
  (add-to-list 'vue-mode-hook #'smartparens-mode)

  (use-package helm-lsp :commands helm-lsp-workspace-symbol)
  (use-package lsp-treemacs :commands lsp-treemacs-errors-list)
  ;; optionally if you want to use debugger
  ;; (use-package dap-mode)

  ;; multi-term
  (use-package multi-term)

  ;; 括弧みやすく色付け
  (use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))

  ;; ペーストしたときの色付け
  (use-package volatile-highlights
    :diminish
    :hook (after-init . volatile-highlights-mode)
    )

  ;; cursor 位置みやすく
  (use-package beacon
    :custom (beacon-color "yellow")
    :config (beacon-mode 1))

  (use-package git-gutter+
    :custom
    (git-gutter+-modified-sign "~")
    (git-gutter+-added-sign    "+")
    (git-gutter+-deleted-sign  "-")
    :custom-face
    (git-gutter+-modified ((t (:background "#f1fa8c"))))
    (git-gutter+-added    ((t (:background "#50fa7b"))))
    (git-gutter+-deleted  ((t (:background "#ff79c6"))))
    )

  (use-package fill-column-indicator
    :hook
    ((markdown-mode
      git-commit-mode) . fci-mode))

  ;; minimap
  ;; toggle
  (use-package minimap
    :commands
    (minimap-bufname minimap-create minimap-kill)
    :custom
    (minimap-major-modes '(prog-mode))

    (minimap-window-location 'right)
    (minimap-update-delay 0.2)
    (minimap-minimum-width 20)
    :bind
    ;; ("M-t m" . ladicle/toggle-minimap)
    :preface
    (defun ladicle/toggle-minimap ()
      "Toggle minimap for current buffer."
      (interactive)
      (if (null minimap-bufname)
          (minimap-create)
        (minimap-kill)))
    :config
    (custom-set-faces
     '(minimap-active-region-background
       ((((background dark)) (:background "#555555555555"))
        (t (:background "#C847D8FEFFFF"))) :group 'minimap)))

  (use-package ddskk
    :init
    (add-hook 'text-mode-hook 'skk-mode)
    :defer t
    :config
    (setq skk-server-prog "$ASDF_DIR/shims/google-ime-skk") ; google-ime-skkの場所
    (setq skk-server-inhibit-startup-server nil) ; 辞書サーバが起動していなかったときに Emacs からプロセスを立ち上げる
    (setq skk-server-host "localhost") ; サーバー機能を利用
    (setq skk-server-portnum 55100)     ; ポートはgoogle-ime-skk
    (setq skk-share-private-jisyo t)   ; 複数skk辞書を共有 akdfjakdfはおだ
    )

  ;;半角全角間の自動スペース
  (use-package pangu-spacing
    :config
    (setq pangu-spacing-real-insert-separtor nil)
    )

  (use-package magit
    :config
    (setq magit-repository-directories
          '(
            ("~/repos/" . 6)
            ("~/work/" . 6)
          )
    )
    (with-eval-after-load 'projectile
      (when (require 'magit nil t)
        (mapc #'projectile-add-known-project
              (mapcar #'file-name-as-directory (magit-list-repos)))
        ;; Optionally write to persistent `projectile-known-projects-file'
        (projectile-save-known-projects)))
    )
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (tern yapfify yaml-mode xterm-color ws-butler winum which-key wgrep web-mode web-beautify vue-mode edit-indirect ssass-mode vue-html-mode volatile-highlights vi-tilde-fringe uuidgen use-package unfill undohist twittering-mode toml-mode toc-org tide typescript-mode tagedit sql-indent spaceline powerline smex smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe restart-emacs request rbenv rake rainbow-delimiters racer quickrun pyvenv pytest pyenv-mode py-isort pug-mode powershell popwin pip-requirements phpunit phpcbf php-extras php-auto-yasnippets persp-mode pcre2el paradox spinner orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-plus-contrib org-mime org-download org-bullets open-junk-file neotree mwim multi-term move-text mmm-mode minitest minimap markdown-toc magit-gitflow magit-popup macrostep lorem-ipsum livid-mode skewer-mode simple-httpd live-py-mode linum-relative link-hint js2-refactor multiple-cursors js2-mode js-doc ivy-hydra insert-shebang indent-guide hydra lv hy-mode dash-functional hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-make haml-mode google-translate golden-ratio gnuplot gmail-message-mode ham-mode html-to-markdown gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md ggtags fuzzy flymd flycheck-rust flycheck-pos-tip pos-tip flycheck flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-tabs evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu eshell-z eshell-prompt-extras esh-help enh-ruby-mode emmet-mode elscreen elisp-slime-nav edit-server dumb-jump drupal-mode php-mode dockerfile-mode docker transient tablist json-mode docker-tramp json-snatcher json-reformat diminish diff-hl define-word cython-mode csv-mode counsel-projectile projectile pkg-info epl counsel swiper company-web web-completion-data company-statistics company-shell company-anaconda company column-enforce-mode coffee-mode clean-aindent-mode chruby cargo markdown-mode rust-mode bundler inf-ruby blgrep clmemo bind-map bind-key beacon auto-yasnippet yasnippet auto-highlight-symbol auto-compile packed async anaconda-mode pythonic f dash s all-the-icons-ivy ivy all-the-icons-dired all-the-icons memoize aggressive-indent adaptive-wrap ace-window ace-link avy ac-ispell auto-complete popup)))
 '(safe-local-variable-values
   (quote
    ((clmemo-mode . t)
     (typescript-backend . tide)
     (typescript-backend . lsp)
     (javascript-backend . tide)
     (javascript-backend . tern)
     (javascript-backend . lsp)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-gutter+-added ((t (:background "#50fa7b"))))
 '(git-gutter+-deleted ((t (:background "#ff79c6"))))
 '(git-gutter+-modified ((t (:background "#f1fa8c")))))
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yapfify yaml-mode xterm-color ws-butler winum which-key wgrep web-mode web-beautify vue-mode edit-indirect ssass-mode vue-html-mode volatile-highlights vi-tilde-fringe uuidgen use-package unfill undohist twittering-mode toml-mode toc-org tide typescript-mode tagedit sql-indent spaceline powerline smex smeargle slim-mode shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe restart-emacs request rbenv rake rainbow-delimiters racer quickrun pyvenv pytest pyenv-mode py-isort pug-mode powershell popwin pip-requirements phpunit phpcbf php-extras php-auto-yasnippets persp-mode pcre2el paradox spinner orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-plus-contrib org-mime org-download org-bullets open-junk-file neotree mwim multi-term move-text mmm-mode minitest minimap markdown-toc magit-gitflow magit-popup macrostep lorem-ipsum livid-mode skewer-mode simple-httpd live-py-mode linum-relative link-hint js2-refactor multiple-cursors js2-mode js-doc ivy-hydra insert-shebang indent-guide hydra lv hy-mode dash-functional hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-make haml-mode google-translate golden-ratio gnuplot gmail-message-mode ham-mode html-to-markdown gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gh-md ggtags fuzzy flymd flycheck-rust flycheck-pos-tip pos-tip flycheck flx-ido flx fish-mode fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-tabs evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu eshell-z eshell-prompt-extras esh-help enh-ruby-mode emmet-mode elscreen elisp-slime-nav edit-server dumb-jump drupal-mode php-mode dockerfile-mode docker transient tablist json-mode docker-tramp json-snatcher json-reformat diminish diff-hl define-word cython-mode csv-mode counsel-projectile projectile pkg-info epl counsel swiper company-web web-completion-data company-statistics company-shell company-anaconda company column-enforce-mode coffee-mode clean-aindent-mode chruby cargo markdown-mode rust-mode bundler inf-ruby blgrep clmemo bind-map bind-key beacon auto-yasnippet yasnippet auto-highlight-symbol auto-compile packed async anaconda-mode pythonic f dash s all-the-icons-ivy ivy all-the-icons-dired all-the-icons memoize aggressive-indent adaptive-wrap ace-window ace-link avy ac-ispell auto-complete popup))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
