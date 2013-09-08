(add-to-list 'load-path "/zhsa012/usrhome/glen.dai/.emacs.d/site-lisp/slime")
(setq inferior-lisp-program "/zhsa012/usrhome/glen.dai/local/bin/sbcl")
(require 'slime)
(slime-setup)

(add-hook 'comint-mode-hook
          (lambda ()
            (electric-pair-mode t)
            (setq show-trailing-whitespace nil)))

(provide 'init-slime)
