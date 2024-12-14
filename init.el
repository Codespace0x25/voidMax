;; Ensure `package` is initialized
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Install missing packages
(dolist (pkg '(exwm evil which-key ivy naga-theme doom-modeline nix-modeline
                  lsp-mode lsp-ui company smartparens vterm company-box pipewire ))
  (unless (package-installed-p pkg)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install pkg)))

;; Load core packages
(require 'exwm)
(require 'evil)
(require 'which-key)
(require 'ivy)
(require 'naga-theme)
(require 'doom-modeline)
(require 'nix-modeline)
(require 'vterm)
(require 'company)
(require 'lsp)
(require 'lsp-ui)
(require 'smartparens-config)
(require 'pipewire)

;; Enable company-mode globally
(global-company-mode 1)

;; Configure company settings
(setq company-idle-delay 0.2)  ;; Time before suggestions appear
(setq company-minimum-prefix-length 2)  ;; Trigger completions after 2 characters
(setq company-tooltip-align-annotations t)  ;; Align annotations to the right
(setq company-tooltip-flip-when-above t)   ;; Flip tooltip if above cursor

;; Enable company-box for enhanced completion UI
(add-hook 'company-mode-hook 'company-box-mode)
;; Configure company backends (using `company-capf` for LSP integration)
(setq company-backends '((company-capf company-files)))

;; Keybindings for company
(define-key evil-normal-state-map (kbd "C-c C-c") 'company-complete)

;; LSP configuration for C/C++
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(setq lsp-clients-clangd-executable "clangd")
(setq lsp-prefer-capf t)  ;; Use completion-at-point for better integration

;; Enable LSP UI features
(setq lsp-ui-doc-enable t)
(setq lsp-ui-doc-position 'at-point)
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover t)
(add-hook 'c-mode-hook 'lsp-ui-mode)
(add-hook 'c++-mode-hook 'lsp-ui-mode)

;; Smartparens configuration for automatic bracket pairing
(add-hook 'prog-mode-hook 'smartparens-mode)
(add-hook 'text-mode-hook 'smartparens-mode)
(show-paren-mode 1)

;; Doom modeline setup
(doom-modeline-mode 1)
(nix-modeline-mode 1)

(load-theme 'naga 1)  ;; Load custom theme
(menu-bar-mode -1)    ;; Disable the menu bar
(tool-bar-mode -1)    ;; Disable the tool bar
(scroll-bar-mode -1)  ;; Disable the scroll bar
(global-set-key (kbd "C-c C-e") 'eval-buffer)

;; Enable Evil Mode for vim-like keybindings
(evil-mode 1)

;; Enable Which-key for keybinding hints
(which-key-mode 1)

;; Enable Ivy for better completions
(ivy-mode 1)

;; EXWM setup (workspace, simulation keys, etc.)
(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))
(setq exwm-input-simulation-keys
      '(([?\C-b] . left)
        ([?\C-f] . right)
        ([?\C-p] . up)
        ([?\C-n] . down)
        ([?\C-a] . home)
        ([?\C-e] . end)
        ([?\M-v] . prior)
        ([?\C-v] . next)
        ([?\C-d] . delete)
        ([?\C-k] . (S-end delete))
        ([?\M-w] . C-c)
        ([?\C-w] . C-x)
        ([?\C-y] . C-v)))

;; EXWM RandR setup for multi-monitor configuration

(exwm-systemtray-mode 1)

;; Application launcher with Ivy
(exwm-input-set-key (kbd "s-&")
                    (lambda ()
                      (interactive)
                      (ivy-read "shell: "
                                (split-string (shell-command-to-string "compgen -c"))
                                :action (lambda (cmd)
                                          (start-process-shell-command cmd nil cmd)))))
(defun my/close-exwm-buffer-and-kill ()
  "Close the current EXWM buffer (window) and kill any normal buffers."
  (interactive)
  
  ;; Kill the current EXWM window by switching to another workspace or closing the current one
  (exwm-workspace-delete)
  
  ;; Kill the current buffer (Emacs buffer) if it's not the scratch buffer
  (unless (string= (buffer-name) "*scratch*")
    (kill-buffer)))

(exwm-input-set-key (kbd "s-<return>") 'vterm)
(exwm-input-set-key (kbd "s-p") 'kill-emacs)
(exwm-input-set-key (kbd "s-b") 'ivy-switch-buffer)
(exwm-input-set-key (kbd "s-a") 'ivy-switch-buffer)
(exwm-input-set-key (kbd "s-=") (lambda () (interactive)(pipewire-increase-volume)))
(exwm-input-set-key (kbd "s--") (lambda () (interactive)(pipewire-decrease-volume)))
(exwm-input-set-key (kbd "s-0") (lambda () (interactive)(pipewire-toggle-muted)))

;; Evil mode keybindings for window navigation
(define-key evil-normal-state-map (kbd "s-h") 'windmove-left)
(define-key evil-normal-state-map (kbd "s-l") 'windmove-right)
(define-key evil-normal-state-map (kbd "s-j") 'windmove-down)
(define-key evil-normal-state-map (kbd "s-k") 'windmove-up)
(defun my/evil-quit-advice (&rest _)
  "Prevent `evil-quit` from closing the last frame in EXWM."
  (if (and exwm-enabled
           (= (length (frame-list)) 1) ;; Only one frame
           (= (length (buffer-list)) 1)) ;; Only one buffer
      (message "Cannot close the last buffer while in EXWM!")
    t)) ;; Otherwise, allow quitting

(advice-add 'evil-quit :before-while #'my/evil-quit-advice)

;; Start EXWM
(exwm-enable)

;; Optional: Start an initial buffer (scratch buffer)
(setq initial-buffer-choice t)

;; Keybinding for LSP formatting
(define-key evil-normal-state-map (kbd "C-c f") 'lsp-format-buffer)

;; Keybinding for LSP code actions
(define-key evil-normal-state-map (kbd "C-c a") 'lsp-execute-code-action)

;; Keybinding for code completion (Company mode)
(define-key evil-normal-state-map (kbd "C-c C-c") 'company-complete)

;; Start picom for transparency and effects
(start-process "picom" nil "picom" "-b")
(setq-default line-spacing 2)

;;(setq-default line-spacing 2)
;;Additional setup for better performance (disable GC too early)
(setq gc-cons-threshold (* 50 1000 1000)) ;; 50MB before GC is triggered

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(pipewire company-box vterm nix-modeline nix-mode doom-modeline naga-theme nage ivy which-key exwm evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

