;; there is no reason to do downloading in the gui init.
;; Key bindings
(require 'evil)
(evil-mode 1)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "s-o") 'lsp)
(global-set-key (kbd "M-RET") 'vterm)
(global-set-key (kbd "M-q") 'kill-this-buffer) ;; this must kill the buffer that im in 

(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "s-a") 'split-window-right)
(global-set-key (kbd "s-s") 'split-window-below)



(require 'which-key)
(which-key-mode 1)

;; Frame settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(set-frame-parameter nil 'alpha-background 70)
(add-to-list 'default-frame-alist '(alpha-background . 70))
(setq ring-bell-function 'ignore)



;; Theme setup
(require 'naga-theme)
(load-theme 'naga t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(add-hook 'after-init-hook 'dashboard-open)
(global-display-line-numbers-mode)

(require 'simple-modeline)
(simple-modeline-mode t)



;; code themeing
(setq-default tab-width 2)
(setq-default standard-indent 2)
(setq-default indent-tabs-mode nil) 


;; lsp stuff
(add-hook 'java-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(setq lsp-clients-clangd-executable "clangd")





(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'lsp-mode-hook 'company-mode)
(setq company-minimum-prefix-length 2
      company-idle-delay 0.5)


(global-flycheck-mode)

(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)

(require 'corfu)
(setq corfu-cycle t
      corfu-auto t
      corfu-auto-delay 0.0
      corfu-auto-prefix 1
      corfu-scroll-margin 2)
(global-corfu-mode)

(require 'kind-icon)
(setq kind-icon-default-face 'corfu-default)
(add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(mini- neotree vterm which-key simple-modeline naga-theme lsp-ui lsp-java kind-icon flycheck evil dashboard corfu company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
