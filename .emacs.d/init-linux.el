(require 'kconfig-mode)

;;(add-to-list 'auto-mode-alist '("Kbuild" . makefile-mode))
(add-to-list 'auto-mode-alist '("Kbuild\\.?.*$" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\.?.pro$" . makefile-mode))
(add-to-list 'auto-mode-alist '("Makefile\\.?.*$" . makefile-mode))

(provide 'init-linux)
