;;; hide-region.el --- hide regions of text using overlays
;;
;; Copyright (C) 2001, 2005  Mathias Dahl
;;
;; Version: 1.0.2
;; Keywords: hide, region
;; Author: Mathias Dahl <mathias.rem0veth1s.dahl@gmail.com>
;; Maintainer: Mathias Dahl
;; URL: http://mathias.dahl.net/pgm/emacs/elisp/hide-region.el
;; Last-Updated: Thu Sun Jul 28 16:10:15 2011 (+0200)
;;           By: Deniz Dogan <deniz@dogan.se>
;;
;; This file is not part of GNU Emacs.
;;
;; This is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;
;;; Commentary:
;;
;; The function `hide-region-hide' hides the region. You can hide many
;; different regions and they will be "marked" by two configurable
;; strings (so that you know where the hidden text is).
;;
;; The hidden regions is pushed on a kind of hide-region \"ring".
;;
;; The function `hide-region-unhide' "unhides" one region, starting
;; with the last one you hid.
;;
;; The best is to try it out. Test on the following:
;;
;; Test region 1
;; Test region 2
;; Test region 3
;;
;; It can be useful to bind the commands to mnemonic keys, e.g.:
;; (global-set-key (kbd "C-c h r") 'hide-region-hide)
;; (global-set-key (kbd "C-c h u") 'hide-region-unhide)
;;
;;; Version history
;;
;; Version 1.0.2
;;
;; * Added defface for text properties.
;;
;; * Minor tweaks.
;;
;;
;; Version 1.0.1
;;
;; * Seems that the getting-stuck problem have disappeared since Emacs
;; 21.3 was released, so no need anymore for the extra movement
;; commands.
;;
;; * Added the intangible property to the overlays because that seemed
;; to remove a minor getting-stuck problem (the overlay "ate" one
;; keystroke) when navigating around an overlay. Adding the intangible
;; property makes it impossible to navigate into the overlay.
;;
;; * Added custom option to propertize the overlay markers for greater
;; visibility.
;;
;; * Minor code cleanup
;;
;;
;;; Bugs
;;
;; Probably many, but none that I know of. Comments and suggestions
;; are welcome!

;;; Code:

(defgroup hide-region nil
  "Functions to hide region using an overlay with the invisible
property. The text is not affected."
  :prefix "hide-region-"
  :group 'convenience)

(defcustom hide-region-before-string "@["
  "String to mark the beginning of an invisible region. This string is
not really placed in the text, it is just shown in the overlay"
  :type 'string
  :group 'hide-region)

(defcustom hide-region-after-string "..."
  "String to mark the beginning of an invisible region. This string is
not really placed in the text, it is just shown in the overlay"
  :type 'string
  :group 'hide-region)

(defcustom hide-region-propertize-markers t
  "If non-nil, add text properties to the region markers."
  :type 'boolean
  :group 'hide-region)

(defface hide-region-before-string-face
  '((t (:inherit region)))
  "Face for the before string.")

(defface hide-region-after-string-face
  '((t (:inherit region)))
  "Face for the after string.")

(defvar hide-region-overlays nil
  "Variable to store the regions we put an overlay on.")

(defun hide-region-hide ()
  "Hides a region by making an invisible overlay over it and save the
overlay on the hide-region-overlays \"ring\""
  (interactive)
  (if (region-active-p)
      (progn
        (let ((1st-char (min (region-beginning) (region-end)))
              (last-char (max (region-beginning) (region-end)))
              (1st-line nil)
              (last-line nil)
              (new-overlay nil))
          ;; 1) expand region to contain 1st/last line
          ;; 1.1 expand 1st line, and extract this line's content to be
          (goto-char 1st-char)
          (end-of-visual-line)
          (setq 1st-char (point))
          (goto-char 1st-char)
          (setq 1st-line (line-number-at-pos 1st-char))
          ;; 1.2 expand to last line
          (goto-char last-char)
          (end-of-visual-line)
          (setq last-char (point))
          (goto-char last-char)
          (setq last-line (line-number-at-pos last-char))
          ;; 2) construct (overlay 1st-line last-line) element to store
          ;; 2.1 make overlay
          (setq new-overlay (make-overlay 1st-char last-char))
          (overlay-put new-overlay 'invisible t)
          (overlay-put new-overlay 'intangible t)
          (overlay-put new-overlay 'isearch-open-invisible 'hide-region-isearch-show) ; open hide when isearch
          (overlay-put new-overlay 'after-string hide-region-after-string)
          (push (cons new-overlay
                      (list 1st-line last-line))
                hide-region-overlays))
        (deactivate-mark))              ; deactivate region at last!
    (message "[ERROR]: No validate region!")))


(defun hide-region-unhide ()
  "Unhide a region at a time, starting with the last one hidden and
deleting the overlay from the hide-region-overlays \"ring\"."
  (interactive)
  (let ((cur-line (line-number-at-pos (point)))
        (overlay-found nil)
        (cur-start-line nil)
        (cur-end-line nil)
        (last-start-line -1)          ; TRICK: when no overlay found, last-starte-line is < 0
        (last-end-line -1))
    (dolist (current-hide hide-region-overlays t)
      (progn
        (setq cur-start-line (nth 1 current-hide))
        (setq cur-end-line (nth 2 current-hide)))
      (when (and (>= cur-line cur-start-line)
                 (<= cur-line cur-end-line))
        (when (or (<= cur-start-line last-start-line)
                  (>= cur-end-line last-end-line))
          (progn
            (setq last-start-line cur-start-line)
            (setq last-end-line cur-end-line)
            (setq overlay-found current-hide)))))
    (if (not overlay-found)
        (progn
          (message "[ERROR]: No region was hiden under cursor/no region hide yet.")
          nil)                          ; never found one
      (progn
        (goto-line last-start-line)
        (delete-overlay (car overlay-found)) ;delete overlay from buffer
        (setq hide-region-overlays
              (remove overlay-found hide-region-overlays))
        t                               ; t indicates a new one found
        ))))

(defun hide-region-isearch-show (ov)
  (dolist (current-hide hide-region-overlays t)
    (when (eq (car current-hide) ov)
      (progn
        (delete-overlay (car current-hide))
        (setq hide-region-overlays
              (remove overlay-found hide-region-overlays))))))

(defun hide-region-toggle ()
  (interactive)
  (if (use-region-p)
      (hide-region-hide)
    (hide-region-unhide)))

(defun hide-region-show-all ()
  (interactive)
  (dolist (current-hide hide-region-overlays t)
    (delete-overlay (car current-hide)))
  (setq hide-region-overlays nil))

(provide 'hide-region)

;;; hide-region.el ends here
