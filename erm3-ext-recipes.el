;;; erm3-ext-recipes.el --- Personal package for my recipes repo  -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Edward Minnix III
;;
;; Author: Edward Minnix III <egregius313@gmail.com>
;; Maintainer: Edward Minnix III <egregius313@gmail.com>
;; Created: November 08, 2025
;; Modified: November 08, 2025
;; Version: 0.0.1
;; Keywords: convenience
;; Homepage: https://github.com/egregius313/erm3-ext-recipes
;; Package-Requires: ((emacs "24.3") (yasnippet "0.8.0") (magit "3.0.0"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Additional functionality and snippets for the `egregius313/recipes' repo.
;;
;;; Code:
(eval-when-compile
  (require 'cl-lib))
(require 'magit)
(require 'yasnippet)

(defmacro erm3-ext-recipes-github-repo (org repo)
  "Generate regexp matching urls for the GitHub repo associated with `ORG' and
`REPO'."
  `(rx bos
       (? (or "https://" "git@"))
       "github.com"
       (or ?: ?/)
       ,org
       "/"
       ,repo
       (? ".git")
       eos))

;;;###autoload
(defun erm3-ext-recipes-in-recipes-file-p ()
  "Determine if the file for the current buffer is the recipes.org file."
  (let* ((repo-rx (erm3-ext-recipes-github-repo "egregius313" "recipes"))
         (is-recipes (cl-loop for remote in (magit-list-remotes)
                              for remote-url = (magit-get (format "remote.%s.url" remote))
                              when (string-match-p repo-rx remote-url)
                              return t)))
    (and
     is-recipes
     (string= (magit-file-relative-name) "recipes.org"))))

(defconst erm3-ext-recipes-snippets-dir
  (expand-file-name
   "snippets"
   (file-name-directory
    ;; Copied from ‘f-this-file’ from f.el.
    (cond
     (load-in-progress load-file-name)
     ((and (boundp 'byte-compile-current-file) byte-compile-current-file)
      byte-compile-current-file)
     (:else (buffer-file-name))))))

;;;###autoload
(defun erm3-ext-recipes-snippets-initialize ()
  "Load the `erm3-ext-recipes' snippets directory."
  ;; NOTE: we add the symbol `erm3-ext-recipes-snippets-dir' rather than its
  ;; value, so that yasnippet will automatically find the directory
  ;; after this package is updated (i.e., moves directory).
  (unless (member 'erm3-ext-recipes-snippets-dir yas-snippet-dirs)
    (add-to-list 'yas-snippet-dirs 'erm3-ext-recipes-snippets-dir t)
    (yas--load-snippet-dirs)))

;;;###autoload
(eval-after-load 'yasnippet
  '(erm3-ext-recipes-snippets-initialize))

(provide 'erm3-ext-recipes)
;;; erm3-ext-recipes.el ends here
