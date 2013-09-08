;; -*- coding: utf-8 -*-
;; (setq server-use-tcp t)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))

;; theme setting
(require 'color-theme)
(color-theme-initialize)
(color-theme-lethe)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (dot . t)
   (plantuml . t)
   ))
(setq org-plantuml-jar-path
      (expand-file-name "D:/Program Files/emacs-24.3/.emacs.d/plugins/plantuml.jar"))


;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *spell-check-support-enabled* nil)
(setq *is-mac* (eq system-type 'darwin))
(setq *is-windows* (eq system-type 'windows-nt))
(setq *is-linux* (eq system-type 'gnu/linux))

(require 'plantuml-mode)
(require 'ob-plantuml)
(require 'init-utils) ; convenient utils funcs missing from EMACS

(require 'init-fonts)                   ; fonts according OS
(require 'init-frame)                   ; Graphic interface settings
(require 'init-window)                  ; window move & split
(require 'init-exec-path)               ; Set up $exec-path
(require 'init-isearch)
(require 'init-scroll-lock)
(require 'init-tramp)                   ; NB!!

;; package download alone put in ~/.emacs.d/site-lisp/ dir download
;; from internet
(require 'init-site-lisp)               ; add ~/.emacs.d/site-lisp load-path

;; (require 'init-slime)

;; package from ELPA
(require 'init-elpa)
(require 'init-auto-complete)
(require 'init-ido)
(require 'init-org)
;; (require 'init-theme)
(require 'init-dired)

(require 'init-editing-utils)           ; global settings
(require 'init-hippie-expand)
(require 'init-cua-mode)
(require 'init-git)

;; (require 'init-python)
(require 'init-elisp)

(require 'init-key-binding)             ; key bindings goes after all package being loaded first

(require 'server)
(unless (server-running-p)
  (server-start))
(provide 'init)
