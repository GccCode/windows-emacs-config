;; Hook run only once per Emacs session

(require 'google-c-style)
(add-to-list 'auto-mode-alist '("\\.c+$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h+$" . c++-mode))
(setq comment-multi-line t)

(defun indent-active-region-or-buffer ()
  (interactive)
  (let ((min (if (use-region-p)
                 (region-beginning)
               (point-min)))
        (max (if (use-region-p)
                 (region-end)
               (point-max))))
    (shell-command-on-region
     min
     max
     "indent -kr -bap -i4 -ts4 -sai -br -ce -cdw -cli4 -cbi0 -bli0 -npcs -saf -sai -saw -brs -blf -lp -l80 -nbbo -hnl -npro -npcs -sob -il 0" ;; " -ppi4"
     t
     t)))

;;----------------------------------------------------------------------------
;; execute once per EMACS session
;;----------------------------------------------------------------------------
(add-hook 'c-initialization-hook
          (lambda ()
            (progn
              (define-key c-mode-base-map "\C-j" 'c-context-line-break)
              (define-key c-mode-base-map "\M-." 'hif-toggle-block)
              (define-key c-mode-base-map "\C-c\C-u" 'c-up-conditional-with-else)
              (define-key c-mode-base-map "\C-c\C-d" 'c-down-conditional-with-else)
              (define-key c-mode-base-map "\C-c\C-i" 'insert-header-guard)
              (define-key c-mode-base-map [(control meta i)] 'auto-complete)
              (define-key c-mode-base-map [(control c) (=) ] 'indent-active-region-or-buffer)
              (setq-default c-electric-pound-behavior (quote (alignleft)))
              (auto-complete-mode t))))


;;----------------------------------------------------------------------------
;; C++ Mode
;;----------------------------------------------------------------------------
(add-hook 'c++-mode-hook
          (lambda ()
            (progn
              (hs-hide-initial-comment-block)
              (hide-if-0)
              (setq comment-start "/* " comment-end " */"))))

;; Hook across all luanguage
(defconst my-c-style
  '((c-basic-offset . 4)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist
     (brace-list-open)
     (topmost-intro-cont after)
     (brace-entry-open)
     (substatement-open after)
     (block-close . c-snug-do-while)
     (class-open after)
     (class-close)
     (arglist-cont-nonempty))
    (c-cleanup-list . (brace-catch-brace
                       defun-close-semi
                       scope-operator
                       compact-empty-funcall
                       comment-close-slash))
    (c-offsets-alist
     (statement-block-intro . +)
     (knr-argdecl-intro . 0)
     (substatement-open . 0)
     (substatement-label . 0)
     (label . 0)
     (inclass . 4)
     (inline-open . 0)
     (arglist-cont-nonempty . c-lineup-arglist)
     (arglist-close . c-lineup-close-paren)
     (statement-cont . +)
     ))
  "My C Programing Style")
(c-add-style "personal-c-style" my-c-style)

;;----------------------------------------------------------------------------
;; hide `#if 0' block
;;----------------------------------------------------------------------------
(require 'hideif)
(setq hide-ifdef-initially nil)

(defun hide-if-0 ()
  "Hide #if 0 blocks, from internet"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*#if[ \t]*0" nil t)
      (hide-ifdef-block))))

(defun hif-overlay-at (position)
  "An imitation of the one in hide-show"
  (let ((overlays (overlays-at position))
        ov found)
    (while (and (not found) (setq ov (car overlays)))
      (setq found (eq (overlay-get ov 'invisible) 'hide-ifdef)
            overlays (cdr overlays)))
    found))

(defun hif-toggle-block ()
  "Toggle hide/show ifdef block"
  (interactive)
  (require 'hideif)
  (let* ((top-bottom (hif-find-ifdef-block))
         (top (car top-bottom)))
    (goto-char top)
    (hif-end-of-line)
    (setq top (point))
    (if (hif-overlay-at top)
        (show-ifdef-block)
      (hide-ifdef-block))))


(defun insert-header-guard (&optional arg)
  (interactive "p")
  (if (buffer-file-name)
      (let*
          ((fName (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
           (ifDef (concat "#ifndef _" fName "_H_" "\n#define _" fName "_H_" "\n"))
           (endDef (concat "\n#endif    " "/* _" fName "_H_ */\n"))
           (insert-cpp-gaurd (equal 4 arg)))
        (progn
          (goto-char (point-min))
          (insert ifDef)
          (when insert-cpp-gaurd (insert "\n#ifdef __cplusplus\nextern \"C\" {\n#endif"))
          (goto-char (point-max))
          (when insert-cpp-gaurd (insert "\n#ifdef __cplusplus\n}\n#endif\n"))
          (insert endDef)))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (progn
              ;; (setq c-basic-offset 4)
              (c-toggle-electric-state 1)
              (c-toggle-hungry-state 1)
              (c-toggle-auto-newline 1)
              (c-toggle-syntactic-indentation 1)
              ;; (setq-default c-insert-tab-function 'tab-to-tab-stop)
              (hs-minor-mode t)
              (auto-complete-mode t)
              ;; (c-set-style "personal-c-style")
              (google-set-c-style)
              (setq-default c-echo-syntactic-information-p t)
              (setq-default c-syntactic-indentation-in-macros t)
              (hide-ifdef-mode t)
              )))

(provide 'init-cc-mode)
