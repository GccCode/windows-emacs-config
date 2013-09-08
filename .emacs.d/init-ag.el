(require 'ag)

(setq ag-highlight-search t)

(global-set-key (kbd "<f1>") 'ag-project-at-point)
(global-set-key (kbd "<f4>") 'ag-regexp-project-at-point)

(provide 'init-ag)
