;;; init-go -- sumary

(require 'go-eldoc)
(require 'go-mode)
;; (ac-config-default)

(defun go-mode-setup ()
  (go-eldoc-setup)
  (setq gofmt-command "goimports")
  (setq compile-command "go build -v && go test -v && go vet")
  (define-key (current-local-map) "\C-c\C-c" 'compile)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'go-mode-setup)
(provide 'init-go)

;;; init-go.el ends here
