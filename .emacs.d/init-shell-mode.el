(add-hook 'shell-mode-hook
          (lambda ()
            (progn
              ;; disable
               (setq show-trailing-whitespace nil))))


(provide 'init-shell-mode)
