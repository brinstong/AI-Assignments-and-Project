;;;; Decision Trees

;;for the compiler to not skip printing.
(setf *print-level* nil)
(setf *print-length* nil)
(setf *print-lines* nil)


;;;; This example is taken from Assignment 3 for the C section of the questions.
;;The congressman problem
(defparameter *example-labels*
  '(democrat republican)
)

(defparameter *example-feature-defs*
  '(
    (bill1 0.1 0.5 0.9)
    (bill2 0.1 0.5 0.9)
    (bill3 0.1 0.5 0.9)
    (bill4 0.1 0.5 0.9)
    (bill5 0.1 0.5 0.9)
    (bill6 0.1 0.5 0.9)
    (bill7 0.1 0.5 0.9)
    (bill8 0.1 0.5 0.9)
    (bill9 0.1 0.5 0.9)
    (bill10 0.1 0.5 0.9)
    (bill11 0.1 0.5 0.9)
    (bill12 0.1 0.5 0.9)
    (bill13 0.1 0.5 0.9)
    (bill14 0.1 0.5 0.9)
    (bill15 0.1 0.5 0.9)
    (bill16 0.1 0.5 0.9)
  )
)


(defparameter *example-dataset*
'(((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.5 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.9 0.5) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.5) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.5 0.1 0.9 0.9 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.9 0.5 0.9 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.9 0.5) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.9 0.9 0.9) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.5 0.1 0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5 0.9 0.9 0.5 0.5) (0.1))
((0.9 0.9 0.9 0.5 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.5 0.9) (0.9))
((0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1) (0.9))
((0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9) (0.1))
((0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.1 0.9 0.9 0.9) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.5 0.5 0.5 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.5 0.9 0.9 0.5 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.5 0.9 0.9 0.9 0.1 0.9 0.5 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.5 0.9) (0.9))
((0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.5 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.5) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.5 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.5 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.5 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.9 0.1 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.5 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.5 0.9 0.1 0.1) (0.9))
((0.1 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.5 0.1) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.5 0.5 0.5 0.9 0.1 0.5) (0.1))
((0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.9 0.5 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.5 0.9 0.5 0.5) (0.1))
((0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.5 0.1 0.5) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.5 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5 0.9 0.9 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.5 0.5 0.1 0.9 0.5 0.5 0.5 0.9 0.9) (0.9))
((0.5 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.5 0.5 0.5 0.5 0.5 0.5) (0.9))
((0.5 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.9 0.5 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.9 0.5 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.5 0.9 0.9 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.5 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.5 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.5 0.9 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.5 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.9 0.1 0.9 0.9 0.9 0.5) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.5 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.5 0.9 0.9 0.1 0.1) (0.9))
((0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.5 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.5 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.5 0.9 0.5 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.5 0.1 0.9 0.5) (0.9))
((0.1 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.9 0.1) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.9 0.1) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.5 0.9 0.1 0.1 0.9 0.9 0.1 0.5) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.5 0.5 0.5 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.5 0.5) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.5 0.5 0.1 0.5) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.5 0.5 0.9 0.9) (0.9))
((0.9 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.5 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.5) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.5 0.9 0.9 0.1 0.5) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.5 0.9 0.9) (0.9))
((0.1 0.1 0.5 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.5 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.5 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.5 0.9 0.1 0.1 0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.1 0.5 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.5) (0.9))
((0.5 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.5 0.5 0.1 0.1 0.1 0.5 0.5) (0.9))
((0.1 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.1 0.5 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.5) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.5 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.5 0.1 0.1 0.1 0.1 0.5 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.5 0.9 0.9 0.9 0.1 0.5 0.5 0.1 0.5 0.5 0.5) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.1 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.5 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.9 0.5 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.5 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.5 0.5 0.5 0.5 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.5) (0.1))
((0.9 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.5 0.9 0.1 0.1) (0.1))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.5 0.9 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.9) (0.9))
((0.5 0.9 0.9 0.5 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.1) (0.9))
((0.1 0.9 0.9 0.1 0.5 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.1 0.1 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.5 0.5 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.9 0.1 0.9 0.5 0.9 0.9 0.9 0.5 0.1 0.1 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.5 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.5 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.5 0.9 0.1 0.9) (0.1))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.1 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.1 0.1 0.1 0.1 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.5 0.5) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.9 0.5 0.9 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.5 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.9 0.9 0.9 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.5 0.1 0.1 0.1 0.1 0.9 0.5 0.1) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.5 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.5 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.5 0.9 0.1 0.5 0.5 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.9 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.5 0.9 0.9 0.5 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.5) (0.1))
((0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.5 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.5 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.9 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.5 0.1 0.9 0.9 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.5 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.1 0.1) (0.1))
((0.1 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.5 0.9) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.5 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.1 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9) (0.1))
((0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.5 0.1 0.9 0.9 0.1 0.1) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1) (0.1))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.1 0.5) (0.1))
((0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.5 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.5 0.1 0.9 0.1 0.9) (0.9))
((0.1 0.1 0.5 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.5) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.5 0.9 0.1 0.5 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9) (0.9))
((0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.5) (0.9))
((0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.9 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.1) (0.1))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.5) (0.9))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.1 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1) (0.9))
((0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.1) (0.9))
((0.1 0.5 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.9 0.1 0.1 0.1 0.1 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.5 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.5 0.5 0.1 0.1 0.5 0.9 0.5 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.5) (0.9))
((0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.1) (0.9))
((0.9 0.9 0.5 0.5 0.5 0.9 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.5 0.1 0.1 0.1 0.9 0.1 0.1 0.9 0.5 0.1 0.1 0.9 0.9) (0.9))
((0.9 0.9 0.1 0.1 0.9 0.5 0.1 0.1 0.1 0.1 0.9 0.1 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.1 0.9 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1) (0.9))
((0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1) (0.1))
((0.9 0.1 0.9 0.1 0.1 0.9 0.9 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.1 0.1 0.9 0.9 0.1 0.9) (0.1))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.9 0.9 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.1 0.9 0.9 0.1 0.1 0.1 0.9 0.5) (0.9))
((0.9 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.9 0.9) (0.9))
((0.1 0.1 0.9 0.1 0.1 0.1 0.9 0.9 0.9 0.9 0.1 0.1 0.1 0.1 0.1 0.9) (0.9))))



