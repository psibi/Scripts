(load-theme 'wheatgrass t)
(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

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
;;Install Rope, Ropemode, Ropemacs (sudo pip install rope ropemode ropemacs)
;;Pymacs from ELPA doesn't work. Copy latest tar from https://github.com/pinard/Pymacs/ to some location.
;;Rename untarred folder to pinard-pymacs and move it to ~/.emacs.d/elpa. Run make and sudo python setup.py install on it.
(add-to-list 'load-path "~/.emacs.d/elpa/pinard-pymacs")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

