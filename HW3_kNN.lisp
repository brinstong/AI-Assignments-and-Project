;; k-nearest-neighbour

(defparameter *neutral*
'((0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5) (0.1)))

(defparameter *voting-records-short*
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


;;The difference function calls the appropriate function according to the specified measure. 
;;If no measure is explicitly specified in the function call, the default measure count is used.
;;The count function can operate over non-numbers as well unlike squared and manhattan which require the lists to contain only numbers.
(defun difference (list1 list2 &key (measure 'count))

(cond

((eq measure 'count)
(count-difference list1 list2)
)

((eq measure 'squared)
(squared-difference list1 list2)
)

((eq measure 'manhattan)
(manhattan-difference list1 list2)
)
)
)

;;The count-difference function calculates the number of different elements at the corresponding positions in two lists.
(defun count-difference(list1 list2)
(if (not (null list1)) ;check if list is empty
(progn
(if (equalp (car list1) (car list2)) ;check if first values in both lists are equal
(+ 0 (count-difference (cdr list1) (cdr list2))) ;if equal, add 0 and call the function recursively with rest of the list
(+ 1 (count-difference (cdr list1) (cdr list2))) ;if not equal, add 1 and call the function recursively with rest of the list
))
0 ;return 0 when list is empty
))

;;The squared-difference function calculates the sum of the squared difference between the elements at corresponding positions in two lists.
(defun squared-difference(list1 list2)
(if (not (null list1)) ;check if list is empty
(progn
(setf diff (abs(- (car list1) (car list2)))) ;compute the difference between the first values of both lists
(+ (* diff diff) (squared-difference (cdr list1) (cdr list2))) ;call the function recursively with rest of the list and add the square of difference 
)
0 ;return when list is empty
))

;;The manhattan-difference function calculates the sum of absolute values of the differences between the elements at correponding positions in two lists. 
(defun manhattan-difference(list1 list2)
(if (not (null list1)) ;check if list is empty
(progn
(+ (abs(- (car list1) (car list2))) (manhattan-difference (cdr list1) (cdr list2))) ; call function recursively with rest of the list and add to the differnce in first elements
)
0 ;return when list is empty
))

;;The most-common function returns the most common element in the given list.
;;If multiple elements have the same maximum number count, the first element with the maximum count is returned. 
(defun most-common (list)
(let ((reduced-elts (mapcar (lambda (elt) (list elt (count elt list)))
(remove-duplicates list))))
(first (first (sort reduced-elts #'> :key #'second)))))

;;The k-nearest-neighbor function is the implementation of the K nearest neighbor algorithm.
(defun k-nearest-neighbor (examples new-example &key (k 1) (measure 'count))

;; A list is created with multiple lists that have 2 elements. 
;;The first element being the calculated differnce between the 2 lists under consideration and the second element being the corresponding label of the list.
(setf list-of-maps (loop for x in examples
do
collect (list (difference (car new-example) (car x) :measure measure) (car(car(cdr x))))
))

;;The list is sorted by the difference value.
(setf sorted-list (sort list-of-maps #'< :key #'first))

;;The list is trimmed to only the first k pairs in the list.
(setf closest-k (subseq sorted-list 0 k))

;; The most common label is evaluated and finally returned. 
(setf class (most-common 

;; This returns a list with just the label values from the trimmed list of maps.
(loop for (x y) in closest-k
do
collect y
)))
class
)

;;The generalization function calculates the percentage of correct predictions of the k-nearest-neighbor implementation. 
(defun generalization (training-examples test-examples &key (k 1) (measure 'count))

(setf correctly-classified 0)
(setf total 0)

;;This loop traverses through the test-examples list and checks if the k-nearest-neighbor correctly predicts the label of the list and accordingly increments the value of correctly-classified variable and the total variable.
(loop for x in test-examples
do
(if (equalp  (car (car (cdr x))) (k-nearest-neighbor training-examples x :k k :measure measure))
(incf correctly-classified)

)
(incf total)
)

;; Calculate the percentage of correct predictions to total predictions.
(* 100 (float (/ correctly-classified total)))
)

(k-nearest-neighbor *voting-records-short* *neutral* :k 3 :measure 'squared)
;; The neutral congressman is predicted to be a Republican(0.9). 


(generalization (butlast *voting-records-short* 94) (last *voting-records-short* 94) :measure 'squared :k 3)
;; The labels are correctly predicted 92.55319% times.