;;; The Department Problem

(defparameter *department-labels* 
  '(t nil)
  "Label Values for the Departmental Reycling Bin Problem")

(defparameter *department-feature-defs* 
  '((status faculty staff student)
                      (department ee cs)
                      (floor 3 4 5)
                      (size small medium large))
  "A list of feature-defs for the Departmental Recycling Bin Problem.
    Feature defs take the form (feature val1 val2 val3 ...)" )


(defparameter *department-examples* 
'(((status faculty) (floor 3) (department ee) (size large) (:label nil))
                      ((status staff) (floor 3) (department ee) (size small) (:label nil))
                      ((status faculty) (floor 4) (department cs) (size medium) (:label t))
                      ((status student) (floor 4) (department ee) (size large) (:label t))
                      ((status staff) (floor 5) (department cs) (size medium) (:label nil))
                      ((status faculty) (floor 5) (department cs) (size large) (:label t))
                      ((status student) (floor 3) (department ee) (size small) (:label t))
                      ((status staff) (floor 4) (department cs) (size medium) (:label nil)))
  "A list of feature-defs for the Departmental Recycling Bin Problem.
    Examples take the form of ((attr1 val) (attr2 val) ... (:label label))")


;;; The Restaurant Problem

(defparameter *restaurant-labels*
  '(t nil)
  "label Values for the Restaurant problem")

(defparameter *restaurant-feature-defs*
  '((alternative t nil)
    (has-bar t nil)
    (open-friday t nil)
    (hungry t nil)
    (patrons none some full)
    (price cheap medium expensive)
    (raining t nil)
    (reservation t nil)
    (type french thai burger italian)
    (estimated-wait-time 0-10 10-30 30-60 >60))    
  "A list of feature-defs for the Restaurant problem.
    feature defs take the form (feature val1 val2 val3 ...)")


