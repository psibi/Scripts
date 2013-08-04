(load-theme 'wheatgrass t)
(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
(require 'package)

(setq package-archives
      '(("gnu"         . "http://elpa.gnu.org/packages/")
        ("original"    . "http://tromey.com/elpa/")
        ("org"         . "http://orgmode.org/elpa/")
        ("marmalade"   . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(menu-bar-mode -1)
(tool-bar-mode -1)

;;Install ecb-snapshot from M-x package-list-packages
(require 'ecb)
(setq stack-trace-on-error t)

;;Install Window-number mode - Use M-1,M-2 to jump between windows
(require 'window-number)
(window-number-meta-mode)

;;Install auto-complete and autopair
(require 'auto-complete)
(require 'autopair)
(require 'auto-complete-config)
(ac-config-default)
(autopair-global-mode) ;; enable autopair in all buffers

;;Tramp for editing protected files in existing Emacs session.(C-x C-f /sudo)
(require 'tramp)
(setq tramp-default-method "ssh")

;;Fullscreen mode - Press M-x fullscreen for switching to Fullscreen mode.
(defun fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

;;Maximize Screen
(defun maximize (&optional f)
       (interactive)
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
       (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

(maximize)

;; Bind C-c C-r key for refreshing of a file
(global-set-key (kbd "C-c C-r") 'revert-buffer)
(global-set-key (kbd "C-x p") 'package-list-packages-no-fetch)

;;Python Development Environment
;;Install jedi for Auto-completion in Python mode. For key bindings see: C-h v jedi:setup-keys
;; Install 3 Python dependencies: sudo pip install jedi epc argparse
;; Install 3 Emacs ELPA packages: epc deferred auto-complete
;; Clone a directory named jedi into elpa from: git://github.com/tkf/emacs-jedi.git
(add-to-list 'load-path "~/.emacs.d/elpa/jedi")
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)

;;SML MODE (Need to change the path manually. Set it where you can locate `sml`)
(setenv "PATH" (concat "/home/sibi/Downloads/bin:" (getenv "PATH")))
(setq exec-path (cons "/home/sibi/Downloads/bin" exec-path))

; -== Ensime ==- (Change path manually) 
;; Install scala-mode form ELPA. You need to install ensime separetly after that.
;; This may help: http://jawher.net/2011/01/17/scala-development-environment-emacs-sbt-ensime/
(require 'scala-mode)
(add-to-list 'auto-mode-alist '("\.scala$" . scala-mode))
(add-to-list 'load-path "/home/sibi/Downloads/Softwares/ensime_2.10.0-RC3-0.9.8.2/elisp/")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(push "/usr/bin" exec-path)
(push "/home/sibi/Downloads/Softwares/sbt/bin/" exec-path)

