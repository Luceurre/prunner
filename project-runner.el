;;; project-runner.el --- summary -*- lexical-binding: t -*-

;; Author: DesktopPierre
;; Maintainer: pglandon78@gmail.com<Pierre Glandon>
;; Version: 0.0.1
;; Keywords: projectile 


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
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

;; Commentary

;;; Code:

(require 'projectile)
(require 'f)
(require 'json)

(defvar project-runner-config-filename "prunner.json")

(defun project-runner--find-project-root (&optional dir)
  "Retrieves the root directory via `projectile' of the project if available.
if DIR is not supplied its set to the current directory by default."
  (projectile-project-root dir))

(defun project-runner--find-project-configuration (&optional dir)
  "Retrieves the configuration file path of the project if it exists.
if DIR is not supplied its set to the current directory by default."
  (f-expand project-runner-config-filename (project-runner--find-project-root dir)))

(defun project-runner--load-project-configuration (&optional dir)
  "Retrieves the configuration file of project if it exists.
if DIR is not supplied its set to the current directory by default."
  (let ((config-file (project-runner--find-project-configuration dir)))
    (when (f-file? config-file)
        (json-parse-string (f-read-text config-file)))))

(defun project-runner--is-project-config-valid (project-config)
  "Return `t' if PROJECT_CONFIG is a valid `prunner' configuration, `nil' otherwise."
  (equal (hash-table-p (gethash "commands" project-config nil)) t))

(defun project-runner--get-command (project-config command-name)
  "Return command associated to COMMAND_NAME in PROJECT_CONFIG.
if there is no command with this name, return nil."
  (gethash command-name (gethash "commands" project-config)))

(defun project-runner--run-command (project-config command-name)
  "Run command associated to PROJECT_CONFIG and COMMAND_NAME in project root directory."
  (let ((command (project-runner--get-command project-config command-name)))
    (projectile-run-shell-command-in-root command)))

(defun project-runner--get-default-config ()
  "Return a valid default prunner.json hastable."
  #s(hash-table data ("commands" #s(hash-table))))

(defun project-runner--init (&optional force)
  "Create a default prunner.json in project root.
If FORCE is t, override existing prunner.json."
  (interactive)
  (f-write-text (json-encode (project-runner--get-default-config)) 'utf-8 (project-runner--find-project-configuration)))

(provide 'project-runner)

;;; project-runner.el ends here
