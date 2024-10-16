;; Note we supress bad include directories with warn_error -152 which gives a fatal
;; error from the command line but seems to work in the language server.
;;

(require 'fstar-mode)

(defun fstar-setup-local (path)
  "Set the basic arguments for fstar-mode to run an fstar, internal."
   (message "fstar-switch: setting up F* emacs mode for a local installation in %s\n"
            path)
   (setq path (file-name-as-directory path))
   (setq-default fstar-home path)
   (setq-default fstar-executable (concat path "bin/fstar.exe"))
   (setq-default fstar-subp-prover-args '(
     "--include" ".."
     "--include" "../.."
     "--include" "../../../../src/fstar/fst"
     "--include" "../../../../src/fstar/proofs"
     "--include" "../../../../src/fstar"
     "--include" "../../../../src"
     "--print_universes" "--print_implicits" "--warn_error" "-331-241-247-152"))
   (fstar-subp-kill-all)
   )

(defun fstar-setup-opam (path)
   (message "fstar-switch: setting up F* emacs mode for an opam installation in %s\n"
            path)
   (setq path (file-name-as-directory path))
   (setq-default fstar-home       (concat path ".opam/default/lib/fstar/"))
   (setq-default fstar-executable (concat home "/.opam/default/bin/fstar.exe"))
   (setq-default fstar-subp-prover-args '(
     "--include" ".."
     "--include" "../.."
     "--include" "../../../../src/fstar/fst"
     "--include" "../../../../src/fstar/proofs"
     "--include" "../../../../src/fstar"
     "--include" "../../../../src"
     "--print_full_names" "--print_universes" "--print_implicits" 
     "--warn_error" "-331-241-247-152"
     ))
   (fstar-subp-kill-all))

(defun fstar-setup-system (path)
   (message 
     "fstar-switch: setting up F* emacs mode for a system (internal) installation in %s\n"
            path)
   (setq path (file-name-as-directory path))
   (setq-default fstar-home       path)
   (setq-default fstar-executable (concat path "bin/fstar.exe"))
;; As per tracing make boot
   (setq-default fstar-subp-prover-args
    (list
;;;   "--include" (concat path "FStar/ulib")
      "--use_hints" 
      "--silent" 
      "--lax"
      "--no_location_info"
      "--warn_error" "-271-272-241-319-274-152"
      "--cache_dir" (concat path "FStar/src/.cache.boot")
      "--cache_checked_modules"
;;; This is a key difference.
      "--MLish" 
      "--include" (concat path "src/basic")
      "--include" (concat path "src/class")
      "--include" (concat path "src/data")
      "--include" (concat path "src/extraction")
      "--include" (concat path "src/fstar")
      "--include" (concat path "src/parser")
      "--include" (concat path "src/prettyprint")
      "--include" (concat path "src/reflection")
      "--include" (concat path "src/smtencoding")
      "--include" (concat path "src/syntax")
      "--include" (concat path "src/syntax/print")
      "--include" (concat path "src/tactics")
      "--include" (concat path "src/tosyntax")
      "--include" (concat path "src/typechecker")
      "--include" (concat path "src/tests")))
   (fstar-subp-kill-all))

(defun fstar-switch (installation-type installation-path)
  "fstar-switch selects the right installation for fstar-mode. The argument\
  installation is one of the strings\n\
   \"opam\",\   - sets up for use in opam.\n\
   \"local\"    - your installation on disk, often everest.\n\
   \"system\"   - sets up compilation for inside the fstar system.\n\
   The second and optional argument path is for where to find a local or system directory.\n"
 (interactive
   (list
    (read-string         "installation-type: " "opam")
    (read-directory-name "installation-path (without ~, path to FStar directory): ")))

   (message "installation-type is %s" installation-type) 
   (message "installation-path is %s" installation-path)
  (let* ((home (getenv "HOME")))
   (message "fstar-switch: Setting fstar-switch to %s using directory %s\n" 
            installation-type installation-path)
   (cond ((equal installation-type "opam")    (fstar-setup-opam   installation-path))
         ((equal installation-type "local")   (fstar-setup-local  installation-path))
         ((equal installation-type "system")  (fstar-setup-system installation-path))
         (t (message "fstar-switch: %s is not one of opam, local or system!")
                     installation-type))
   (setq fstar-switch-type installation-type)
   (setq-default fstar-smt-executable (concat home "/.opam/default/bin/z3")))
 )

;; Final: FinalTestSucceeded: test1 (Some test1 succeeded as it should SUCCESS) file: src/fstar/fst/Test.FStar.Final.TestSuite1.fst(6)
;; Final: FinalTestFailed: test2 (Some test2 FAILED as it should SUCCESS) file: src/fstar/fst/Test.FStar.Final.TestSuite1.fst(7)
;; Final: FinalTestFailedNoStatus: test3 (Some test3 FAILED with an exit as expected, SUCCESS) file: src/fstar/fst/Test.FStar.Final.TestSuite1.fst(8)


;; Debugging these:
;;(progn 
;;  (search-forward-regexp fstar-compile-error)
;;  (match-string 1))

;;; Match fstar errors and warnings.
;;; Make this match or the issue will fix it:
;;;* Warning 274:
;;;  - Implicitly opening namespace 'test.fstar.final.' shadows module 'testmain'
;;;    in file "/home/milnes/Tuff/FinalFlog/test/src/fstar/fst/TestMain.fst".
;;;  - Rename
;;;    "/home/milnes/Tuff/FinalFlog/test/src/fstar/fst/TestMain.fst"
;;;    to avoid conflicts.