(defparameter *restaurant-examples*
  '(((alternative t) (has-bar nil) (open-friday nil) (hungry t) (patrons some) (price expensive) (raining nil) (reservation t) (type french) (estimated-wait-time 0-10) (:label t))
    ((alternative t) (has-bar nil) (open-friday nil) (hungry t) (patrons full) (price cheap) (raining nil) (reservation nil) (type thai) (estimated-wait-time 30-60) (:label nil))
    ((alternative nil) (has-bar t) (open-friday nil) (hungry nil) (patrons some) (price cheap) (raining nil) (reservation nil) (type burger) (estimated-wait-time 0-10) (:label t))
    ((alternative t) (has-bar nil) (open-friday t) (hungry t) (patrons full) (price cheap) (raining nil) (reservation nil) (type thai) (estimated-wait-time 10-30) (:label t))
    ((alternative t) (has-bar nil) (open-friday t) (hungry nil) (patrons full) (price expensive) (raining nil) (reservation t) (type french) (estimated-wait-time >60) (:label nil))
    ((alternative nil) (has-bar t) (open-friday nil) (hungry t) (patrons some) (price medium) (raining t) (reservation t) (type italian) (estimated-wait-time 0-10) (:label t))
    ((alternative nil) (has-bar t) (open-friday nil) (hungry nil) (patrons none) (price cheap) (raining t) (reservation nil) (type burger) (estimated-wait-time 0-10) (:label nil))
    ((alternative nil) (has-bar nil) (open-friday nil) (hungry t) (patrons some) (price medium) (raining t) (reservation t) (type thai) (estimated-wait-time 0-10) (:label t))
    ((alternative nil) (has-bar t) (open-friday t) (hungry nil) (patrons full) (price cheap) (raining t) (reservation nil) (type burger) (estimated-wait-time >60) (:label nil))
    ((alternative t) (has-bar t) (open-friday t) (hungry t) (patrons full) (price expensive) (raining nil) (reservation t) (type italian) (estimated-wait-time 10-30) (:label nil))
    ((alternative nil) (has-bar nil) (open-friday nil) (hungry nil) (patrons none) (price cheap) (raining nil) (reservation nil) (type thai) (estimated-wait-time 0-10) (:label nil))
    ((alternative t) (has-bar t) (open-friday t) (hungry t) (patrons full) (price cheap) (raining nil) (reservation nil) (type burger) (estimated-wait-time 30-60) (:label t)))
  "A list of examples for the Restaurant problem.
    Examples take the form of ((attr1 val) (attr2 val) ... (:label label))")


(defparameter *restaurant-trial-examples*
  '(((alternative t) (has-bar nil) (open-friday nil) (hungry t) (patrons full) (price cheap) (raining nil) (reservation nil) (type thai) (estimated-wait-time 30-60) (:label nil))
    ((alternative nil) (has-bar t) (open-friday nil) (hungry nil) (patrons some) (price cheap) (raining nil) (reservation nil) (type burger) (estimated-wait-time 0-10) (:label t))
    ((alternative t) (has-bar nil) (open-friday t) (hungry nil) (patrons full) (price expensive) (raining nil) (reservation t) (type french) (estimated-wait-time >60) (:label nil))
    ((alternative nil) (has-bar nil) (open-friday nil) (hungry t) (patrons some) (price medium) (raining t) (reservation t) (type thai) (estimated-wait-time 0-10) (:label t))
    ((alternative nil) (has-bar nil) (open-friday nil) (hungry nil) (patrons none) (price cheap) (raining nil) (reservation nil) (type thai) (estimated-wait-time 0-10) (:label nil))
    ((alternative t) (has-bar t) (open-friday t) (hungry t) (patrons full) (price cheap) (raining nil) (reservation nil) (type burger) (estimated-wait-time 30-60) (:label t)))
  "Some training-case examples for the Restaurant problem, selected from
    the full set of examples above. 
    Examples take the form of ((attr1 val) (attr2 val) ... (:label label))")    


