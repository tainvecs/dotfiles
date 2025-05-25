;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar my-init-el-start-time (current-time) "Time when init.el was started")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs Home Directories
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; emacs home
(setq user-init-file                  (or load-file-name
                                          (buffer-file-name)))
(setq user-emacs-directory            (or (getenv "EMACS_HOME")
                                          (file-name-directory user-init-file)))
(setq default-directory               user-emacs-directory)

;; user directories
(defconst user-cache-directory        (or (expand-file-name "emacs/" (getenv "XDG_CACHE_HOME"))
                                          user-emacs-directory))
(defconst user-state-directory        (or (expand-file-name "emacs/" (getenv "XDG_STATE_HOME"))
                                          user-emacs-directory))

(defconst user-auto-save-directory    (expand-file-name "auto-save-list/" user-cache-directory))
(defconst user-backup-directory       (expand-file-name "backup/" user-state-directory))
(defconst user-package-directory      (expand-file-name "packages/" user-emacs-directory))

;; recent file
(defvar recentf-save-file               (expand-file-name "recentf" user-state-directory))

;; history
(defvar savehist-file                   (expand-file-name "history" user-state-directory))

;; auto-save-list
(setq auto-save-list-file-prefix      user-auto-save-directory)
(setq auto-save-file-name-transforms  `((".*" ,auto-save-list-file-prefix t)))

;; backup
(setq backup-directory-alist          `((".*" . ,user-backup-directory)))

;; package directories
(setq package-user-dir                user-package-directory)

;; customized config
(setq custom-file                     (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; dotfiles user config
(defconst init-local-path             (expand-file-name "init.local.el" user-emacs-directory))
(when (file-exists-p init-local-path)
  (load-file init-local-path))

;; make directories
(dolist (dir (list user-auto-save-directory
                   user-backup-directory
                   user-package-directory))
  (unless (file-directory-p dir)
    (make-directory dir t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Disable ls --dired in Dired (e.g., for non-GNU systems)
(defvar dired-use-ls-dired nil)

;; Prevent following symlinks in version-controlled files (security/preference)
(setq vc-follow-symlinks nil)

;; Enable history file usage
(savehist-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(message "→ loading init.el in %.2fs" (float-time (time-subtract (current-time) my-init-el-start-time)))
