
(require 'cua-base)

(setq-default cua-enable-cua-keys nil)

(cua-mode)

(global-set-key (kbd "M-RET") 'cua-set-rectangle-mark)

(provide 'init-cua-mode)
