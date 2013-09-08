;; (setq eval-expression-debug-on-error nil)
(setq initial-scratch-message nil)
(require 'macrostep)

(add-hook 'emacs-lisp-mode-hook
		  (lambda ()
            (auto-complete-mode t)
            (electric-pair-mode t)
            (define-key emacs-lisp-mode-map (kbd "C-c C-e") 'macrostep-expand)
			(eldoc-mode)))

(add-hook 'lisp-interaction-mode
          (lambda ()
            (define-key lisp-interaction-mode-map (kdb "C-c C-e") 'macrostep-expand)))

(require 'elisp-slime-nav) ;; optional if installed via package.el
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook lisp-interaction-mode))
  (add-hook hook 'elisp-slime-nav-mode))

(provide 'init-elisp)
