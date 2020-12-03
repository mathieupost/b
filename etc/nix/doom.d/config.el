;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Enable auto maximize window
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq user-full-name "Mathieu Post"
      user-mail-address "mathieupost@gmail.com"

      doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14)
      doom-theme 'doom-one

      ;; Always split vertically
      split-width-threshold nil)

;; Set default column width
(setq-default fill-column 100)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode t)

(use-package! visual-fill-column-mode
  :hook text-mode
  :init
  (setq visual-fill-column-center-text t
        line-move-visual t))

(use-package! adaptive-wrap-prefix-mode
  :hook visual-line-mode
  :init
  (setq adaptive-wrap-extra-indent 2))

;; Move buffer while keeping the cursor visually on te same position wit Super+{j,k}.
(map! "s-j" (lambda () (interactive) (evil-scroll-line-down 1) (evil-next-line))
      "s-k" (lambda () (interactive) (evil-scroll-line-up 1) (evil-previous-line)))

;;; Enable emojis
;(use-package! emojify
;  :hook (after-init . global-emojify-mode))

;;; Always highlight diffs
;(use-package-hook! magit
;  :post-init
;  (setq magit-diff-refine-hunk 'all))

;;; Open agenda on startup
;(add-hook 'emacs-startup-hook #'jethro/switch-to-agenda)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; org-mode ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq org-directory "~/Org/"
;      zotero-bib (concat org-directory "zotero.bib"))

;(setq org-journal-dir org-directory
;      reftex-default-bibliography '(zotero-bib))
;;; (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f" "rm *-blx.bib || true")
;;;       +latex-viewers nil)

;(use-package! org
;  :init
;  (setq org-src-window-setup 'current-window
;        org-return-follows-link t
;        org-confirm-babel-evaluate nil
;        org-use-speed-commands t
;        org-catch-invisible-edits 'show
;        org-preview-latex-image-directory "/tmp/ltximg/"
;        org-structure-template-alist '(("a" . "export ascii")
;                                       ("c" . "center")
;                                       ("C" . "comment")
;                                       ("e" . "example")
;                                       ("E" . "export")
;                                       ("h" . "export html")
;                                       ("l" . "export latex")
;                                       ("q" . "quote")
;                                       ("s" . "src")
;                                       ("v" . "verse")
;                                       ("el" . "src emacs-lisp")
;                                       ("d" . "definition")
;                                       ("t" . "theorem")))

;  (with-eval-after-load 'flycheck
;    (flycheck-add-mode 'proselint 'org-mode)))

;(add-hook! org-mode
;  (setq fill-column 80)
;  (setq org-latex-remove-logfiles t
;        org-latex-logfiles-extensions (append org-latex-logfiles-extensions '("tex" "bib" "bbl"))))

;(add-hook! 'auto-save-hook 'org-save-all-org-buffers)

;(after! org
;  (defun jethro/org-archive-done-tasks ()
;    "Archive all done tasks."
;    (interactive)
;    (org-map-entries 'org-archive-subtree "/DONE" 'file))
;  (require 'find-lisp)
;  (setq jethro/org-agenda-directory (concat org-directory "agenda/"))
;  (setq org-agenda-files
;        (find-lisp-find-files jethro/org-agenda-directory "\.org$")))

;(defun transform-square-brackets-to-round-ones(string-to-transform)
;  "Transforms [ into ( and ] into ), other chars left unchanged."
;  (concat (mapcar #'(lambda (c) (if (equal c ?[) ?\( (if (equal c ?]) ?\) c))) string-to-transform)))

;(setq org-capture-templates
;        `(("i" "inbox" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
;           "* TODO %?")
;          ("e" "email" entry (file+headline ,(concat jethro/org-agenda-directory "emails.org") "Emails")
;               "* TODO [#A] Reply: %a :@home:@school:"
;               :immediate-finish t)
;          ("c" "org-protocol-capture" entry (file ,(concat jethro/org-agenda-directory "inbox.org"))
;           "* TODO [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n\n%i"
;           :immediate-finish t)
;          ("w" "Weekly Review" entry (file+olp+datetree ,(concat jethro/org-agenda-directory "reviews.org"))
;           (file ,(concat jethro/org-agenda-directory "templates/weekly_review.org")))
;          ("r" "Reading" todo ""
;               ((org-agenda-files '(,(concat jethro/org-agenda-directory "reading.org")))))))

;(setq org-todo-keywords
;      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
;        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))

;(setq org-log-done 'time
;      org-log-into-drawer t
;      org-log-state-notes-insert-after-drawers nil)

;(setq org-tag-alist (quote (("@errand" . ?e)
;                            ("@office" . ?o)
;                            ("@home" . ?h)
;                            ("@university" . ?u)
;                            (:newline)
;                            ("WAITING" . ?w)
;                            ("HOLD" . ?H)
;                            ("CANCELLED" . ?c))))

;(setq org-fast-tag-selection-single-key nil)
;(setq org-refile-use-outline-path 'file
;      org-outline-path-complete-in-steps nil)
;(setq org-refile-allow-creating-parent-nodes 'confirm)
;(setq org-refile-targets '(("next.org" :level . 0)
;                           ("someday.org" :level . 0)
;                           ("work.org" :level . 0)
;                           ("reading.org" :level . 1)
;                           ("projects.org" :maxlevel . 1)))

;(defvar jethro/org-agenda-bulk-process-key ?i
;  "Default key for bulk processing inbox items.")

;(defun jethro/org-process-inbox ()
;  "Called in org-agenda-mode, processes all inbox items."
;  (interactive)
;  (org-agenda-bulk-mark-regexp "inbox:")
;  (jethro/bulk-process-entries))

;(defvar jethro/org-current-effort "1:00"
;  "Current effort for agenda items.")

;(defun jethro/my-org-agenda-set-effort (effort)
;  "Set the effort property for the current headline."
;  (interactive
;   (list (read-string (format "Effort [%s]: " jethro/org-current-effort) nil nil jethro/org-current-effort)))
;  (setq jethro/org-current-effort effort)
;  (org-agenda-check-no-diary)
;  (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
;                       (org-agenda-error)))
;         (buffer (marker-buffer hdmarker))
;         (pos (marker-position hdmarker))
;         (inhibit-read-only t)
;         newhead)
;    (org-with-remote-undo buffer
;      (with-current-buffer buffer
;        (widen)
;        (goto-char pos)
;        (org-show-context 'agenda)
;        (funcall-interactively 'org-set-effort nil jethro/org-current-effort)
;        (end-of-line 1)
;        (setq newhead (org-get-heading)))
;      (org-agenda-change-all-lines newhead hdmarker))))

;(defun jethro/org-agenda-process-inbox-item ()
;  "Process a single item in the org-agenda."
;  (org-with-wide-buffer
;   (org-agenda-set-tags)
;   (org-agenda-priority)
;   (call-interactively 'jethro/my-org-agenda-set-effort)
;   (org-agenda-refile nil nil t)))

;(defun jethro/bulk-process-entries ()
;  (if (not (null org-agenda-bulk-marked-entries))
;      (let ((entries (reverse org-agenda-bulk-marked-entries))
;            (processed 0)
;            (skipped 0))
;        (dolist (e entries)
;          (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
;            (if (not pos)
;                (progn (message "Skipping removed entry at %s" e)
;                       (cl-incf skipped))
;              (goto-char pos)
;              (let (org-loop-over-headlines-in-active-region) (funcall 'jethro/org-agenda-process-inbox-item))
;              ;; `post-command-hook' is not run yet.  We make sure any
;              ;; pending log note is processed.
;              (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
;                        (memq 'org-add-log-note post-command-hook))
;                (org-add-log-note))
;              (cl-incf processed))))
;        (org-agenda-redo)
;        (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
;        (message "Acted on %d entries%s%s"
;                 processed
;                 (if (= skipped 0)
;                     ""
;                   (format ", skipped %d (disappeared before their turn)"
;                           skipped))
;                 (if (not org-agenda-persistent-marks) "" " (kept marked)")))))

;(defun jethro/org-inbox-capture ()
;  (interactive)
;  "Capture a task in agenda mode."
;  (org-capture nil "i"))

;(setq org-agenda-bulk-custom-functions `((,jethro/org-agenda-bulk-process-key jethro/org-agenda-process-inbox-item)))

;(defun jethro/set-todo-state-next ()
;  "Visit each parent task and change NEXT states to TODO"
;  (org-todo "NEXT"))

;(add-hook 'org-clock-in-hook 'jethro/set-todo-state-next 'append)

;(use-package! org-clock-convenience
;  :bind (:map org-agenda-mode-map
;              ("<S-up>" . org-clock-convenience-timestamp-up)
;              ("<S-down>" . org-clock-convenience-timestamp-down)
;              ("o" . org-clock-convenience-fill-gap)
;              ("e" . org-clock-convenience-fill-gap-both)))

;(use-package! org-agenda
;  :init
;  (map! "<f1>" #'jethro/switch-to-agenda)
;  (setq org-agenda-block-separator nil
;        org-agenda-start-with-log-mode t)
;  (defun jethro/switch-to-agenda ()
;    (interactive)
;    (org-agenda nil " "))
;  :config
;  (map! :map org-agenda-mode-map
;        "i" #'org-agenda-clock-in
;        "r" #'jethro/org-process-inbox
;        "R" #'org-agenda-refile
;        "c" #'jethro/org-inbox-capture)
;  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)")
;  (setq org-agenda-custom-commands `((" " "Agenda"
;                                      ((agenda ""
;                                               ((org-agenda-span 7)
;                                                (org-agenda-start-day "-1")
;                                                (org-deadline-warning-days 365)))
;                                       (todo "TODO"
;                                             ((org-agenda-overriding-header "Inbox")
;                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "inbox.org")
;                                                                  ,(concat jethro/org-agenda-directory "inbox_mobile.org")))))
;                                       ;; (todo "TODO"
;                                       ;;       ((org-agenda-overriding-header "Emails")
;                                       ;;        (org-agenda-files '(,(concat jethro/org-agenda-directory "emails.org")))))
;                                       (todo "NEXT"
;                                             ((org-agenda-overriding-header "In Progress")
;                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "someday.org")
;                                                                  ,(concat jethro/org-agenda-directory "projects.org")
;                                                                  ,(concat jethro/org-agenda-directory "next.org")))
;                                              ))
;                                       (todo "TODO"
;                                             ((org-agenda-overriding-header "Projects")
;                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "projects.org")
;                                                                  ,(concat jethro/org-agenda-directory "work.org")))))
;                                       (todo "TODO"
;                                             ((org-agenda-overriding-header "One-off Tasks")
;                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "next.org")))
;                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
;                                       (todo "TODO"
;                                             ((org-agenda-overriding-header "Someday")
;                                              (org-agenda-files '(,(concat jethro/org-agenda-directory "someday.org")))
;                                              (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled)))))))))

