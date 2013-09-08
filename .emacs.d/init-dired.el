
;; enhance default dired:
;; 1) Use dired-x to hide dot files;
;; 2) Use dired-single to mange multi independent dir in one buffer

;; 1) hide dot files


(defun dired-isearch-backward ()
  "Search for a string using Isearch only in file names in the Dired buffer."
  (interactive)
  (let ((dired-isearch-filenames t))
    (isearch-forward)))

(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(add-hook 'dired-mode-hook (lambda ()
                             (dired-omit-mode 1)
                             (define-key dired-mode-map "/" 'dired-isearch-filenames)
                             (message "enter dired-omit-mode")))
(defun sof/dired-sort ()
  "Dired sort hook to list directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max))))
  (and (featurep 'xemacs)
       (fboundp 'dired-insert-set-properties)
       (dired-insert-set-properties (point-min) (point-max)))
  (set-buffer-modified-p nil))
(add-hook 'dired-after-readin-hook 'sof/dired-sort)

(setq-default dired-listing-switches "-alh")

;; 2) singel buffer to manage multi independent dirs
(require 'dired-single)

(provide 'init-dired)
