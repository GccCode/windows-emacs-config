;;---------------------------------------------------------------
;; copy from scroll-lock-mode of EMACS
;;---------------------------------------------------------------
(defvar scroll-lock-preserve-screen-pos-save scroll-preserve-screen-position
  "Used for saving the state of `scroll-preserve-screen-position'.")

(defvar scroll-lock-temporary-goal-column 0
  "Like `temporary-goal-column' but for scroll-lock-* commands.")

(defun scroll-lock-update-goal-column ()
  "Update `scroll-lock-temporary-goal-column' if necessary."
  (unless (memq last-command '(scroll-lock-next-line
			       scroll-lock-previous-line
			       scroll-lock-forward-paragraph
			       scroll-lock-backward-paragraph))
    (setq scroll-lock-temporary-goal-column (current-column))))

(defun scroll-lock-move-to-column (column)
  "Like `move-to-column' but cater for wrapped lines."
  (if (or (bolp)
	  ;; Start of a screen line.
	  (not (zerop (mod (- (point) (line-beginning-position))
			   (window-width)))))
      (move-to-column column)
    (forward-char (min column (- (line-end-position) (point))))))

(defun scroll-lock-next-line (&optional arg)
  "Scroll up ARG lines keeping point fixed."
  (interactive "p")
  (or arg (setq arg 1))
  (scroll-lock-update-goal-column)
  (if (pos-visible-in-window-p (point-max))
      (forward-line arg)
    (scroll-up arg))
  (scroll-lock-move-to-column scroll-lock-temporary-goal-column))

(defun scroll-lock-previous-line (&optional arg)
  "Scroll up ARG lines keeping point fixed."
  (interactive "p")
  (or arg (setq arg 1))
  (scroll-lock-update-goal-column)
  (condition-case nil
      (scroll-down arg)
    (beginning-of-buffer (forward-line (- arg))))
  (scroll-lock-move-to-column scroll-lock-temporary-goal-column))

(defun scroll-lock-forward-paragraph (&optional arg)
  "Scroll down ARG paragraphs keeping point fixed."
  (interactive "p")
  (or arg (setq arg 1))
  (scroll-lock-update-goal-column)
  (scroll-up (count-screen-lines (point) (save-excursion
					   (forward-paragraph arg)
					   (point))))
  (scroll-lock-move-to-column scroll-lock-temporary-goal-column))

(defun scroll-lock-backward-paragraph (&optional arg)
  "Scroll up ARG paragraphs keeping point fixed."
  (interactive "p")
  (or arg (setq arg 1))
  (scroll-lock-update-goal-column)
  (let ((goal (save-excursion (backward-paragraph arg) (point))))
    (condition-case nil
	(scroll-down (count-screen-lines goal (point)))
      (beginning-of-buffer (goto-char goal))))
  (scroll-lock-move-to-column scroll-lock-temporary-goal-column))

;;---------------------------------------------------------------
;; copy ends here
;;---------------------------------------------------------------

(provide 'init-scroll-lock)
