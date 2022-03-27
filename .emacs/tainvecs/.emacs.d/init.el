(defvar my-init-el-start-time (current-time) "Time when init.el was started")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Files and Directory I/O Setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq message-log-max 10000)

;; don't load outdated byte code
(setq load-prefer-newer t)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(fset 'yes-or-no-p #'y-or-n-p)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File Encoding Setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq iso-transl-char-map nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File Format Setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Opt out from the startup message in the echo area by simply disabling this
;; ridiculously bizarre thing entirely.
(fset 'display-startup-echo-area-message #'ignore)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(setq ring-bell-function #'ignore
      inhibit-startup-screen t
      initial-scratch-message "")

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(blink-cursor-mode -1)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Wrap lines at 80 characters
(setq-default fill-column 80)

;; overwrite selected region, including paste
(delete-selection-mode 1)

;; delete trailing whitespace when save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Newline at end of file
(setq require-final-newline t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; quit Emacs directly even if there are running processes
(setq confirm-kill-processes nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize Package Directories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar user-setup-directory          (expand-file-name "setup"          user-emacs-directory))
(defvar user-setup-builtins-directory (expand-file-name "setup/builtins" user-emacs-directory))
(defvar local-dev-package-directory   (expand-file-name "packages"       user-emacs-directory))
(defvar user-data-directory           (expand-file-name ""               user-emacs-directory))
(defvar user-cache-directory          (expand-file-name ".cache"         user-emacs-directory))
(defvar user-bin-directory            (expand-file-name "bin"            "~"))
(setq custom-file                     (expand-file-name "settings.el"    user-emacs-directory))
(make-directory user-cache-directory t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize Package and Use-package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             '("gnu" . "https://elpa.gnu.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Require
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'bind-key)
(require 'subr-x)
(require 'time-date)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cursor and Indent
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this))


;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))


;; Highlight cursor position in buffer
(use-package beacon
  :ensure t
  :init (beacon-mode 1)
  :config
  (setq beacon-push-mark 35)
  (setq beacon-color "#666600")
  :diminish beacon-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General Package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))


(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))


;; Position/matches count for isearch
(use-package anzu
  :ensure t
  :bind
  (([remap query-replace] . anzu-query-replace)
   ([remap query-replace-regexp] . anzu-query-replace-regexp)
   :map isearch-mode-map
   ([remap isearch-query-replace] . anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :init (global-anzu-mode)
  :config (setq anzu-cons-mode-line-p nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File Format
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; add several elements at the end (may create double entries,
;; but that would not hurt)
(setq auto-mode-alist
    (append auto-mode-alist
            '(("\\.zsh\\'" . sh-mode)
              ("\\.sh\\'" . sh-mode))))


(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))


(use-package markdown-mode
  :ensure t
  :mode ("\\.md$" . markdown-mode)
  :init (add-hook 'markdown-mode-hook 'auto-fill-mode))


(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" . dockerfile-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphical User Interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package zenburn-theme
  :ensure t
  :init (load-theme 'zenburn t))
(set-face-attribute 'default nil :height 140)


(use-package all-the-icons
  :ensure t
  :config
  (let ((font-dest (concat (getenv "HOME") "/Library/Fonts/")))
    (unless (file-exists-p (concat font-dest "all-the-icons.ttf"))
      (all-the-icons-install-fonts t))))


(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-side-window-max-width 0.33
        which-key-idle-delay 0.05)
  :diminish which-key-mode)


;; toggle by [F8]
(use-package neotree
  :ensure t
  :after all-the-icons
  :init
  (require 'neotree)
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t)
  (global-set-key [f8] 'neotree-toggle))


(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (global-set-key (kbd "C-c C-r") 'ivy-resume))


(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode))


(use-package swiper
  :ensure t
  :after ivy)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Git and Change Tracking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))


;; Highlight hunks in fringe
(use-package diff-hl
  :ensure t
  :defer t
  :init

  ;; Highlight changes to the current file in the fringe
  (global-diff-hl-mode +1)

  ;; Highlight changed files in the fringe of Dired
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)

  ;; Fall back to the display margin, if the fringe is unavailable
  (unless (display-graphic-p)
    (diff-hl-margin-mode))

  ;; Refresh diff-hl after Magit operations
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))


(use-package undo-tree
  :ensure t
  :config
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
        `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t)
  (global-undo-tree-mode +1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Coding Syntax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Choose wrap prefix automatically
(use-package adaptive-wrap
  :ensure t
  :defer t
  :init (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode))


;; EditorConfig helps maintain consistent coding styles
;; for multiple developers working on the same project
;; across various editors and IDEs.
(use-package editorconfig
  :ensure t
  :config (editorconfig-mode 1))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config

  ;; python: `pip3 install flake8 pylint`
  (setq flycheck-flake8-maximum-line-length 160)

  (global-set-key (kbd "C-c p") 'flycheck-previous-error)
  (global-set-key (kbd "C-c n") 'flycheck-next-error)

  (add-hook 'after-init-hook #'global-flycheck-mode))


(use-package dumb-jump
  :ensure t
  :bind (("M-g j" . dumb-jump-go)
         ("M-g o" . dumb-jump-go-other-window)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JavaScript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package smartparens
  :ensure t
  :config
  (add-hook 'js-mode-hook #'smartparens-mode))


(use-package js-auto-format-mode
  :ensure t
  :config
  (add-hook 'js-mode-hook #'js-auto-format-mode))


(use-package add-node-modules-path
  :ensure t
  :config
  (add-hook 'js-mode-hook #'add-node-modules-path))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :init
  ;;(add-hook 'clojure-mode-hook #'yas-minor-mode)
  (add-hook 'clojure-mode-hook #'linum-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'smartparens-mode)
  ;;(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode)
  ;;(add-hook 'clojure-mode-hook #'idle-highlight-mode)
  )


(use-package cider
  :ensure t
  :defer t
  :diminish subword-mode
  :config
  (setq cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t
        cider-prompt-save-file-on-load 'always-save
        cider-font-lock-dynamically '(macro core function var)
        nrepl-hide-special-buffers t
        cider-overlays-use-font-lock t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Go
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package go-mode
  :ensure t
  :mode (("\\.go\\'" . go-mode))
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook
          (lambda ()
            (setq go-packages-function 'go-packages-go-list)
            (setq indent-tabs-mode nil)
            (setq tab-width 2))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Commented
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable))


;; (use-package ace-window
;;   :ensure t
;;   :config
;;   (global-set-key (kbd "M-o") 'ace-window))


;; (use-package company
;;   :ensure t
;;   :config
;;   (add-hook 'after-init-hook 'global-company-mode))


(message "→ loading init.el in %.2fs" (float-time (time-subtract (current-time) my-init-el-start-time)))
