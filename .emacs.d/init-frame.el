;;----------------------------------------------------------------
;; full screen toggle, from: http://emacswiki.org/emacs/FullScreen
;;----------------------------------------------------------------
(defvar fullscreen-p t "Check if fullscreen is on or off")

(defun non-fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND restore #xf120
	  (w32-send-sys-command 61728)
	(progn (set-frame-parameter nil 'width 82)
		   (set-frame-parameter nil 'fullscreen 'fullheight))))

(defun fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND maximaze #xf030
	  (w32-send-sys-command 61488)
	(set-frame-parameter nil 'fullscreen 'fullboth)))

(defun toggle-fullscreen ()
  (interactive)
  (setq fullscreen-p (not fullscreen-p))
  (if fullscreen-p
	  (non-fullscreen)
	(fullscreen)))
;;----------------------------------------------------------------
;; frame title show active window's file name
;;----------------------------------------------------------------
(setq-default  frame-title-format "%f")
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(global-set-key (kbd "C-x C-m") 'toggle-fullscreen)

(provide 'init-frame)
