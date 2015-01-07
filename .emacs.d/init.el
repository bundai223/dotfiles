;; emacs directory
(when load-file-name
    (setq user-emacs-directory (file-name-directory load-file-name)))

;; package management
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; initialize
(package-initialize)

(defun package-install-with-refresh (package)
    (unless (assq package package-alist)
          (package-refresh-contents))
      (unless (package-installed-p package)
            (package-install package)))

;; install evil
(package-install-with-refresh 'evil)
(package-install-with-refresh 'powerline)

;; enable evil
(require 'evil)
(evil-mode 1)

(require 'powerline)
(powerline-default-theme)
