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
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
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

;; Dump custom stuff outside of init.el!
(setq custom-file 
  (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(provide 'init)
;;; init.el ends here