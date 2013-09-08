(setenv "HOME" "D:/Program Files/emacs-24.3/")
;;(setenv "PATH" "D:/Program Files/emacs-24.3/")
;; set the default file path
(setq default-diretory "~/")
(add-to-list 'load-path "~/.emacs.d")
(require 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("d:/Program Files/emacs-24.3/projects/task.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
