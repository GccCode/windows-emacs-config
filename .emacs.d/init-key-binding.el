;; region bind
(require 'region-bindings-mode)
(require 'init-utils)
(region-bindings-mode-enable)

(global-set-key [(meta N)] 'next-error)
(global-set-key [(meta P)] 'previous-error)
(global-set-key [(meta I)] 'compile)
(global-set-key [(control c) (control b)] 'bury-buffer)
(global-set-key [(control x) (control d)] 'ido-dired)

(global-set-key (kbd "C-c +") 'increment-number-at-point)

(require 'hide-region)
(global-set-key (kbd "C-c C-r") 'hide-region-toggle)
(global-set-key (kbd "C-c C-M-r") 'hide-region-show-all)

(require 'highlight-global)
(global-set-key (kbd "M-\042") 'highlight-frame-toggle)
(global-set-key (kbd "M-+") 'clear-highlight-frame)

(require 'view)
(global-set-key (kbd "M-v") 'View-scroll-half-page-backward)
(global-set-key (kbd "C-v") 'View-scroll-half-page-forward)

(bind "M-a" ido-switch-buffer)
(bind "M-e" ido-find-file)
(bind "M-k" kill-current-buffer)
(bind "M-s M-s" save-some-buffers)

(bind "M-0" delete-window)
(bind "M-1" delete-other-windows)
(bind "M-2" (split-window-func-with-other-buffer 'split-window-vertically))
(bind "M-3" (split-window-func-with-other-buffer 'split-window-horizontally))
(bind "M-4" find-file-other-window)
(bind "C-M-^" join-next-line)

(require 'windmove)
;; window move, bind the VIM-way
(bind "M-L" windmove-right)
(bind "M-H" windmove-left)
(bind "M-K" windmove-up)
(bind "M-J" windmove-down)

(global-set-key (kbd "M-o") 'reformat-buffer)

(provide 'visual-regexp)
;; (global-set-key (kbd "M-%") 'vr/query-replace)
(bind "C-z m" xterm-mouse-mode)

(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)

(require 'magit)
(bind "C-c C-g" magit-status)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "M-(") 'previous-buffer)
(global-set-key (kbd "M-)") 'next-buffer)

(global-set-key (kbd "M-O") 'occur-current-symbol-or-region)
(global-set-key [(meta *)] 'search-current-symbol-or-region)
(define-key isearch-mode-map [(meta *)] 'isearch-repeat-forward)
(define-key isearch-mode-map [(meta &)] 'isearch-repeat-backward)

(require 'misc)
;; (global-set-key (kbd "M-f") 'forward-word) ; remap forward-word
;; (global-set-key (kbd "M-b") 'backward-word)   ; remap backward-word
(global-set-key (kbd "M-Y") 'copy-above-line) ; NB

(require 'init-utils)
(global-set-key (kbd "M-z") 'zap-up-to-char) ; remap M-z the vim's delete to char
(global-set-key (kbd "M-p") 'scroll-lock-previous-line)
(global-set-key (kbd "M-n") 'scroll-lock-next-line)
(global-set-key (kbd "M-?") 'imenu)

(global-set-key [(control meta z)] 'scroll-other-window-down)
(global-set-key [(meta Q)] 'query-replace-regexp)

(global-set-key [(control h) (u)] 'woman)
(global-set-key [(meta U)] 'winner-undo)
(global-set-key [(meta R)] 'winner-redo)

(require 'highlight-symbol)
(global-set-key [(meta W)] 'highlight-symbol-at-point)
(global-set-key [(meta B)] 'highlight-symbol-prev)
(global-set-key [(meta F)] 'highlight-symbol-next)
(my-bind [(control w)] 'highlight-symbol-remove-all)

(require 'expand-region)
(global-set-key [(meta M)] 'er/expand-region)

;;--------------------------------------------------
;; C-z remap to my map at `init-utils.el'
;;--------------------------------------------------
(my-bind "d" 'delete-trailing-whitespace)
(my-bind "r" 'revert-buffer)
(my-bind "s" 'isearch-other-window)     ; search in other window
(my-bind [(control b)] 'split-follow-buffer) ; split current buffer and enter follow mode

(require 'align)
(my-bind [(control r)] 'align-regexp)

(require 'ack-and-a-half)
(my-bind [(control a)] 'ag-project-at-point)
(my-bind [(control meta a)] 'ack-find-file)

(require 'col-highlight)
(my-bind [(control c)] 'column-highlight-mode)

(require 'buffer-move)
(my-bind [(j)] 'buf-move-down)
(my-bind [(k)] 'buf-move-up)
(my-bind [(h)] 'buf-move-left)
(my-bind [(l)] 'buf-move-right)

(require 'multiple-cursors)
(my-bind [(m) (d)] 'mc/mark-all-like-this-dwim)
(my-bind [(m) (n)] 'mc/mark-next-like-this)
(my-bind [(m) (p)] 'mc/mark-previous-like-this)
(my-bind [(m) (e)] 'mc/mark-more-like-this-extended)

(my-bind [(control m) (control a)] 'mc/mark-all-like-this)
(my-bind [(m) (w)] 'mc/mark-all-words-like-this-in-defun)
(my-bind [(m) (m)] 'mc/mark-all-symbols-like-this-in-defun)
(my-bind [(m) (a)] 'mc/mark-all-like-this-in-defun)

(my-bind [(m) (meta w)] 'mc/mark-all-words-like-this)
(my-bind [(m) (meta s)] 'mc/mark-all-symbols-like-this)

(require 'hideshow)
;; (my-bind [(meta f)] 'hs-minor-mode)
(my-bind [(control f)] 'hs-toggle-hiding)
(my-bind [(control meta f)] 'hs-hide-all)

(define-key region-bindings-mode-map [(control s)] 'search-selection)

(provide 'init-key-binding)
