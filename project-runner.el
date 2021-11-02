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
    (if (f-file? config-file)
        (json-parse-string (f-read-text config-file)))))

(defun project-runner--is-project-config-valid (project-config)
  "Return `t' if PROJECT_CONFIG is a valid `prunner' configuration, `nil' otherwise."
  (equal (hash-table-p (gethash "commands" project-config nil)) t))

(provide 'project-runner)

;;; project-runner.el ends here
