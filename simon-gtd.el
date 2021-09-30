
(setq-default org-pomodoro-time-format "%.2m:%.2s")
(defun ykn/produce-pomodoro-string-for-menu-bar ()
  "Produce the string for the current pomodoro counter to display on the menu bar"
  (let ((prefix (cl-case org-pomodoro-state
            (:pomodoro "P")
            (:overtime "O")
            (:short-break "B")
            (:long-break "LB"))))
          (if (and (org-pomodoro-active-p) (> (length prefix) 0))
            (list prefix (org-pomodoro-format-seconds)) "N/A")))

(defun ykn/gtd-test ()
  "yekeno"
  (interactive)
  (list 1 2 3 4))
(defun sacha/org-count-tasks-by-status ()
  (interactive)
  (let ((counts (make-hash-table :test 'equal))
        (today (format-time-string "%Y-%m-%d" (current-time)))
        values output)
    (org-map-entries
     (lambda ()
       (let* ((status (elt (org-heading-components) 2)))
         (when status
           (puthash status (1+ (or (gethash status counts) 0)) counts))))
     nil
     'agenda)
    (setq values (mapcar (lambda (x)
                           (or (gethash x counts) 0))
                         '("DONE" "STARTED" "TODO" "WAITING" "DELEGATED" "CANCELLED" "SOMEDAY")))
    (setq output
          (concat "| " today " | "
                  (mapconcat 'number-to-string values " | ")
                  " | "
                  (number-to-string (apply '+ values))
                  " | "
                  (number-to-string
                   (round (/ (* 100.0 (car values)) (apply '+ values))))
                  "% |"))
    (if (called-interactively-p 'any)
        (insert output)
      output)))
(sacha/org-count-tasks-by-status)

(provide 'simon-gtd)

;;; simon-gtd.el ends here
