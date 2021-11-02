;;; project-runner-test.el --- Tests for project-runner

(ert-deftest find-project-root/no-argument
    ()
  "Should use `default-directory' when no argument."
  (with-sandbox (f-mkdir ".git")
                (should (equal (project-runner--find-project-root) root-sandbox-path))))

(ert-deftest find-project-configuration/no-argument
    ()
  "Should use `default-directory' when no argument."
  (with-sandbox (f-mkdir ".git")
                (should (equal (project-runner--find-project-configuration) (f-expand "prunner.json" root-sandbox-path)))))

(ert-deftest load-project-configuration/no-config
    ()
  "Should return nil if file doesn't exist."
  (with-sandbox (f-mkdir ".git")
                (should (equal (project-runner--load-project-configuration) nil))))

(ert-deftest load-project-configuration/no-argument
    ()
  "Should return the LISP JSON representation if file exists and JSON is valid."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "valid_prunner.json")
                (should (equal-json (project-runner--load-project-configuration)
                                    "valid_prunner.json"))))

(ert-deftest load-project-configuration/invalid-json
    ()
  "Should throw an error if file exists and JSON is invalid."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "invalid_prunner.json")
                (should-error (project-runner--load-project-configuration))))

(ert-deftest is-project-config-valid/invalid-config-commands-key-not-defined
    ()
  "Should return nil if given project configuration is invalid (no `commands' key)."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "prunner_invalid_no_commands_key.json")
                (should (equal (project-runner--is-project-config-valid (project-runner--load-project-configuration)) nil))))

(ert-deftest is-project-config-valid/invalid-config-commands-key-not-a-json-object
    ()
  "Should return nil if given project configuration is invalid (`commands' is a string)."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "prunner_invalid_commands_not_an_object.json")
                (should (equal (project-runner--is-project-config-valid (project-runner--load-project-configuration)) nil))))

(ert-deftest is-project-config-valid/valid-config
    ()
  "Should return t if given project configuration is valid."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "valid_prunner.json")
                (should (equal (project-runner--is-project-config-valid (project-runner--load-project-configuration)) t))))

(ert-deftest get-command/command-not-found
    ()
  "Should return nil if given command is not found in project configuration."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "valid_prunner.json")
                (let ((project-config (project-runner--load-project-configuration)))
                  (should (equal (project-runner--get-command project-config
                                                              "unknownCommand") nil)))))

(ert-deftest get-command/known-command
    ()
  "Should return command if given command-name is found in project configuration."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "valid_prunner.json")
                (let ((project-config (project-runner--load-project-configuration)))
                  (should (equal (project-runner--get-command project-config
                                                              "run") "echo Hello, World!")))))

(ert-deftest run-command/unknown-command
    ()
  "Should throw when command is unknown."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "valid_prunner.json")
                (let ((project-config (project-runner--load-project-configuration)))
                  (should-error (project-runner--run-command project-config
                                                              "unknownCommand")))))

(ert-deftest run-command/known-command
    ()
  "Should run given command when command-name is known."
  (with-sandbox (f-mkdir ".git")
                (given-fixture "valid_prunner.json")
                (let ((project-config (project-runner--load-project-configuration)))
                  (project-runner--run-command project-config
                                                             "touch")
                  (should (equal (f-file? "touchedFile") t)))))
;;; project-runner-test.el ends here
