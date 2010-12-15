;; File:     ~/.emacs.d/emacs-init.el
;; Author:   Burke Libbey <burke@burkelibbey.org>

;;-----[ Feature Selection ]---------------------------------------------------

(setq features 
      '((ack             . t)
        (cedet           . nil)
        (clojure         . t)
        (color-theme     . t)
        (edit-server     . nil)
        (erlang          . nil)
        (eshell          . t)
        (gist            . t)
        (html5           . t)
        (ido             . t)
        (jabber          . nil)
        (linum           . t)
        (magit           . t)
        (rails           . t)
        (rvm             . t)
        (slime           . nil)
        (smart-tab       . t)
        (speedbar        . nil)
        (starter-kit-js  . t)
        (textmate        . t)
        (timestamp       . t)
        (training-wheels . nil)
        (yasnippet       . t)))

(defmacro feature (feature &rest args)
  `(when (cdr (assoc (quote ,feature) features))
     ,@args))

;;-----[ Housekeeping ]--------------------------------------------------------
(easy-menu-define yas/minor-mode-menu nil "Workaround for ELPA version" nil)

(require 'cl)
(add-to-list 'load-path "~/.emacs.d/elpa/")
(require 'package)
(package-initialize)

(defvar *emacs-load-start* (current-time))
(setq debug-on-error t)

(defvar *emacs-config-directory* "~/.emacs.d")

(defvar *user-name*  "Burke Libbey")
(defvar *short-name* "burke")
(defvar *user-email* "burke@burkelibbey.org")

(defvar *default-font*  "pragmata tt")

(let ((private-el (concat *emacs-config-directory* "/private.el")))
  (when (file-exists-p private-el)
    (load-file private-el)))


(setq max-lisp-eval-depth 5000)
(setq max-specpdl-size 5000)

(setq mac-option-modifier 'meta)

;;-----[ Configure Load Path ]-------------------------------------------------

(setq site-lisp-path (concat *emacs-config-directory* "/site-lisp/"))

(defmacro add-path (path)
  `(add-to-list 'load-path (concat site-lisp-path ,path)))

(add-path "")
(add-path "markdown-mode")
(require 'coffee-mode)


(require 'coffee-mode)

(add-path "textmate.el")

(require 'textmate)
(textmate-mode)
(require 'peepopen)

;;-----[ HTML5 ]---------------------------------------------------------------

(feature html5
  (add-path "html5-el")
   
  (eval-after-load "rng-loc"
    '(add-to-list 'rng-schema-locating-files (concat site-lisp-path "/html5-el/schemas.xml")))
   
  (require 'whattf-dt))

;;-----[ Textmate Mode ]-------------------------------------------------------

(feature textmate
  (when window-system
    (add-path "textmate.el")
    (require 'textmate)
    (textmate-mode))
   
  (require 'peepopen)
   
  (require 'undo-tree)
  (global-undo-tree-mode))

;;-----[ Jabber ]-------------------------------------------------------

(feature jabber
  ;; adjust this path:
  (add-path "emacs-jabber-0.8.0")
  (require 'jabber-autoloads)

  (setq jabber-account-list
      '(("burke@burkelibbey.org" 
         (:network-server . "talk.google.com")
         (:connection-type . ssl))
        ("blibbey@cdebiz005" 
         (:network-server . "cdebiz005")))))

;;-----[ Linum ]----------------------------------------------------------

(feature linum
  (require 'linum))

;;-----[ Ack ]------------------------------------------------------------

(feature ack
  (require 'ack)
  (global-set-key (kbd "A-F") 'ack))

;;-----[ Aquamacs ]------------------------------------------------------------

(when (boundp 'aquamacs-version)
  (tabbar-mode nil))

(feature edit-server
  (when (boundp 'aquamacs-version)
    (require 'edit-server)
    (setq edit-server-new-frame nil)
    (edit-server-start)))


;;-----[ Ido ]------------------------------------------------------------

(feature ido
  (when (boundp 'aquamacs-version)
    (require 'ido)
    (ido-mode t)
    (setq ido-create-new-buffer 'always)
    (setq ido-enable-flex-matching t)))

;;-----[ Yasnippet ]-----------------------------------------------------------

(feature yasnippet
  (when window-system
    (require 'yasnippet)
    (yas/initialize)
    (yas/load-directory (concat *emacs-config-directory* "/snippets"))))

;;-----[ erlang ]---------------------------------------------------------------

(feature erlang
  (setq load-path (cons "/usr/local/lib/erlang/lib/tools-2.6.4/emacs" load-path))
  (setq erlang-root-dir "/usr/local/lib/erlang")
  (setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
  (require 'erlang-start))

;;-----[ rails ]---------------------------------------------------------------

(feature rails
  (when window-system
    (add-path "emacs-rails")
    (require 'rails)))

;; (add-path "rinari")
;; (add-path "rhtml")
;; (require 'rhtml-mode)
;; (autoload 'rinari-launch "rinari" nil t)
;; (add-hook 'rhtml-mode-hook (lambda () (rinari-launch)))

;;-----[ Speedbar ]------------------------------------------------------------

(feature speedbar
  (when window-system
    (autoload 'speedbar "speedbar" nil t)
    (eval-after-load "speedbar"
      '(progn (speedbar-disable-update)))
    (global-set-key "\C-c\C-s" 'speedbar)))

;;-----[ Color Theme ]---------------------------------------------------------

(feature color-theme
  (when window-system
    (require 'color-theme)
    (when (fboundp 'color-theme-initialize)
      (color-theme-initialize))
    (setq color-theme-is-global t)
    (load-file (concat site-lisp-path "/color-theme-wombat.el"))
    (load-file (concat site-lisp-path "/color-theme-bombat.el"))
    (load-file (concat site-lisp-path "/color-theme-github.el"))
  ; (load-file (concat site-lisp-path "/color-theme-twilight/color-theme-twilight.el"))
  ; (load-file (concat site-lisp-path "/color-theme-ir-black/color-theme-ir-black.el"))
  ;  (color-theme-twilight))
  ;  (color-theme-ir-black))
    (color-theme-bombat)))

;;-----[ Font Settings ]-------------------------------------------------------

(when (and window-system
           (not (boundp 'aquamacs-version)))
  (set-default-font (concat *default-font* "-10"))
  (defun dbl:change-font-size (arg)
    (interactive "P")
    (set-default-font (concat *default-font* "-" (number-to-string arg))))
  (global-set-key "\C-cf" 'dbl:change-font-size))

(when (boundp 'aquamacs-version)
  (one-buffer-one-frame-mode 0)
  (setq mac-allow-anti-aliasing nil)
  ;; M-x mac-font-panel, describe-font
  (set-default-font
;   "-apple-proggycleantt-medium-r-normal--16-0-72-72-m-0-iso10646-1"))
    "-apple-pragmata tt-medium-r-normal--12-0-72-72-m-0-iso10646-1"))

;; just a hack until I figure out aquamacs fonts :/
(global-set-key "\C-c6"
                '(lambda () (interactive) (set-default-font
                             "-apple-pragmata tt-medium-r-normal--12-0-72-72-m-0-iso10646-1")))


;;-----[ Custom ]--------------------------------------------------------------

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(diff-added ((t (:foreground "#559944"))))
 '(diff-context ((t nil)))
 '(diff-file-header ((((class color) (min-colors 88) (background dark)) (:foreground "RoyalBlue1"))))
 '(diff-function ((t (:foreground "#00bbdd"))))
 '(diff-header ((((class color) (min-colors 88) (background dark)) (:foreground "RoyalBlue1"))))
 '(diff-hunk-header ((t (:foreground "#fbde2d"))))
 '(diff-nonexistent ((t (:inherit diff-file-header :strike-through nil))))
 '(diff-refine-change ((((class color) (min-colors 88) (background dark)) (:background "#182042"))))
 '(diff-removed ((t (:foreground "#de1923"))))

 '(default ((t (:slant normal :weight normal :height 120 :family "pragmata tt"))) t)
 '(mode-line ((t (:inherit default))) t)
 '(minibuffer ((t (:inherit default))) t)
 '(minibuffer-prompt ((t (:inherit default))) t)
 '(echo-area ((t (:inherit default))) t)
 '(mode-line-inactive ((t (:inherit default))) t))

;;-----[ RVM ]-----------------------------------------------------------------

(feature rvm
  (require 'rvm)
  (rvm-use-default))

;;-----[ Eshell ]--------------------------------------------------------------

(feature eshell
  (require 'eshell)
  (require 'em-smart)
  (setq eshell-where-to-jump 'begin)
  (setq eshell-review-quick-commands nil)
  (setq eshell-smart-space-goes-to-end t)
   
  (defmacro runner-genner (alias command title)
    `(defun ,alias (&rest args)
       (let* ((cmd1 (cons ,command args))
              (cmd2 (eshell-flatten-and-stringify cmd1))
              (display-type (framep (selected-frame))))
         (cond
          ((and (eq display-type 't) (getenv "STY"))
           (send-string-to-terminal (format "\033]83;screen %s\007" cmd2)))
          ((eq display-type 'x)
           (eshell-do-eval (eshell-parse-command (format "rxvt -e %s &" cmd2)))
           nil)
          (t
           (apply 'eshell-exec-visual cmd1))))))
   
  (runner-genner eshell/ss "script/server"  "%SERVER")
  (runner-genner eshell/sc "script/console" "%CONSOLE"))

;;-----[ Magit ]---------------------------------------------------------------

(feature magit
  (autoload 'magit-status "magit" nil t)
  (global-set-key "\C-qs"    'magit-status)
  (global-set-key "\C-q\C-s" 'magit-status)
  (global-set-key "\C-ql"    'magit-log)
  (global-set-key "\C-q\C-l" 'magit-log)
  (global-set-key "\C-q\C-r" 'magit-goto-next-section)
  (global-set-key "\C-q\C-]" 'magit-toggle-section)
  (global-set-key "\C-qh"    'magit-reflog))

;;-----[ Gist ]----------------------------------------------------------------

;; Gist.el defvar's github-username and github-api-key to "", so I do a little
;; trickery here to use the previously assigned values, if any.
(feature gist
  (if (and (boundp 'github-username) (boundp 'github-api-key))
    (let ((user-username github-username)
          (user-api-key  github-api-key))
      (require 'gist)
      (setq github-username user-username
            github-api-key user-api-key))
    (require 'gist)))

;;-----[ Cedet ]---------------------------------------------------------------

(feature cedet
  (load-file (concat site-lisp-path "cedet-1.0pre4/common/cedet.el"))
  (semantic-load-enable-code-helpers))

;;-----[ Clojure ]-------------------------------------------------------------

(feature clojure
  (add-path "slime")
  (add-path "swank-clojure")
  (add-path "clojure-mode")
  (require 'slime)
  (require 'swank-clojure)
  (require 'clojure-mode)
  (clojure-slime-config)
  (add-to-list 'swank-clojure-extra-classpaths "~/src/jars/*"))

;; (add-hook 'slime-mode-hook
;;           '(lambda() (local-set-key "\C-j"
;;                                     'slime-eval-print-last-expression)))

;;-----[ Browse-kill-ring ]----------------------------------------------------

(require 'browse-kill-ring)
(global-set-key "\C-c\C-k" 'browse-kill-ring)

;;-----[ Custom-set-variables ]------------------------------------------------

(custom-set-variables
  '(global-font-lock-mode    t nil (font-lock)) ;; Syntax higlighting
  ;; buffers with duplicate names will be dir/file, not file<n>
  '(uniquify-buffer-name-style (quote forward) nil (uniquify))
  '(minibuffer-max-depth     nil)        ;; enable multiple minibuffers
  '(indent-tabs-mode         nil)        ;; soft tabs
  '(default-tab-width        2)          ;; tabs of width 8
  '(scroll-bar-mode          nil)        ;; no scroll bar
  '(tool-bar-mode            nil)        ;; eww. bad.
  '(menu-bar-mode            nil)        ;; eww. bad.
  '(column-number-mode       t)          ;; show column number in mode line
  '(show-paren-mode          t)          ;; highlight matching paren on hover
  '(case-fold-search         t)          ;; case-insensitive search
  '(transient-mark-mode      t)          ;; highlight the marked region
  '(inhibit-startup-screen   t)
  '(inhibit-startup-message  t)          ;; no startup message
  '(default-major-mode       'text-mode) ;; open unknown in text mode
  '(ring-bell-function       'ignore)    ;; turn off system beep
  '(c-default-style          "bsd")     ;; use k&r style for C indentation
  '(ruby-deep-arglist        nil)
  '(ruby-deep-indent-paren   nil)
  '(ruby-deep-indent-paren-style nil)
  '(default-major-mode (quote text-mode)))

;;-----[ Timestamp autoupdating ]----------------------------------------------

(feature timestamp
  ;; When files have "Modified: <>" in their first 8 lines, fill it in on save.
  (add-hook 'before-save-hook 'time-stamp)
  (setq time-stamp-start  "Modified:[   ]+\\\\?[\"<]+")
  (setq time-stamp-end    "\\\\?[\">]")
  (setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %Z"))

;;-----[ Tab key behaviour ]---------------------------------------------------

(feature smart-tab
  (require 'hippie-exp)

  (setq hippie-expand-try-functions-list
        '(yas/hippie-try-expand
          try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-complete-file-name
          try-complete-lisp-symbol))

  (defun dbl:smart-tab ()
    "If mark is active, indents region. Else if point is at the end of a symbol,
   expands it. Else indents the current line. Acts as normal in minibuffer."
    (interactive)
     ;(if (yas/next-field)
     ;   ()
      (if (boundp 'ido-cur-item)
          (ido-complete)
        (if (minibufferp)
            (minibuffer-complete)
          (if mark-active
              (indent-region (region-beginning) (region-end))
            (if (and (looking-at "\\_>") (not (looking-at "end")))
                (hippie-expand nil)
              (indent-for-tab-command))))))

  (global-set-key [(tab)] 'dbl:smart-tab))

;;-----[ Training wheels ]-----------------------------------------------------

(feature training-wheels
  (global-set-key (kbd "<down>")  '())
  (global-set-key (kbd "<up>")    '())
  (global-set-key (kbd "<right>") '())
  (global-set-key (kbd "<left>")  '()))


;;-----[ Name/date insertion ]-------------------------------------------------

(defun dbl:sign ()
  (interactive)
  (insert (concat " --" *short-name* "@" 
                  (format-time-string "%Y-%m-%d"))))
(global-set-key "\C-c[" 'dbl:sign)

(defun dbl:insert-name-email ()
  (interactive)
  (insert (concat *user-name* " <" *user-email* ">")))
(global-set-key "\C-ce" 'dbl:insert-name-email)

(defun dbl:insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
  two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
        ((not prefix) "%Y-%m-%d")
        ((equal prefix '(4)) "%d.%m.%Y")
        ((equal prefix '(16)) "%A, %d. %B %Y")))
      (system-time-locale "en_US"))
    (insert (format-time-string format))))
(global-set-key "\C-cd" 'dbl:insert-date)


;;-----[ Miscellaneous Keybinds ]----------------------------------------------

(global-set-key "\C-q" (make-sparse-keymap))
(global-set-key "\C-q\C-q" 'quoted-insert)

(global-set-key "\C-q\C-c" 'eshell)
(global-set-key "\C-q0" 'linum-mode)

(global-set-key (kbd "C-=") 'undo)
(global-set-key "\C-h" 'delete-backward-char)


(global-set-key "\C-c\C-r" 'align-regexp)

(put 'scroll-left 'disabled nil)

(defun dbl:dired (&optional arg)
  (interactive "P")
  (if arg
      (ido-dired)
      (dired ".")))

(global-set-key "\C-x\C-d"   'dbl:dired)

(global-set-key "\C-c\C-f"   'fill-region)

;; How did I live without this?
(global-set-key "\C-w"       'backward-kill-word)
(global-set-key "\C-x\C-k"   'kill-region)

;; Select all. Apparently some morons bind this to C-a.
(global-set-key "\C-c\C-a"   'mark-whole-buffer)

(global-set-key "\C-ct"      '(lambda () (interactive) (ansi-term "/bin/zsh")))

;; Alternative to RSI-inducing M-x, and extra insurance.
(global-set-key "\C-xm"      'execute-extended-command)
(global-set-key "\C-cm"      'execute-extended-command)
(global-set-key "\C-x\C-m"   'execute-extended-command)
(global-set-key "\C-c\C-m"   'execute-extended-command)

(global-set-key "\C-x\C-r"   'query-replace-regexp)

(global-set-key "\C-cw"      'toggle-truncate-lines)

(global-set-key "\C-cg"      'goto-line)
(global-set-key "\C-cG"      'goto-char)

;; I'll take "functions that should have keybindings" for 100, Alex.
(global-set-key "\C-cc"      'comment-region)
(global-set-key "\C-cu"      'uncomment-region)

;; Next and previous for grep and compile errors
(global-set-key "\C-cn"      'next-error)
(global-set-key "\C-cp"      'previous-error)

;; Disable right click. yuck.
(global-set-key (kbd "<down-mouse-2>")  '())
(global-set-key (kbd "<mouse-2>")       '())

;;-----[ Backups and autosaves ]-----------------------------------------------

(setq
  backup-by-copying      t   ;; don't clobber symlinks
  backup-directory-alist     ;; don't litter
    '(("." .  "~/.emacs.d/autosaves/"))
  delete-old-versions    t
  kept-new-versions      6
  kept-old-versions      2
  version-control        t)  ;; use versioned backups

;;-----[ Autoindent ]----------------------------------------------------------

(defun dbl:set-autoindent (hooks)
  (when hooks
    (add-hook (car hooks)
              (lambda () (local-set-key "\C-m" 'newline-and-indent)))
    (dbl:set-autoindent (cdr hooks))))

(dbl:set-autoindent '(clojure-mode-hook
                      c-mode-common-hook
                      ruby-mode-hook
                      java-mode-hook
                      python-mode-hook
                      lisp-mode-hook
                      yaml-mode-hook))

;;-----[ Autoload and auto-mode ]----------------------------------------------

(feature starter-kit-js
  (require 'starter-kit-js))

(autoload 'js2-mode  "js2-mode"  nil t)
(setq js2-basic-offset 2)

(setq-default c-basic-offset 2)

(autoload 'ruby-mode     "ruby-mode" nil t)
(autoload 'objj-mode     "objj-mode" nil t)
(autoload 'haml-mode     "haml-mode" nil t)
(autoload 'markdown-mode "markdown-mode" nil t)
(autoload 'textile-mode  "textile-mode" nil t)
(autoload 'yaml-mode     "yaml-mode" nil t)
(autoload 'sass-mode     "sass-mode" nil t)

(setq auto-mode-alist
  (nconc
    '(("COMMIT_EDITMSG$" . diff-mode))
    '(("\\.xml$"         . nxml-mode))
    '(("\\.html$"        . nxml-mode))
    '(("\\.erl$"         . erlang-mode))
    '(("\\.m$"           . objc-mode))
    '(("\\.haml$"        . haml-mode))
    '(("\\.yml$"         . yaml-mode))
    '(("\\.yaml$"        . yaml-mode))
    '(("\\.json$"        . yaml-mode))
    '(("\\.mustache$"    . mustache-mode))
    '(("\\.rb$"          . ruby-mode))
    '(("\\.gemspec$"     . ruby-mode))
    '(("\\.md$"          . markdown-mode))
    '(("\\.textile$"     . textile-mode))
    '(("\\.zsh$"         . sh-mode))
    '(("\\.sass$"        . sass-mode))
    '(("\\.js$"          . js2-mode))
    '(("\\.j$"           . objj-mode))
    '(("\\.rake$"        . ruby-mode))
    '(("Gemfile$"        . ruby-mode))
    '(("Rakefile$"       . ruby-mode))
    '(("Capfile$"        . ruby-mode))
    auto-mode-alist))

(setq magic-mode-alist ())

;;-----[ Very miscellaneous ]--------------------------------------------------

(when window-system
  (global-unset-key "\C-z"))

(setq tramp-default-method "scpc")

(set-register ?E '(file . "~/.emacs.d/emacs-init.el")) ;; C-x r j E
(set-register ?Z '(file . "~/.config.d/zsh/zshrc.zsh")) ;; C-x r j Z
(set-register ?A '(file . "~/.config.d/zsh/aliases.zsh")) ;; C-x r j A

(add-hook 'text-mode-hook 'turn-off-auto-fill)

;; Don't ask me 'yes' or 'no'. Ask me 'y' or 'n'.
(fset 'yes-or-no-p 'y-or-n-p)

(defun highlight-todo ()
  (font-lock-add-keywords nil
    '(("\\(REVIEW\\|FIXME\\|TODO\\|BUG\\)" 1 font-lock-warning-face t))))
(add-hook 'c-mode-common-hook 'highlight-todo)
(add-hook 'ruby-mode-hook 'highlight-todo)


(global-set-key (kbd "<f8>") 'recompile)

;;-----[ Housekeeping ]--------------------------------------------------------

(message "Loaded .emacs in %ds" (destructuring-bind (hi lo ms) (current-time)
  (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))

(setq debug-on-error nil)

