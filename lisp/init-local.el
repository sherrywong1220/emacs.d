;;; init-local.el --- Set your own config here
;;; Commentary:

;;; Add your own configuration to this file

;;; Code:

;;----------------------------------------------------------------------------
;; set default font
;;----------------------------------------------------------------------------
(add-to-list 'default-frame-alist '(font . "SF Mono-14"))


;;---------------------------------------------------------------------------
;; emacs server srart
;;---------------------------------------------------------------------------
(server-start)

;;---------------------------------------------------------------------------
;; stop create confusing files
;;---------------------------------------------------------------------------
(setq create-lockfiles nil)  ; stop creating .#lock files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files



;;---------------------------------------------------------------------------
;; stop save desktop
;;---------------------------------------------------------------------------
(desktop-save-mode 0)



;;---------------------------------------------------------------------------
;; dired settings
;;---------------------------------------------------------------------------
(setq diredfl-global-mode nil)




;;---------------------------------------------------------------------------
;; auto refresh buffer upon git checkout
;;---------------------------------------------------------------------------
(global-auto-revert-mode t)
(setq auto-revert-check-vc-info t)



;;---------------------------------------------------------------------------
;; flycheck settings
;;---------------------------------------------------------------------------
;; (setq flycheck-ruby-rubocop-executable "/usr/local/lib/ruby/gems/2.6.0/bin/rubocop")
;; (setq-default flycheck-disabled-checkers '(ruby-rubocop))


;;---------------------------------------------------------------------------
;; evil mode settings
;;---------------------------------------------------------------------------
(require 'evil)
(evil-mode 1)
(require 'evil-matchit)
(global-evil-matchit-mode 1)


;;---------------------------------------------------------------------------
;; helm settings
;;---------------------------------------------------------------------------
(setq helm-ag-fuzzy-match t)


;;---------------------------------------------------------------------------
;; helm-projectile settings
;;---------------------------------------------------------------------------
(require 'helm-projectile)
(helm-projectile-on)


;;---------------------------------------------------------------------------
;; custom function
;;---------------------------------------------------------------------------
(defun copy-buffer-file-name-as-kill (choice)
  "Copyies the buffer {name/mode}, file {name/full path/directory} to the kill-ring."
  (interactive "cCopy (b) buffer name, (m) buffer major mode, (f) full buffer-file path, (d) buffer-file directory, (n) buffer-file basename")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          ((eq choice ?b)
           (setq new-kill-string (buffer-name)))
          ((eq choice ?m)
           (setq new-kill-string (format "%s" major-mode)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string))))

;;---------------------------------------------------------------------------
;; custom function
;;---------------------------------------------------------------------------
(require 'dired-x)

;;---------------------------------------------------------------------------
;; org-mode settings
;;---------------------------------------------------------------------------
(defvar org-agenda-dir ""
  "gtd org files location")

(defvar deft-dir ""
  "deft org files locaiton")

(defvar blog-admin-dir ""
  "blog-admin files location")

(setq org-agenda-start-on-weekday 1)

(setq
 org-agenda-dir "~/Documents/org"
 deft-dir "~/Documents/org"
 blog-admin-dir "~/Documents/sherrywong.com")

;;load sensitive data
;; or (like spacemacs init.el)put the above variable into it ,then the own value separated from public config
;; .emacs.secrets.el for example:
;; (setq-default
;;  org-agenda-dir "~/Dropbox/Apps/emacs/gtd"
;;  deft-dir "~/Dropbox/Apps/emacs/notes"
;;  blog-admin-dir "~/Documents/hexo"
;;  )
;; (slack-register-team
;;   :name "emacs-slack"
;;   :default t
;;   :client-id "xxxxxxxxx"
;;   :client-secret "xxxxxxxxx"
;;   :token "xxxxxxxxx"
;;   :subscribed-channels '(xxxxxxxxx))
;; (setq paradox-github-token "")
;; (load "~/Dropbox/Apps/emacs/.emacs.secrets.el" t)

;; define the refile targets
(setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
(setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
(setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
(setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
(setq org-default-notes-file (expand-file-name "gtd.org" org-agenda-dir))
(setq org-agenda-files (list org-agenda-dir))


;; the %i would copy the selected text into the template
;;http://www.howardism.org/Technical/Emacs/journaling-org.html
;;add multi-file journal
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-agenda-file-gtd "Tasks")
         "* TODO [#B] %?\n  %i\n %U"
         :empty-lines 1)
        ("n" "notes" entry (file+headline org-agenda-file-note "Quick notes")
         "* %?\n  %i\n %U"
         :empty-lines 1)
        ("b" "Blog Ideas" entry (file+headline org-agenda-file-note "Blog Ideas")
         "* TODO [#B] %?\n  %i\n %U"
         :empty-lines 1)
        ("s" "Code Snippet" entry
         (file org-agenda-file-code-snippet)
         "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
        ("w" "work" entry (file+headline org-agenda-file-gtd "Work")
         "* TODO [#A] %?\n  %i\n %U"
         :empty-lines 1)
        ("c" "Chrome" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n %(zilongshanren/retrieve-chrome-current-tab-url)\n %i\n %U"
         :empty-lines 1)
        ("l" "links" entry (file+headline org-agenda-file-note "Quick notes")
         "* TODO [#C] %?\n  %i\n %a \n %U"
         :empty-lines 1)
        ("j" "Journal Entry"
         entry (file+datetree org-agenda-file-journal)
         "* %?"
         :empty-lines 1)))

;;An entry without a cookie is treated just like priority ' B '.
;;So when create new task, they are default 重要且紧急
(setq org-agenda-custom-commands
      '(
        ("w" . "任务安排")
        ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
        ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
        ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
        ("b" "Blog" tags-todo "BLOG")
        ("p" . "项目安排")
        ("pw" tags-todo "PROJECT+WORK+CATEGORY=\"cocos2d-x\"")
        ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"zilongshanren\"")
        ("W" "Weekly Review"
         ((stuck "") ;; review stuck projects as designated by org-stuck-projects
          (tags-todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
          ))))


(provide 'init-local)

;;; init-local.el ends here