;(use-package! org-gcal
;  :init
;  (setq org-gcal-client-id "1082928189182-2jomh81kiqjaphmsc5go8ssd1e0l6q1n.apps.googleusercontent.com"
;        org-gcal-client-secret "OiVUWzUEoo37SfQlY3H991do"
;        org-gcal-remove-api-cancelled-events t
;        org-gcal-file-alist '(("mathieupost@gmail.com" . "~/Org/agenda/gmail.org")
;                              ("mathieu@weave.nl" . "~/Org/agenda/weave.org")
;                              ("rhmjuib5l1g0t2p49r4qu457v29iv7nl@import.calendar.google.com" . "~/Org/agenda/avalex.org")
;                              )))

;(use-package! org-journal
;  :init
;  (map! :leader
;        :prefix "n"
;        :desc "Journal new entry" "j" #'org-journal-new-entry
;        :desc "Journal today" "t" #'org-journal-today)
;  :config
;  (setq org-journal-date-prefix "#+title: "
;        org-journal-file-format "%Y-%m-%d.org"
;        org-journal-dir org-directory
;        org-journal-carryover-items nil)
;  (defun org-journal-today ()
;    (interactive)
;    (org-journal-new-entry t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; org-roam ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(use-package! org-roam
;  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
;  :hook
;  (after-init . org-roam-mode)
;  :custom-face
;  (org-roam-link ((t (:inherit org-ref-cite-face))))
;  :init
;  (setq org-roam-directory org-directory
;        org-roam-db-location "~/org-roam.db"
;        org-roam-db-gc-threshold most-positive-fixnum
;        org-roam-graph-exclude-matcher "journal"
;        org-id-link-to-org-use-id t)
;  :config
;  (setq org-roam-capture-templates
;        '(("d" "default" plain (function org-roam-capture--get-point)
;           "%?"
;           :file-name "${slug}"
;           :head "#+title: ${title}
;#+roam_alias:
;#+created: %U

;- tags :: "
;           :unnarrowed t))))

;(use-package! org-roam-protocol
;  :after org-protocol)

;(use-package! org-roam-bibtex
;  :after (org-roam)
;  :hook (org-roam-mode . org-roam-bibtex-mode)
;  :config
;  (setq orb-preformat-keywords
;        '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
;  (setq orb-templates
;        `(("r" "ref" plain (function org-roam-capture--get-point)
;           ""
;           :file-name "${slug}"
;           :head ,(concat
;                   ;; "#+setupfile: ./hugo_setup.org\n"
;                   "#+title: ${=key=}: ${title}\n"
;                   "#+roam_key: ${ref}\n\n"
;                   "* ${title}\n"
;                   "  :PROPERTIES:\n"
;                   "  :Custom_ID: ${=key=}\n"
;                   "  :URL: ${url}\n"
;                   "  :AUTHOR: ${author-or-editor}\n"
;                   "  :NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
;                   "  :NOTER_PAGE: \n"
;                   "  :END:\n")
;           :unnarrowed t))))

;(use-package! bibtex-completion
;  :config
;  (setq bibtex-completion-notes-path org-directory
;        bibtex-completion-bibliography zotero-bib
;        bibtex-completion-pdf-field "file"
;        bibtex-completion-notes-template-multiple-files
;         (concat
;          "#+title: ${title}\n"
;          "#+roam_key: cite:${=key=}\n"
;          "* TODO Notes\n"
;          ":PROPERTIES:\n"
;          ":Custom_ID: ${=key=}\n"
;          ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
;          ":AUTHOR: ${author-abbrev}\n"
;          ":JOURNAL: ${journaltitle}\n"
;          ":DATE: ${date}\n"
;          ":YEAR: ${year}\n"
;          ":DOI: ${doi}\n"
;          ":URL: ${url}\n"
;          ":END:\n\n"
;          )))

;(use-package org-ref
;  :config
;  (setq
;   org-ref-completion-library 'org-ref-ivy-cite
;   org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
;   org-ref-default-bibliography (list zotero-bib)
;   org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
;   org-ref-notes-directory org-directory
;   org-ref-notes-function 'orb-edit-notes
;   ))

;(use-package org-noter
;  :after (:any org pdf-view)
;  :config
;  (setq
;   ;; The WM can handle splits
;   ;; org-noter-notes-window-location 'horizontal-split
;   ;; Please stop opening frames
;   ;; org-noter-always-create-frame nil
;   ;; I want to see the whole file
;   org-noter-hide-other nil
;   ;; Everything is relative to the main notes file
;   org-noter-notes-search-path (list org-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; other stuff ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;; Add tabnine backend
;; (use-package! company-tabnine
;;   :after company
;;   :when (featurep! :completion company)
;;   :config
;;   (add-to-list 'company-backends #'company-tabnine)
;;   (setq company-idle-delay 0
;;         company-show-numbers t))
;; (setq +lsp-company-backends '(company-tabnine company-capf))

;; Enable hover lsp info
(after! lsp-ui
  (setq lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline--run))

(use-package! protobuf-mode
  :mode "\\.proto$"
  :config
  (defconst my-protobuf-style
    '((c-basic-offset . 2)
      (indent-tabs-mode . nil)))
  (add-hook 'protobuf-mode-hook
            (lambda () (c-add-style "my-style" my-protobuf-style t))))

(after! treemacs
  (treemacs-git-mode 'extended)
  (add-to-list 'treemacs-pre-file-insert-predicates #'treemacs-is-file-git-ignored?))

; (use-package! chezmoi)

(defun insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Disable spell check for http and https urls
(defun flyspell-ignore-http-and-https ()
  "Function used for `flyspell-generic-check-word-predicate' to ignore stuff starting with \"http\" or \"https\"."
  (save-excursion
    (forward-whitespace -1)
    (when (looking-at " ")
        (forward-char)
    (not (looking-at "https?\\b")))))

(put 'text-mode 'flyspell-mode-predicate 'flyspell-ignore-http-and-https)
(put 'org-mode 'flyspell-mode-predicate 'flyspell-ignore-http-and-https)
