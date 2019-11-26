
(defun fpd (directory maxdepth)
  "Discover any projects in DIRECTORY and add them to the projectile cache.
This function is not recursive and only adds projects with roots
at the top level of DIRECTORY."
  (interactive
   (list (read-directory-name "Starting directory: ")))
  (let ((subdirs (directory-files directory t)))
    (mapcar
     (lambda (dir)
       (when (and (file-directory-p dir)
                  (not (member (file-name-nondirectory dir) '(".." "."))))
         (if (projectile-project-p dir)
             (projectile-add-known-project dir)
           (when (> maxdepth 0) (fpd dir (- maxdepth 1))))))
     subdirs)))


(fpd "/Users/burke/src" 3)
