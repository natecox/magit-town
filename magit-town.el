;;; magit-town.el --- Add Git Town commands to Magit  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Nathan Cox

;; Author: Nathan Cox <tsuujin@icloud.com>
;; URL: http://github.com/natecox/magit-town
;; Version: 19.4.1
;; Package-Requires: ((emacs "24"))
;; Keywords: vc, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; magit-town.el provides an interface to the Git Town plugin

;;; Code:

(require 'magit)
(require 'transient)

(defgroup magit-town nil
  "Bindings to Git Town."
  :group 'magit)

;;;###autoload (autoload 'magit-town-dispatch "magit-town" nil t)
(define-transient-command magit-town-dispatch ()
  "Dispatch a git town command."
  [["Development Workflow"
    ("d h" "hack" magit-town-hack)
    ("d s" "sync" magit-town-sync)
    ("d p" "new-pull-request" magit-town-new-pull-request)
    ("d S" "ship" magit-town-ship)]
   ["Repository Maintenance"
    ("m k" "kill" magit-town-kill)
    ("m P" "prune-branches" magit-town-prune-branches)
    ("m r" "rename-branch" magit-town-rename-branch)
    ("m a" "append" magit-town-append)
    ("m p" "prepend" magit-town-prepend)
    ("m r" "repo" magit-town-repo)]
   ["Actions"
    ("w !" "Run Command" magit-town-run-topdir)]])

(defun magit-town-run (&rest args)
  "Run town commands ARGS."
  (magit-run-git-async "town" args))

;;;###autoload
(defun magit-town-sync ()
  "Updates the current branch with all ongoing changes."
  (interactive)
  (magit-town-run "sync"))

;;;###autoload
(defun magit-town-hack ()
  "Cuts a new up-to-date feature branch off the main branch."
  (interactive "sFeature Name")
  (magit-town-run "hack" feature-name))

;;;###autoload
(defun magit-town-new-pull-request ()
  "Create a new pull request."
  (interactive)
  (magit-town-run "new-pull-request"))

;;;###autoload
(defun magit-town-ship ()
  "Delivers a completed feature branch and removes it."
  (interactive)
  (magit-town-run "ship"))

;;;###autoload
(defun magit-town-kill ()
  "Removes a feature branch."
  (interactive)
  (magit-town-run "kill"))

;;;###autoload
(defun magit-town-prune-branches ()
  "delete all merged branches."
  (interactive)
  (magit-town-run "prune-branches"))

;;;###autoload
(defun magit-town-rename-branch (new-branch-name)
  "rename a branch."
  (interactive "sBranch Name: ")
  (magit-town-run "rename-branch" new-branch-name))

;;;###autoload
(defun magit-town-append (feature-name)
  "insert a new branch as a child of the current branch."
  (interactive "sFeature Name: ")
  (magit-town-run "append" feature-name))

;;;###autoload
(defun magit-town-prepend (feature-name)
  "insert a new branch between the current branch and its parent."
  (interactive "sFeature Name: ")
  (magit-town-run "prepend" feature-name))

;;;###autoload
(defun magit-town-repo ()
  "view the repository homepage."
  (interactive)
  (magit-town-run "repo"))

;;;###autoload
(defun magit-town-run-topdir (command)
  "Execute COMMAND async from top directory."
  (interactive (list (magit-read-shell-command t "git town ")))
  (magit-git-command-topdir command))

;;;###autoload
(eval-after-load 'magit
  '(progn
     (define-key magit-mode-map "," 'magit-town-dispatch)
     (transient-append-suffix 'magit-dispatch "%"
       '("," "Town" magit-town-dispatch))))

(provide 'magit-town)
;;; magit-town.el ends here