;; This function returns the element that occurs most often in the list.
(defun most-common (elts &key (test #'equalp))
  	(let* ((unique-elts (remove-duplicates elts :test test))
    	(unique-nums (mapcar #'(lambda (x) (count x elts :test test)) unique-elts))
    	(best-elt (first unique-elts))
    	(best-num (first unique-nums)))
  		(mapc #'(lambda (elt num) (when (> num best-num) 
    	(setf best-elt elt) (setf best-num num)))
  		(rest unique-elts) (rest unique-nums))
  	best-elt
	)
)

;;Normalizes a list of numbers by dividing them by their sum.  
(defun normalize (numbers)
	(let ((sum (apply #'+ numbers)))
    	(if (= sum 0.0) numbers 
      		(mapcar #'(lambda (num) (/ num sum)) numbers)
    	)
    )
)

;;Returns the value of given feature as stored in the example
(defun feature-val-for-example (example feature)
  (second (assoc feature example))
)

;;Returns the label of given example
(defun label-of-example (example)
  (second (assoc :label example))
)

;;find the label of a example by iterating through the decision tree.
(defun find-label-for-example (example decision-tree)
  	(if (equalp (first decision-tree) :label)
    	(second decision-tree) 
    	(find-label-for-example example
      	(second (assoc
        (feature-val-for-example example (first decision-tree))
        (rest decision-tree))))
    )
)

;;returns true if all examples have the same label, nil otherwise.
(defun examples-have-same-label-p (examples)
  	(let ((label (label-of-example (first examples))))
    	(dolist (example examples t)
      		(when (not (equalp label (label-of-example example)))
        		(return nil)
        	)
        )
    )
)

;;returns the count of examples with the specified label.
(defun num-examples-with-label (examples label)
  (count-if #'(lambda (example) (equalp 
    (label-of-example example) label)) examples)
)

;;returns the count of examples that have a specified feature value pair
(defun num-examples-with-feature-val (examples feature value)
  (count-if #'(lambda (example) (equalp
    (feature-val-for-example example feature) value)) examples)
)

;;returns the most common label in the examples
(defun most-common-label (examples)
  (most-common (mapcar #'label-of-example examples))
)

;;returns the examples that have the specified feature value pair
(defun examples-with-feature-val (examples feature val)
  (remove-if-not #'(lambda (x) (equalp (feature-val-for-example x feature) val)) examples)
)

;;Returns a list, one item per label, of the percentage of examples with a given value for a given feature, which belong to that label.
(defun label-probabilities-for-feature-val (examples feature value labels)
  	(let ((examples-with-feature-val
    	(if (null feature) examples 
      		(remove-if-not #'(lambda (x) (equalp 
        	(feature-val-for-example x feature) value)) examples)
        )))
  		(normalize
    		(mapcar #'(lambda (label) (/ 
      			                           (num-examples-with-label examples-with-feature-val label)
                                            (length labels)
                                        ))
    			labels
    		)
    	)
  	)
)

;;Returns the information theoretically stored in the list
(defun information (probabilities &optional (gini-coeff nil))
  (if (not gini-coeff)
    (progn ;execute block if gini-coefficient is not requested
        (if (not (null probabilities)) ;if list of probabilities is not null
      		(if (= 0.0 (first probabilities)) ;check if first value is 0
      			(+ 0.0 (information (rest probabilities))) ; if so, return 0 and recursively run the function on rest of the list
      			(+ (* (first probabilities) (- 0.0 (log (first probabilities) 2.0))) (information (rest probabilities))) ;calculate the value of information 
      		)
      		0.0
      	)
    )
    ;else execute following block to calculate gini-coefficient
    (let
      ((sum 0))
      (dolist (p probabilities) ;iterate through all probilities provided in the list
        (setf sum (+ sum (* p p))) ;calculate summation of probability to the power 2 for all probabilities
      )
      (- 1.0 sum) ;subtract sum from 1
    )	
  )
)

;;example without gini-coeff
;(print (information '(1/2 1/3 1/6)))

;;example for gini-coeff
;(print (information '(1/2 1/3 1/6) t))


;;    Returns the sum, over each value that the feature can take on,
;;    of the probability of an example having that value, times the
;;    information content of the probabilities of various labels
;;    for all examples with that value.
(defun remainder (feature-def examples labels)

	(let ((sum 0.0) (occurance_of_current_feature 0) (total_features 0)) ;initialize all the variables
    	(dolist (feature (subseq feature-def 1)) ;iterate over the value of features
    		(dolist (example examples) ;iterate over examples
    			(dolist (ex example) ; iterate over current example
            		(if (eq (car ex) (car feature-def)) ;if feature name matches to that of example
            			(if (eq (cadr ex) feature) ; check if value of feature matches
    						(incf occurance_of_current_feature) ;increment the counter of occurance
    					)
    				) 
    			)

    			(incf total_features) ; increment total number of features
    			
    		)
    		
    		(setf sum (+ sum (* (/ occurance_of_current_feature total_features) (information (label-probabilities-for-feature-val examples (car feature-def) feature labels))))) ;calculates the remainder value using the provided formulae
    		(setf occurance_of_current_feature 0)
    		(setf total_features 0)
    	)
    	sum ;return the calculated sum
    )
)

;;example
;(print (remainder (fourth *restaurant-feature-defs*) *restaurant-examples* *restaurant-labels*))


;;    Returns the feature-def chosen from feature-defs 
;;    that best divides up examples. This is done by 
;;    picking the feature-def whose feature has 
;;    the lowest remainder given the examples and labels.  Ties
;;    for best are broken by picking the one considered earliest.
(defun choose-feature (feature-defs examples labels)
	
	(let ((chosen-feature (first feature-defs)) (remainder-value (remainder (first feature-defs) examples labels))) ;initialize all variables
        (dolist (feature  feature-defs) ;iterate over features
    		(setf re-val (remainder feature examples labels)) ;set remainder value for a example
    		(if (< re-val remainder-value) ;iterate to find smallest remainder
    			(progn ;if smaller value is found, note the feature and set the smallest value
    				(setf remainder-value re-val)
    				(setf chosen-feature feature)
    			)
    		)
    	)
        chosen-feature ;return the smallest feature
    )
)

;;examples
;(print (choose-feature *restaurant-feature-defs* *restaurant-examples* *restaurant-labels*))
;(print (choose-feature *restaurant-feature-defs* (last *restaurant-examples* 5) *restaurant-labels*))


;;Returns a list contaiing elements paired from the 2 sets according to their indexes.
(defun mapall(set1 set2)
  (loop for x in set1
    for y in set2
      collect (list (car y) x)
  )
)


;;Section C
;;Returns a dataset converted to one acceptable with trees.
(defun convert-dataset(datasets feature-defs labels)
    (let ((converted-datasets '()))
      (dolist (dataset datasets)
        (setf feature-set (mapall (car dataset) feature-defs)) ;set maps of features and values to feature-set
        (setf feature-set (append feature-set (list (list ':Label (caadr dataset))))) ;append label of example to feature-set
        (push feature-set converted-datasets) ;push current feature-set to main dataset
      )
      converted-datasets ;return the main dataset
    )
)

;;example for section c
(print (convert-dataset *example-dataset* *example-feature-defs* *example-labels*))



;;    Given a set of examples, a set of feature-defs, and a 
;;    set of label values, returns a decision tree which correctly 
;;    labelifies the examples.
(let ((unique (gensym)))
  (defun build-decision-tree (examples feature-defs labels &optional (default unique))
    (if (equalp default unique) ;set default if not mentioned in arguements
      (setf default (most-common-label examples))
    )

    (let ((x (copy-list examples)) (f (copy-list feature-defs)) (l-star default)) ;initialize variables
        (if (null x) ;if no examples in list
          (list ':Label default) ;return leaf node with default label
          ;else
          (if (examples-have-same-label-p x) ;if all examples have same label
            (list ':Label (label-of-example (car x))) ;return leaf node with label
            ;else
            (if (null f) ;if feature list is null
              (list ':Label (most-common-label x)) ;return leaf node with label as most common label
              ;else
              (let* ((feature (choose-feature f x labels)) (tree (list (car feature)))) ;initialize all variables including tree to a non leaf node
                (dolist (v (cdr feature) tree)   ;iterate over values of feature
                        (setf tree (append tree (list (list v 
                            (build-decision-tree (examples-with-feature-val x (car feature) v) (remove feature f :test #'equalp) labels (most-common-label x))
                            )))
                        ) ;create a child node recursively and append to the existing tree.
                    
                )
                
              )

            )
          )
        )
    )
 )
)    

;;example
(print (build-decision-tree *restaurant-examples* *restaurant-feature-defs* *restaurant-labels*)) 
#|Output of build decision tree 
=>(PATRONS (NONE (:LABEL NIL)) (SOME (:LABEL T))
 (FULL
  (HUNGRY
   (T
    (TYPE (FRENCH (:LABEL NIL))
     (THAI (OPEN-FRIDAY (T (:LABEL T)) (NIL (:LABEL NIL)))) (BURGER (:LABEL T))
     (ITALIAN (:LABEL NIL))))
|#

;;;;For Section B
(setf *t* (build-decision-tree *restaurant-trial-examples* *restaurant-feature-defs* *restaurant-labels*))
(print (mapcar #'label-of-example *restaurant-examples*)) ;=> (T NIL T T NIL T NIL T NIL NIL NIL T) 
(print (mapcar #'(lambda (x) (find-label-for-example x *t*)) *restaurant-examples*)) ;=> (T NIL T NIL NIL T NIL T T T NIL T) 

; Answer B : The decision tree classifies 3 wrong.
;We see that, first test set is not in training set and that second test set is in the training set.
;Both of these are classified correctly and thus we conclude that, correct classification is independant of whether the set is existing in the training set.

;Converts the dataset mentioned above to one accepptable with decision trees
(setf *my-converted-set* (convert-dataset *example-dataset* *example-feature-defs* *example-labels*))


;; For section B
;;A generalization function that returns the percentage of test sets that were correctly classified.
(defun generalization (train-set test-set feature-defs labels)  
    (let ((tree (build-decision-tree train-set feature-defs labels)) (total 0) (correct 0)) ;initialize the variables
        (dolist (set test-set) ;iterate over the test-set
            (if (equalp (find-label-for-example set tree) (label-of-example set)) ;check if labels from test set are classified correctly
                (incf correct) ;since example is correctly classified, increment the correct varible
            )
            (incf total) ;increment the total variable
        )
        (* 100.0 (/ correct total)) ;calculate percentage of correct values to the total values
    )
)

;;example
(print (generalization (butlast *my-converted-set* 94) (last *my-converted-set* 94) *example-feature-defs* *example-labels*))


