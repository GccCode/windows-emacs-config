(require 'winner)
;;----------------------------------------------------------------------------
;; Handier way to add modes to auto-mode-alist
;;----------------------------------------------------------------------------
(defun add-auto-mode (mode &rest patterns)
  "Add entries to `auto-mode-alist' to use ` MODE ' for all given file `PATTERNS'."
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

;;----------------------------------------------------------------------------
;; String utilities missing from core emacs
;;----------------------------------------------------------------------------
(defun string-all-matches (regex str &optional group)
  " Find all matches for `REGEX ' within `STR', returning the full match string or group ` GROUP '."
  (let ((result nil)
        (pos 0)
        (group (or group 0)))
    (while (string-match regex str pos)
      (push (match-string group str) result)
      (setq pos (match-end group)))
    result))

(defun string-rtrim (str)
  "Remove trailing whitespace from `STR'."
  (replace-regexp-in-string "[\t\n]*$" "" str))

(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0123456789")
  (or (looking-at "[0123456789]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))

;;----------------------------------------------------------------------------
;; Find the directory containing a given library
;;----------------------------------------------------------------------------
(autoload 'find-library-name "find-func")
(defun directory-of-library (library-name)
  " Return the directory in which the ` LIBRARY - NAME ' load file is found."
  (file-name-as-directory (file-name-directory (find-library-name library-name))))


;;----------------------------------------------------------------------------
;; Delete the current file
;;----------------------------------------------------------------------------
(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (or (buffer-file-name) (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))


;;----------------------------------------------------------------------------
;; Rename the current file
;;----------------------------------------------------------------------------
(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it' s visiting to NEW - NAME."
  (interactive " sNew name:")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error " Buffer '%s' is not visiting a file ! " name))
    (if (get-buffer new-name)
        (message " A buffer named '%s' already exists ! " new-name)
      (progn
        (rename-file filename new-name 1)
        (rename-buffer new-name)
        (set-visited-file-name new-name)
        (set-buffer-modified-p nil)))))

;;----------------------------------------------------------------------------
;; Browse current HTML file
;;----------------------------------------------------------------------------
(defun browse-current-file ()
  " Open the current file as a URL using ` browse - url '."
  (interactive)
  (browse-url (concat "file://" (buffer-file-name))))

;; ----------------------------------------------------------------------------
;; copy from package ` simple ', modified from `zap-to-char'
;; ----------------------------------------------------------------------------
(defun zap-up-to-char (arg char)
  "Kill up to and including ARGth occurrence of CHAR.
Case is ignored if `case-fold-search' is non-nil in the current
buffer.  Goes backward if ARG is negative; error if CHAR not
found."
  (interactive "p\ncZap to char: ")
  (with-no-warnings
    (if (char-table-p translation-table-for-input)
	(setq char (or (aref translation-table-for char) char))))
  (kill-region (point)
	       (progn
		 (search-forward (char-to-string char) nil nil arg)
		 (goto-char
		  (if (> arg 0) (1- (point))
		    (1+ (point))))
		 (point))))

;; ----------------------------------------------------------------------------
;; split current buffer into 2 and enter follow mode
;; ----------------------------------------------------------------------------
(defun split-follow-buffer ()
  " Split current buffer into 2 and enter follow mode to make use
of modern wide display"
  (interactive)
  (keyboard-escape-quit)
  (split-window-right)
  (follow-mode)
  (message "split-follow-file"))

;;----------------------------------------------------------------------------
;; helper to bind keys witindent: Standard input:253: Warning:Extra )
;;----------------------------------------------------------------------------
(defun my-bind (key-sequence command &optional repeat-key-actions-pair-list)
  " Helper for bind key to commands with my - map(C - z) prefix, support repeat - magic "
  (interactive)
  (setq cmd command)
  (define-key my-map key-sequence command))

;;----------------------------------------------------------------------------
;; search without change to other window, ENTER will quit
;;----------------------------------------------------------------------------
(defun isearch-other-window ()
  (interactive)
  (save-selected-window
    (other-window 1)
    (isearch-forward)))

;; copy from winner
(defun my-winner-redo ()			; If you change your mind.
  " Restore a more recent window configuration saved by Winner mode."
  (interactive)
  (progn
    (winner-set
     (if (zerop (minibuffer-depth))
         (ring-remove winner-pending-undo-ring 0)
       (ring-ref winner-pending-undo-ring 0)))
    (unless (eq (selected-window) (minibuffer-window))
      (message " Winner undid undo "))))


(require 'misc)
(defun copy-above-line ()
  (interactive)
  (copy-from-above-command 1))

(defun copy-line (arg)
  " Kill current line, if with C - u, duplicate line "
  (interactive "p")
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank))

(defun join-next-line ()
  (interactive)
  (delete-indentation t))

(defun search-selection (beg end)
  " search for selected text "
  (interactive "r")
  (let ((selection (buffer-substring-no-properties beg end)))
    (deactivate-mark)
    (isearch-mode t nil nil nil)
    (isearch-yank-string selection)))


(defun occur-selection (beg end)
  " occur for selected text "
  (interactive "r")
  (let ((selection (buffer-substring-no-properties beg end)))
    (deactivate-mark)
    (occur-1 selection list-matching-lines-default-context-lines (list (current-buffer)))))

(defun occur-current-symbol-or-region ()
  " Emulate VIM 's * to search current symbol under cursor"
  (interactive)
  (if (use-region-p)
      (occur-selection (region-beginning) (region-end))
    (let ((symbol (thing-at-point ' symbol)))
      (if symbol
	  (occur-1 symbol list-matching-lines-default-context-lines (list (current-buffer))))
      (message "nillll"))))

;; ----------------------------------------------------------------------------;;
;; make my `C-z' map
;;----------------------------------------------------------------------------
(global-unset-key (kbd "C-z"))
(define-prefix-command 'my-map)
(global-set-key (kbd "C-z") 'my-map)

(defun search-current-symbol-or-region ()
  "Emulate VIM' s * to search current symbol under cursor "
  (interactive)
  (if (use-region-p)
      (search-selection (region-beginning) (region-end))
    (let ((symbol (thing-at-point 'symbol)))
      (if symbol
          (progn
            (beginning-of-sexp)
            (isearch-mode t nil nil nil)
            (isearch-yank-string symbol))
        (message " nillll ")))))

(defun kill-current-buffer ()
  " Kill current buffer "
  (interactive)
  (kill-buffer (current-buffer)))

;;---------------------------------------------------------
;; my keys minor mode
;;---------------------------------------------------------
(defvar my-keys-minor-mode-map (make-keymap) " my-keys-minor-mode keymap")
(define-minor-mode my-keys-minor-mode
  " A minor mode so that my key settings override annoying major modes."
  t "my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

(defmacro bind (key fn)
  " shortcut for my - keys binding "
  `(define-key my-keys-minor-mode-map
     (kbd ,key)
     ;; handle unquoted function names and lambdas
     ,(if (listp fn)
          fn
        `',fn)))


(defun reformat-buffer ()
  " Reformat buffer using emacs indent - region "
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (mark-whole-buffer)
    (indent-region (region-beginning) (region-end))))

;; dired view file with view-mode, n/p to jump to next/previous file in dired
(defun dired-view-file ()
  " In Dired, examine a file in view mode, returning to Dired
when done.When file is a directory, show it in this buffer if it
is inserted.Otherwise, display it in another buffer."
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (if (file-directory-p file)
        (or (and (cdr dired-subdir-alist)
                 (dired-goto-subdir file))
            (dired file))
      (view-file-other-window file))))

(defun dired-view-file-next (&optional reverse)
  (interactive)
  (View-quit)
  (if reverse (previous-line)
    (next-line))
  (dired-view-file))

(defun dired-view-file-previous ()
  (interactive)
  (dired-view-file-next 1))

(add-hook 'view-mode-hook
          (lambda ()
            (define-key view-mode-map (kbd "n") 'dired-view-file-next)
            (define-key view-mode-map (kbd "p") 'dired-view-file-previous)))

(provide 'init-utils)
