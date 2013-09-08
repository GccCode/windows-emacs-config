(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(setq-default org-export-babel-evaluate nil)

(add-hook 'org-mode-hook (lambda ()
                           (progn
                             (define-key org-mode-map "\C-cl" 'org-store-link)
                             (define-key org-mode-map "\C-cc" 'org-capture)
                             (define-key org-mode-map "\C-ca" 'org-agenda)
                             (define-key org-mode-map "\C-cb" 'org-iswitchb)
                             (org-indent-mode t))))
;;;;;;;;;;; Task status ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Todo -> doing
;; Ready -> finish sorting
;; Wait -> waiting someone to push
;; Someday -> when to go is unknown
;; Finish -> done
;; Cancel -> changed or aborted
(setq org-to-keywords '((sequence "Todo(t!)" "Ready(r)" "Wait(w)" "Someday(s)" "|" "Finish(f@/!)" "Cancel(c@/!)")))

;; for remember.el
(setq org-default-notes-file "~/.nates")
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map "\C-cr" 'org-remember)
;; remember template test
(setq org-remember-templates
      '(("Todo" ?t "* Todo %? %^g\n %i\n " "~/projects/task.org" "Tasks")
        ("Calendar" ?c "* Todo %? %^g\n SCHEDULED: %T DEADLINE: %T\n" "~/projects/task.org" "Tasks")
        ("Technique_site" ?T "** Name: %?\nSite: " "~/projects/site.org" "Technique")
        ("Market_site" ?m "** Name: %?\nSite: " "~/projects/site.org" "Market")
        ("Workplace_site" ?w "** Name: %?\nSite: " "~/projects/site.org" "Workplace")
        ("Life_site" ?l "** Name: %?\nSite: " "~/projects/site.org" "Life")
        ("Idea_site" ?i "** Free Keyword: %? %^g\n Context: \n" "~/projects/task.org" "Ideas")
        ("Project" ?p "* Prj_name: %?\nDEADLINE: %T\n" "~/projects/project.org" "Projects")
        ("Daily Review" ?d "** %t :COACH: \n%[~/projects/daily_review.txt]\n" "~/projects/journal.org")
        ("Book" ?b "\n* %^[∂¡ È± º«] %t :READING: \n%[~/projects/booktemp.txt]\n" "~/projects/booknotes.org")
      ))

(provide 'init-org)
