;; emacs directory
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;;; package.el
(require 'package)
;; パッケージリポジトリに追加
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;; インストールしたパッケージにロードパスを通してロードする
(package-initialize)

;; init-loader
(when (require 'init-loader)
  (defun init-loader-re-load (re dir &optional sort)
    (let ((load-path (cons dir load-path)))
      (dolist (el (init-loader--re-load-files re dir sort))
        (condition-case e
                        (let ((time (car (benchmark-run (load (file-name-sans-extension el))))))
                          (init-loader-log (format "loaded %s. %s" (locate-library el) time)))
                        (error
                          (init-loader-error-log (format "%s. %s" (locate-library el) (error-message-string e)))
                          )))))

  (init-loader-load "~/.emacs.d/inits")) ; 設定ファイルがあるディレクトリをまとめて読み込み



