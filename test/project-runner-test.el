;;; project-runner-test.el --- Tests for project-runner

(ert-deftest find-project-root/no-argument ()
  "Should use `default-directory' when no argument."
  (with-sandbox
   (f-mkdir ".git")
   (should (equal (project-runner--find-project-root) root-sandbox-path))))

(ert-deftest find-project-configuration/no-argument ()
  "Should use `default-directory' when no argument."
  (with-sandbox
   (f-mkdir ".git")
   (should (equal (project-runner--find-project-configuration) (f-expand "prunner.json" root-sandbox-path)))))

(ert-deftest load-project-configuration/no-config ()
  "Should return `nil' if file doesn't exist."
  (with-sandbox
   (f-mkdir ".git")
   (should (equal (project-runner--load-project-configuration) nil))))

(ert-deftest load-project-configuration/no-argument ()
  "Should return the LISP JSON representation if file exists and JSON is valid."
  (with-sandbox
   (f-mkdir ".git")
   (f-copy (f-expand "prunner.json" fixtures-path) root-sandbox-path)
   (should (equal-json (project-runner--load-project-configuration) "prunner.json"))))

(ert-deftest load-project-configuration/invalid-json ()
  "Should throw an error if file exists and JSON is invalid."
  (with-sandbox
   (f-mkdir ".git")
   (f-copy (f-expand "invalid_prunner.json" fixtures-path) (f-expand "prunner.json" root-sandbox-path))
   (should-error (project-runner--load-project-configuration))))

(ert-deftest is-project-config-valid/invalid-config ()
  "Should return `nil' if given project configuration is invalid."
  (with-sandbox
   (f-mkdir ".git")
   (f-copy (f-expand "prunner.json" fixtures-path) (f-expand "prunner.json" root-sandbox-path))
   (should (equal (project-runner--is-project-config-valid (project-runner--load-project-configuration)) nil))
   )
  )
;;; project-runner-test.el ends here
