(server-start)

;; for marmalade

(require 'package)
(add-to-list 'package-archives
	     '("marmalade" .
	       "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.milkbox.net/packages/") t)
(package-initialize)

;; General customizations

(setq-default inhibit-startup-message t
	      font-lock-maximum-decoration t
	      visible-bell t
	      require-final-newline t
	      resize-minibuffer-frame t
	      column-number-mode t
	      display-battery-mode t
	      transient-mark-mode t
	      next-line-add-newlines nil
	      blink-matching-paren t
	      quack-pretty-lambda-p t
	      blink-matching-delay 0.25
	      vc-follow-symlinks t
	      indent-tabs-mode t
	      tab-width 8
	      c-basic-offset 8
	      edebug-trace t
	      uniquify-buffer-name-style 'forward
	      save-place t
	      set-fringe-style -1)

(set-face-attribute 'default nil :height 150)
(global-font-lock-mode 1)

;; Remove toolbar, menubar, scrollbar and tooltips

(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-scroll-bar-mode 'nil)

;; for zenburn color theme
(load-theme 'zenburn t)

;; show parentheses
(show-paren-mode t)
(setq show-paren-delay 0)
(require 'paren)
(set-face-background 'show-paren-match-face "#00bfff")
(set-face-foreground 'show-paren-match-face "#fff")
(set-face-attribute 'show-paren-match-face nil :weight 'extra-bold)

;; General mode loading
(savehist-mode t)
(ido-mode t)
(rcirc-track-minor-mode t)
(electric-indent-mode 1)

;; Final newline handling
(setq require-final-newline t)
(setq next-line-extends-end-of-buffer nil)
(setq next-line-add-newlines nil)

;; Custom keybindings
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)

(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)

(global-set-key (kbd "C-c C-c") 'comment-region)

;; Copy & paste to/from other apps
(setq x-select-enable-clipboard t)

;; c-mode
(add-hook 'c-mode-common-hook 'turn-on-filladapt-mode)

(defmacro define-new-c-style (name derived-from style-alists tabs-p match-path)
  `(progn
     (add-hook 'c-mode-common-hook
(lambda ()
(c-add-style ,name
'(,derived-from (c-offsets-alist
,style-alists)))))
     (add-hook 'c-mode-hook
(lambda ()
(let ((filename (buffer-file-name)))
(when (and filename
(string-match (expand-file-name ,match-path) filename))
(setq indent-tabs-mode ,tabs-p)
(c-set-style ,name)))))))

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists with tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

;; Syntax for define-new-c-style:
;; <style name> <derived from> <style alist> <tabs-p> <path to apply to>

(define-new-c-style "linux-tabs-only" "linux" (arglist-cont-nonempty
c-lineup-gcc-asm-reg
c-lineup-arglist-tabs-only) t
"~")

;; ido

(setq
 ido-ignore-buffers ; ignore these guys
 '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido")
 ido-case-fold t ; be case-insensitive
 ido-use-filename-at-point nil ; don't use filename at point (annoying)
 ido-use-url-at-point nil ; don't use url at point (annoying)
 ido-enable-flex-matching t ; be flexible
;; ido-max-prospects 100 ; don't spam minibuffer
 ido-confirm-unique-completion nil ; don't wait for RET with unique completion
 ido-default-file-method 'selected-window ; open files in selected window
 ido-default-buffer-method 'selected-window ; open buffers in selected window
 ido-max-directory-size 100000)

;; Dired

(add-hook 'dired-mode-hook
(lambda ()
(define-key dired-mode-map (kbd "<return>")
'dired-find-alternate-file) ; was dired-advertised-find-file
(define-key dired-mode-map (kbd "^")
(lambda () (interactive) (find-alternate-file "..")))))

(put 'dired-find-alternate-file 'disabled nil)

;; rcirc
(setq rcirc-server-alist
      '(("irc.freenode.net"
	 :port 6667
	 :nick "amrav"
	 :full-name "Vikrant Varma")
	("irc.amrav.net"
	 :port 6667
	 :nick "amrav"
	 :full-name "Vikrant Varma")))

;; Wrap long lines according to the width of the window
(add-hook 'window-configuration-change-hook
          '(lambda ()
(setq rcirc-fill-column (- (window-width) 2))))

(defun rcirc-kill-all-buffers ()
  (interactive)
  (kill-all-mode-buffers 'rcirc-mode))

;; flyspell mode
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(global-set-key (kbd "C-c f") 'flyspell-check-previous-highlighted-word)

;; text mode
(add-hook 'text-mode-hook 'flyspell-mode)

;; autocomplete
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(autoload 'auto-complete-mode "auto-complete-mode")

(global-set-key [C-tab] 'auto-complete)

;; backups
(setq backup-by-copying t
      backup-directory-alist
      '(("." . "~/.saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq auto-save-file-name-transforms
      `((".*", temporary-file-directory t)))

;; ace jump mode

(add-to-list 'load-path "~/.emacs.d/ace-jump-mode/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(global-set-key (kbd "C-c C-j") 'ace-jump-mode)
(global-set-key (kbd "C-x C-j") 'ace-jump-mode)

(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; useful utility functions

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
	(linum-mode 1)
	(goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

(global-set-key [remap goto-line] 'goto-line-with-feedback)

;; Ansi-term
(global-set-key (kbd "C-c C-t") 'ansi-term)

;; to make ansi-term behave nicely

;; exit kills the buffer also

(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; don't ask for the shell

(defvar my-term-shell "/usr/bin/zsh")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

;; use utf-8

(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)

;; make paste work properly

(defun my-term-paste (&optional string)
 (interactive)
 (process-send-string
  (get-buffer-process (current-buffer))
  (if string string (current-kill 0))))

;; no longer necessary in Tango theme

;; improve the colors with solarized theme too
;; (defun my-term-hook ()
;;   (define-key term-raw-map "\C-y" 'my-term-paste)
;;   (let ((base03  "#002b36")
;;         (base02  "#073642")
;;         (base01  "#586e75")
;;         (base00  "#657b83")
;;         (base0   "#839496")
;;         (base1   "#93a1a1")
;;         (base2   "#eee8d5")
;;         (base3   "#fdf6e3")
;;         (yellow  "#b58900")
;;         (orange  "#cb4b16")
;;         (red     "#dc322f")
;;         (magenta "#d33682")
;;         (violet  "#6c71c4")
;;         (blue    "#268bd2")
;;         (cyan    "#2aa198")
;;         (green   "#859900"))
;;     (setq ansi-term-color-vector
;;           (vconcat `(unspecified ,base02 ,red ,green ,yellow ,blue
;;                                  ,magenta ,cyan ,base2)))))


;; (add-hook 'term-mode-hook 'my-term-hook)

;; magit mode

(global-set-key (kbd "C-x g") 'magit-status)

;; whitespace

(require 'whitespace)
(global-set-key (kbd "C-c w") 'global-whitespace-mode)

;; sass mode (used marmalade for haml first?)

;; (add-to-list 'load-path "~/.emacs.d/sass-mode")
;; (require 'sass-mode)
;; (add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))

;; scss mode

(add-to-list 'load-path "~/.emacs.d/scss-mode")
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq scss-compile-at-save nil)

;; for mutt
(fset 'mt
   [?\C-x ?\C-m ?a ?n ?s ?i ?- ?t ?e ?r ?m return ?m ?u ?t ?t return])

(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
(defun my-mail-mode-hook ()
  (auto-fill-mode 1)
  (abbrev-mode 1)
  (local-set-key "\C-Xk" 'server-edit))
(add-hook 'mail-mode-hook 'my-mail-mode-hook)

;; for flx-ido
(add-to-list 'load-path "~/.emacs.d/flx")
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)
;; tune garbage collection
(setq gc-cons-threshold 20000000)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("5e1d1564b6a2435a2054aa345e81c89539a72c4cad8536cfe02583e0b7d5e2fa" "9f443833deb3412a34d2d2c912247349d4bd1b09e0f5eaba11a3ea7872892000" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "21d9280256d9d3cf79cbcf62c3e7f3f243209e6251b215aede5026e0c5ad853f" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Assembler for Spim uses #, not ;
(add-hook 'asm-mode-set-comment-hook
'(lambda ()
(setq asm-comment-char ?#)))
