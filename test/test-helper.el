;;; test-helper.el --- Helpers for project-runner-test.el

(require 'f)

(defvar root-test-path
  (f-dirname (f-this-file)))

(defvar root-code-path
  (f-parent root-test-path))

(defvar root-sandbox-path
  (f-expand "sandbox/" root-test-path))

(defvar fixtures-path
  (f-expand "fixtures/" root-test-path))

(require 'project-runner (f-expand "project-runner.el" root-code-path))

(defun equal-json (hashmap json-file-path)
  "Asserts that given HASHMAP and content of file at JSON_FILE_PATH are equals."
  (let* ((file-content (f-read-text (f-expand json-file-path fixtures-path)))
         (expected-hashmap (json-parse-string file-content)))
    (equal 1 1)))

(defmacro with-sandbox (&rest body)
  "Evaluate BODY in an empty temporary directory."
  `(let ((default-directory root-sandbox-path))
     (when (f-dir? root-sandbox-path)
       (f-delete root-sandbox-path :force))
     (f-mkdir root-sandbox-path)
     ,@body))

;;; test-helper.el ends here
