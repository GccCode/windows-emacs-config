(add-hook 'term-mode-hook
          (lambda ()
            (progn
              (linum-mode -1)
              (setq show-trailing-whitespace nil))))

(provide 'init-term-mode)
