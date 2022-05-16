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
(setq user-emacs-directory            (or (concat (getenv "EMACS_HOME") "/")
                                          (file-name-directory user-init-file)))
(setq default-directory               user-emacs-directory)

;; auto-save-list
(setq auto-save-list-file-prefix      (concat user-emacs-directory "auto-save-list/"))
(setq backup-directory-alist          `((".*" . ,auto-save-list-file-prefix)))
(setq auto-save-file-name-transforms  `((".*" ,auto-save-list-file-prefix t)))
(setq vc-follow-symlinks              nil)

;; initialize package directories
(defvar user-data-directory           (expand-file-name ""               user-emacs-directory))
(defvar user-setup-directory          (expand-file-name "setup"          user-emacs-directory))
(defvar user-setup-builtins-directory (expand-file-name "setup/builtins" user-emacs-directory))
(defvar user-bin-directory            (expand-file-name "bin"            user-emacs-directory))
(defvar user-cache-directory          (expand-file-name ".cache"         user-emacs-directory))
(defvar local-dev-package-directory   (expand-file-name "packages"       user-emacs-directory))
(setq package-user-dir                (expand-file-name "packages"       user-emacs-directory))
(setq custom-file                     (expand-file-name "settings.el"    user-emacs-directory))

;; make directories
(make-directory user-setup-builtins-directory t)
(make-directory user-bin-directory            t)
(make-directory user-cache-directory          t)
(make-directory package-user-dir              t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Local
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar init-local-path (expand-file-name "init.el.local" user-emacs-directory))
(unless (not (file-exists-p init-local-path))
  (load-file init-local-path))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(message "→ loading init.el in %.2fs" (float-time (time-subtract (current-time) my-init-el-start-time)))
