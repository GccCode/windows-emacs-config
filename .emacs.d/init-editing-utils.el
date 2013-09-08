;;----------------------------------------------------------------------------
;; Some basic preferences
;;----------------------------------------------------------------------------
(setq-default
 blink-cursor-delay 0
 inhibit-startup-screen 1
 blink-cursor-interval 0.4
 echo-keystrokes 0.15
 scroll-preserve-screen-position 1
 scroll-conservatively 5
 scroll-step 2
 indicate-empty-lines t
 bookmark-default-file "~/.emacs.d/.bookmarks.el"
 buffers-menu-max-size 30
 case-fold-search t
 compilation-scroll-output t
 ediff-split-window-function 'split-window-horizontally
 ediff-window-setup-function 'ediff-setup-windows-plain
 grep-highlight-matches t
 grep-scroll-output t
 indent-tabs-mode nil
 make-backup-files nil
 auto-save-default nil
 mouse-yank-at-point t
 highlight-nonselected-windows t
 set-mark-command-repeat-pop t
 show-trailing-whitespace t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil
 x-stretch-cursor t
 completion-cycle-threshold t
 tab-width 4
 major-mode 'text-mode
 visible-bell t)

(transient-mark-mode t)
(global-visual-line-mode)               ; word wrap
(mouse-avoidance-mode 'animate)
(blink-cursor-mode -1)
(delete-selection-mode t)

(setq linum-format "%d ")               ; add a SPC to line number to beautiful display
(global-linum-mode t)
(global-hi-lock-mode t)                 ; highlight regexp
(which-function-mode t)
;; (xterm-mouse-mode t)

;; (scroll-lock-mode -1)                      ; in-place scrolling

(fset 'yes-or-no-p 'y-or-n-p)
;; (icomplete-mode)                        ; complete for minibuffer
(show-paren-mode)
(column-number-mode)

;; jump to file/dir with register
(set-register ?. '(file . "~/.emacs.d/init.el")) ; use C-x r j e to open init.el
(set-register ?, '(file . "~/.emacs.d/"))
(set-register ?d '(file . "~/"))
(set-register ?k '(file . "~/.emacs.d/init-key-binding.el"))

;;----------------------------------------------------------------------------
;; Don't disable narrowing commands
;;----------------------------------------------------------------------------
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(setq ring-bell-function 'ignore)

;;(setq-default
;; mode-line-format
;; (list "-"
;;       'mode-line-mule-info
;;       "  "
;;       'mode-line-modified
;;       "  "
;;       'mode-line-frame-indentification
;;       "%f   "
;;       "("
;;       '(vc-mode vc-mode)
;;       ")   %[("
;;       '(:eval (mode-line-mode-name))
;;       'mode-line-process
;;       'minor-mode-alist
;;       "%n"
;;       ")%]  "
;;       '(line-number-mode "L%l -- ")
;;       '(-3 "%p")
;;       ))


(add-hook 'compilation-mode
          (lambda ()
            (progn
              (linum-mode -1)
               (setq show-trailing-whitespace nil))))

(provide 'init-editing-utils)
