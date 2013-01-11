(load-theme 'wheatgrass t)
(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

;;Install ecb-snapshot from M-x package-list-packages
(require 'ecb)
(setq stack-trace-on-error t)

;;Install Window-number mode - Use M-1,M-2 to jump between windows
(require 'window-number)
(window-number-meta-mode)
