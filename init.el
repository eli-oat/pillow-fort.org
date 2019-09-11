;;; init.el --- Emacs init file
;;  Author: Eli Mellen
;;; Commentary:
;;; A lightweight Emacs config containing only the stuff I know how to use!
;;; Code:
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      file-name-handler-alist-original file-name-handler-alist
      file-name-handler-alist nil
      site-run-file nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 20000000
                  gc-cons-percentage 0.1
                  file-name-handler-alist file-name-handler-alist-original)
            (makunbound 'file-name-handler-alist-original)))

(add-hook 'minibuffer-setup-hook (lambda () (setq gc-cons-threshold 40000000)))
(add-hook 'minibuffer-exit-hook (lambda ()
                                  (garbage-collect)
                                  (setq gc-cons-threshold 20000000)))

(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; workaround bug in Emacs 26.2
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Setting up the package manager. Install if missing.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t))

;; Load main config file "./pillow-fort.org"
(require 'org)
(org-babel-load-file (expand-file-name "~/.emacs.d/pillow-fort.org"))

;; Load custom stuff if available
(when (file-exists-p "~/.emacs.d/blanket-fort.el")
(load "~/.emacs.d/blanket-fort.el"))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (tide prettier-js js2-mode json-mode web-mode elisp-format package-lint markdown-mode wispjs-mode cider clojure-mode ob-restclient restclient org-bullets golden-ratio flycheck aggressive-indent browse-kill-ring undo-tree hl-todo git-gutter magit nyan-mode rainbow-identifiers rainbow-delimiters company which-key helm use-package slime))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-done ((t (:foreground "#5DA7AA" :weight normal :strike-through t))))
 '(org-headline-done ((((class color) (min-colors 16) (background light)) (:foreground "#5E81AC" :strike-through t)))))