(require 'compile)
(defun setup-fstar-compile ()
;; Koljecki problem.

;; Does not work multi-line match no ^ and $, so waite or the issue on Warning 274.
;;(setq fstar-compile-regexp-shadow-warning
;;"\* Warning \\([0-9]+\\):\
;;.* in file \"\\([A-Za-z0-9_\/\.]+\\)\"")
;;
;;(add-to-list 'compilation-error-regexp-alist-alist
;;`(fstar-shadow-warning
;;  ,fstar-compile-regexp-warning
;;  2 ;; file
;;  () ;; line
;;  () ;; column
;;  1 ;; warning
;;))
;;
;; (add-to-list 'compilation-error-regexp-alist 'fstar-shadow-warning)

(setq fstar-compile-regexp-warning
"\* Warning \\([0-9]+\\)\
 at \\([A-Za-z0-9_\/\.]+\\)\
(\\([0-9]+\\),\
\\([0-9]+\\)-\
\\([0-9]+\\),\
\\([0-9]+\\)):")

(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-warning
  ,fstar-compile-regexp-warning
  2 ;; file
  3 ;; line
  4 ;; column
  1 ;; warning
))

(setq fstar-compile-regexp-error
"\* Error \\([0-9]+\\)\
 at \\([A-Za-z0-9_\/\.]+\\)\
(\\([0-9]+\\),\
\\([0-9]+\\)-\
\\([0-9]+\\),\
\\([0-9]+\\)):"
)
(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-error
  ,fstar-compile-regexp-error
  2 ;; file
  3 ;; line
  4 ;; column
  2 ;; error 
))

;;; Final: FinalTestSucceeded: test1 (Some test1 succeeded as it should SUCCESS) file: src/fstar/fst/Test.FStar.Final.TestSuite1.fst(6)
(setq fstar-final-success-regexp-info 
"Final: FinalTestSucceeded:.* file: \\([A-Za-z0-9_\/\.]+\\)\(\\([0-9\/]+\\\)")

(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-final-success
  ,fstar-final-success-regexp-info
  1  ;; file
  2  ;; line
  () ;; column
  0  ;; info
  ))

;;; Final: FinalTestFailed: test2 (Some test2 FAILED as it should SUCCESS) file: src/fstar/fst/Test.FStar.Final.TestSuite1.fst(7)

(setq fstar-final-failure-regexp-info 
 "Final: FinalTestFailed:.* file: \\([A-Za-z0-9_\/\.]+\\)\(\\([0-9\/]+\\)\)")

(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-final-failure
  ,fstar-final-failure-regexp-info
  1  ;; file
  2  ;; line
  () ;; column
  2  ;; error
  ))

;;; Final: FinalTestFailed: test_file_test_matches expected input file: ./inputfiles/test_file_test.txt

(setq fstar-final-file-failure-regexp-error-no-line
 "Final: FinalTestFailed:.* \\(input\\|output\\) file: \\([A-Za-z0-9_\/\.]+\\)")

(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-final-file-failure
  ,fstar-final-file-failure-regexp-error-no-line
  2  ;; file
  () ;; line
  () ;; column
  2  ;; error
  ))

;;; Final: FinalTestFailedNoStatus: test3 (Some test3 FAILED with an exit as expected, SUCCESS) file: src/fstar/fst/Test.FStar.Final.TestSuite1.fst(8)

(setq fstar-final-nostatus-regexp-error 
 "Final: FinalTestFailedNoStatus:.* file: \\([A-Za-z0-9_\/\.]+\\)\(\\([0-9\/]+\\)\)")

(add-to-list 'compilation-error-regexp-alist-alist
 `(fstar-final-nostatus 
   ,fstar-final-nostatus-regexp-error
   1  ;; file
   2  ;; line
   () ;; column
   2  ;; error
  ))

;;; Final: starting test suite

(setq fstar-final-starting-test-suite-regex-info 
 "Final: starting test suite.* file: \\([A-Za-z0-9_\/\.]+\\)\(\\([0-9\/]+\\)\)")

(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-final-starting-test-suite
  ,fstar-final-starting-test-suite-regex-info
  1  ;; file
  2  ;; line
  () ;; column
  0  ;; info
  ))

;; Final: FinalTestFailedUnknownException: test_fstar_clean

(setq fstar-final-unknown-exception-error-regex
 "Final: \((FinalTestFailedUnknownException:.*\))")

(add-to-list 'compilation-error-regexp-alist-alist
`(fstar-final-unknown-exception-error
  ,fstar-final-unknown-exception-error-regex
  () ;; file
  () ;; line
  () ;; column
  2  ;; error
  ))

(add-to-list 'compilation-error-regexp-alist 'fstar-error)
(add-to-list 'compilation-error-regexp-alist 'fstar-warning)
(add-to-list 'compilation-error-regexp-alist 'fstar-final-success)
(add-to-list 'compilation-error-regexp-alist 'fstar-final-failure)
(add-to-list 'compilation-error-regexp-alist 'fstar-final-nostatus)
(add-to-list 'compilation-error-regexp-alist 'fstar-final-starting-test-suite)
(add-to-list 'compilation-error-regexp-alist 'fstar-final-file-failure)
(add-to-list 'compilation-error-regexp-alist 'fstar-final-unknown-exception-error)
)

(add-hook 'compilation-mode-hook 'setup-fstar-compile)


;;;  Colorize the compile buffer.

(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))
