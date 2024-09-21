;; Package setup
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; Ensure required packages are installed
(dolist (pkg '(evil naga-theme lsp-mode  company flycheck lsp-java
                    corfu kind-icon dashboard simple-modeline which-key
                    vterm))
  (unless (package-installed-p pkg)
    (package-install pkg)))
