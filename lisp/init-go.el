;;; init-go.el --- Support for the Go language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Basic go setup
(require-package 'go-mode)
(require-package 'go-eldoc)
(require-package 'go-guru)
(require-package 'go-rename)

;; (ac-config-default)

(defun go-mode-setup ()
  (go-eldoc-setup)
  (go-guru-hl-identifier-mode)
  (setq tab-width 4)
  (setq gofmt-command "goimports")
  (setq compile-command "go build -v && go test -v && go vet")
  (add-hook 'before-save-hook 'gofmt-before-save))
(add-hook 'go-mode-hook 'go-mode-setup)

(when (maybe-require-package 'company-go)
  (after-load 'company
    (push 'company-go company-backends)))

(provide 'init-go)
;;; init-go.el ends here
