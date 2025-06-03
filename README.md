
# Table of Contents

1.  [Setup Package](#org79e7c68)
2.  [UI Tweaks](#org89f6303)
3.  [Disable Startup Screen and Bell](#org00efe6f)
4.  [Vertico](#org518c96d)
5.  [Install Doom Theme](#org63d310e)
6.  [Evil, General, and Which-Key](#org980094a)
7.  [Vterm Integration](#orgce14ab2)
8.  [Install general.el for Doom-style keybindings](#orgee7156c)
9.  [Org](#org1f1c30c)
10. [Doom-style Leader Key](#org3671a91)


<a id="org79e7c68"></a>

# Setup Package

    ;; Disable signature checking early to avoid compat.tar.sig errors
    (setq package-check-signature nil)
    
    (require 'package)
    (setq package-archives
          '(("melpa" . "https://melpa.org/packages/")
    	("gnu"   . "https://elpa.gnu.org/packages/")))
    
    (package-initialize)
    
    (unless package-archive-contents
      (package-refresh-contents))
    
    (unless (package-installed-p 'gnu-elpa-keyring-update)
      (package-install 'gnu-elpa-keyring-update))
    
    (gnu-elpa-keyring-update)


<a id="org89f6303"></a>

# UI Tweaks

    ;; Disable the menu bar
    (menu-bar-mode -1)
    
    ;; Disable the tool bar
    (when (fboundp 'tool-bar-mode)
      (tool-bar-mode -1))
    
    ;; Disable the scroll bar
    (when (fboundp 'scroll-bar-mode)
      (scroll-bar-mode -1))
    
    ;; Optional: Disable startup screen
    (setq inhibit-startup-screen t)


<a id="org00efe6f"></a>

# Disable Startup Screen and Bell

    (setq inhibit-startup-message t)
    (setq initial-scratch-message nil)
    (setq ring-bell-function 'ignore)


<a id="org518c96d"></a>

# Vertico

    (use-package vertico
      :ensure t
      :init
      (vertico-mode))
    
    (with-eval-after-load 'vertico
      (define-key vertico-map (kbd "<escape>") #'abort-recursive-edit)
      (define-key vertico-map (kbd "C-j") #'vertico-next)
      (define-key vertico-map (kbd "C-k") #'vertico-previous))
    
    (use-package consult
      :ensure t)
    
    (use-package marginalia
      :ensure t
      :init
      (marginalia-mode))


<a id="org63d310e"></a>

# Install Doom Theme

    (unless (package-installed-p 'doom-themes)
      (package-install 'doom-themes))
    (load-theme 'doom-one t)
    (require 'doom-themes)
    (doom-themes-org-config)


<a id="org980094a"></a>

# Evil, General, and Which-Key

    (unless (package-installed-p 'evil)
      (package-install 'evil))
    (require 'evil)
    (evil-mode 1)
    
    (unless (package-installed-p 'general)
      (package-install 'general))
    (require 'general)
    
    (unless (package-installed-p 'which-key)
      (package-install 'which-key))
    (which-key-mode)


<a id="orgce14ab2"></a>

# Vterm Integration

    ;; Install and require vterm
    (unless (package-installed-p 'vterm)
      (package-refresh-contents)
      (package-install 'vterm))
    (require 'vterm)
    
    ;; Set your preferred shell (optional if your SHELL env is already set)
    (setq vterm-shell "/bin/bash") ;; or "/usr/bin/zsh" or "fish"
    
    ;; Optional: Start in insert mode if using Evil
    (when (bound-and-true-p evil-mode)
      (add-hook 'vterm-mode-hook #'evil-insert-state))
    
    ;; Optional: Close buffer on exit
    (setq vterm-kill-buffer-on-exit t)
    
    ;; Optional: Don't let evil override vterm
    ;; (with-eval-after-load 'evil
      ;; (add-to-list 'evil-emacs-state-modes 'vterm-mode))
    
    ;; Function to open vterm in a horizontal split below
    (defun my/open-vterm-below ()
      "Open vterm in a horizontal split below with a max height of 18 rows."
      (interactive)
      (let* ((buf (get-buffer "*vterm*"))
    	 (total-height (window-total-height))
    	 (split-height (max 4 (- total-height 18))) ;; ensure top window gets at least 4 rows
    	 (win (split-window nil split-height 'below)))
        (select-window win)
        (if buf
    	(switch-to-buffer buf)
          (vterm))))


<a id="orgee7156c"></a>

# Install general.el for Doom-style keybindings

    (unless (package-installed-p 'general)
      (package-install 'general))
    
    (require 'general)


<a id="org1f1c30c"></a>

# Org

    (unless (package-installed-p 'org)
      (package-install 'org))
    (require 'org)


<a id="org3671a91"></a>

# Doom-style Leader Key

    ;; Ensure required packages are loaded
    (require 'general)
    (require 'which-key)
    (which-key-mode)
    
    ;; Define the leader key using general
    (general-create-definer my/leader-keys
      :keymaps '(normal insert visual emacs) ;; Modes to activate in
      :prefix "SPC"
      :global-prefix "C-SPC") ;; C-SPC works even outside evil mode
    
    ;; Now use that definer
    (my/leader-keys
      "f"   '(:ignore t :which-key "files")
      "ff"  '(find-file :which-key "find file")
      "fs"  '(save-buffer :which-key "save file")
    
      "b"   '(:ignore t :which-key "buffers")
      "bb"  '(switch-to-buffer :which-key "switch buffer")
      "bk"  '(kill-this-buffer :which-key "kill buffer")
    
      "w"   '(:ignore t :which-key "windows")
      "ws"  '(split-window-below :which-key "split below")
      "wv"  '(split-window-right :which-key "split right")
      "wd"  '(delete-window :which-key "delete window")
      "wo"  '(delete-other-windows :which-key "only this window")
      "wm"  '(delete-other-windows :which-key "maximize window")
      "wc"  '(delete-window :which-key "close window")
      "wh"  '(windmove-left :which-key "← window")
      "wj"  '(windmove-down :which-key "↓ window")
      "wk"  '(windmove-up :which-key "↑ window")
      "wl"  '(windmove-right :which-key "→ window")
    
      "ot"  '(my/open-vterm-below :which-key "terminal")
    
      "q"   '(:ignore t :which-key "quit")
      "qq"  '(save-buffers-kill-terminal :which-key "quit emacs"))

