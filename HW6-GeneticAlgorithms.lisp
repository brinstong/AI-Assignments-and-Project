;;;; Assignment on Genetic Algorithms

;;; Some utility Functions and Macros that you might find to be useful (hint)
(defmacro while (test &rest body)
  "Repeatedly executes body as long as test returns true.  Then returns nil."
  `(loop while ,test do (progn ,@body)))


(defun random? (&optional (prob 0.5))
  "Tosses a coin of prob probability of coming up heads,
then returns t if it's heads, else nil."
  (< (random 1.0) prob))


(defun generate-list (num function &optional no-duplicates)
  "Generates a list of size NUM, with each element created by
  (funcall FUNCTION).  If no-duplicates is t, then no duplicates
are permitted (FUNCTION is repeatedly called until a unique
new slot is created).  EQUALP is the default test used for duplicates."
  (let (bag)
    (while (< (length bag) num)
      (let ((candidate (funcall function)))
	(unless (and no-duplicates
		     (member candidate bag :test #'equalp))
	  (push candidate bag))))
    bag))


;; hope this works right
(defun gaussian-random (mean variance)
  "Generates a random number under a gaussian distribution with the
given mean and variance (using the Box-Muller-Marsaglia method)"
  (let (x y (w 0))
    (while (not (and (< 0 w) (< w 1)))
	   (setf x (- (random 2.0) 1.0))
	   (setf y (- (random 2.0) 1.0))
	   (setf w (+ (* x x) (* y y))))
    (+ mean (* x (sqrt variance) (sqrt (* -2 (/ (log w) w)))))))


;;;;;; TOP-LEVEL EVOLUTIONARY COMPUTATION FUNCTIONS 

;;; TOURNAMENT SELECTION

;; is this a good setting?  Try tweaking it (any integer >= 2) and see
(defparameter *tournament-size* 10)
(defun tournament-select-one (population fitnesses)
  "Does one tournament selection and returns the selected individual."

  (let*  (
          (n (random (length population))) ; initialize to random number between 0 and population size 
          (best (nth n population)) ; initialize best to value of nth individual
          (fitness-of-best (nth n fitnesses)) ; initialize fitness of selected best
          fitness-of-next 
        )
    
    (dotimes (counter (- *tournament-size* 1))
      (setf n (random (length population))) ; select n randomnly
      (setf fitness-of-next (nth n fitnesses)) ; get fitness of selected individual
      
      (if (> fitness-of-next fitness-of-best) ; compare fitness to find best
        (progn
          (setf best (nth n population))
          (setf fitness-of-best fitness-of-next)
        )
      )
    )
    best ; return the best individual in population
  )
)

(defun tournament-selector (num population fitnesses)
  "Does NUM tournament selections, and puts them all in a list, then returns the list"

  (let ((output-list '()))
    (dotimes (counter num) ; iteratively call tournament-select-one method num times 
      (let ((output (tournament-select-one population fitnesses)))
        (setf output-list (append output-list (list output)))
      )
    )
    output-list ; returns list of outputs.
  )
)

(defun simple-printer (pop fitnesses)
  "Determines the individual in pop with the best (highest) fitness, then
prints that fitness and individual in a pleasing manner."
  (let (best-ind best-fit)
    (mapcar #'(lambda (ind fit)
		(when (or (not best-ind)
			  (< best-fit fit))
		  (setq best-ind ind)
		  (setq best-fit fit))) pop fitnesses)
    (format t "~%Best Individual of Generation...~%Fitness : ~a~%Individual : ~a~%"
	    best-fit best-ind)
    fitnesses))

;; Custom function for printing the final values including best individual and best fitness.
(defun my-final-printer (ind fit)
  (format t "~%Best Individual of All Processed Generations :~%Fitness : ~a~%Individual : ~a~%" fit ind)
)



;; re-used from provided simple printer function
;; calculates best individual and fit from given population.
(defun my-get-best-ind-fit (population fitnesses best-ind best-fit)

  (mapcar #'(lambda (ind fit) ; traverse through population and fitnesses
            (when (or (not best-ind) (< best-fit fit)) ; if new best found
              (setq best-ind ind)
              (setq best-fit fit)
            )
              )
        population fitnesses)

  (list best-ind best-fit) ; return list of best individual and fitnesses
  
)

;; custom function that creates a new popultation and returns it.
(defun my-generate-new-population (population fitnesses modifier selector)
  (apply #'append
    (mapcar modifier
      (funcall selector (/ (length population) 2) population fitnesses)
      (funcall selector (/ (length population) 2) population fitnesses)
    )
  )
)


(defun evolve (generations pop-size
         &key setup creator selector modifier evaluator printer)
  "Evolves for some number of GENERATIONS, creating a population of size POP-SIZE, using various functions"

  
  (funcall setup) ; make initial setup
  (let*  (
          best-ind 
          best-fit 
          (population (generate-list pop-size creator)) ; generate the initial population
        )  

    (dotimes (generation-counter generations) ; iterate through the block, once for each generation.
      (format t "~%Current Generation : ~a" (+ 1 generation-counter))
      
      (let ((fitnesses (mapcar evaluator population))) ; generate the fitness values for the population

        
        ;; calculate and declare the values for best individual and fitness

        (setf ind-fit-list (my-get-best-ind-fit population fitnesses best-ind best-fit)) 
        (setf best-ind (first ind-fit-list))
        (setf best-fit (second ind-fit-list))

        ;; print the details about the current generation.
        (funcall printer population fitnesses)

        ;; generate new population and replace it for the old population
        (setf population (copy-seq (my-generate-new-population population fitnesses modifier selector)))
      )
    )
    ;; prints the best individual and fitness for all the generations processed
    (my-final-printer best-ind best-fit)
  )
)


(defparameter *float-vector-length* 20 
  "The length of the vector individuals")
(defparameter *float-min* -5.12 
  "The minimum legal value of a number in a vector") 
(defparameter *float-max* 5.12 
  "The maximum legal value of a number in a vector")






;; custom function that generates numbers randomly between float-min and float-max
(defun my-randombw ()
  (+ (random (- *float-max* *float-min*)) *float-min*)
)


(defun float-vector-creator ()
  "Creates a floating-point-vector *float-vector-length* in size, filled with
UNIFORM random numbers in the range appropriate to the given problem"

  (generate-list *float-vector-length* 'my-randombw)

)


;; I just made up these numbers, you'll probably need to tweak them
(defparameter *crossover-probability* 0.1
  "Per-gene probability of crossover in uniform crossover")
(defparameter *mutation-probability* 0.1
  "Per-gene probability of mutation in gaussian convolution") 
(defparameter *mutation-variance* 0.02
  "Per-gene mutation variance in gaussian convolution")





(defun uniform-crossover (ind1 ind2)
  "Performs uniform crossover on the two individuals, modifying them in place.
*crossover-probability* is the probability that any given allele will crossover.  
The individuals are guaranteed to be the same length.  Returns NIL."

  
  (dotimes (n (length ind1))
    (if (>= (random 1.0) *crossover-probability*) ; randomly decides whether to perform crossover.
      (rotatef (elt ind1 n) (elt ind2 n)) ; swaps the two elements
    )
  )
  nil
)


(defun gaussian-convolution (ind)
  "Performs gaussian convolution mutation on the individual, modifying it in place.
 Returns NIL."

     
  (dotimes 
    (counter (length ind))
    (let* (
              (mean (/ (+ *float-min* *float-max*) 2)) ; calculate mean
              (n (gaussian-random mean *mutation-variance*)) 
          )
      (if (random? *mutation-probability*)
        (progn
          (while (not (and (<= *float-min* (+ (elt ind counter) n)) (<= (+ (elt ind counter) n) *float-max*)))
            (setf n (gaussian-random mean *mutation-variance*))
          )       
          (setf (elt ind counter) (+ (elt ind counter) n))
        )
      )
    )
  )
  nil
)


(defun float-vector-modifier (ind1 ind2)
  "Copies and modifies ind1 and ind2 by crossing them over with a uniform crossover,
then mutates the children.  *crossover-probability* is the probability that any
given allele will crossover.  *mutation-probability* is the probability that any
given allele in a child will mutate.  Mutation does gaussian convolution on the allele."

  (let* (
          (ind-cpy1 (copy-seq ind1))
          (ind-cpy2 (copy-seq ind2))
        )
    (uniform-crossover ind-cpy1 ind-cpy2)
    (gaussian-convolution ind-cpy1)
    (gaussian-convolution ind-cpy2)
    (list ind-cpy1 ind-cpy2)
  ) 
)


;; you probably don't need to implement anything here
(defun float-vector-sum-setup ()
  "Does nothing.  Perhaps you might use this function to set
(ahem) various global variables which define the problem being evaluated
and the floating-point ranges involved, etc.  I dunno."


  )





;;; FITNESS EVALUATION FUNCTIONS

;;; I'm providing you with some classic objective functions.  See section 11.2.2 of
;;; Essentials of Metaheuristics for details on these functions.
;;;
;;; Many of these functions (sphere, rosenbrock, rastrigin, schwefel) are
;;; traditionally minimized rather than maximized.  We're assuming that higher
;;; values are "fitter" in this class, so I have taken the liberty of converting
;;; all the minimization functions into maximization functions by negating their
;;; outputs.  This means that you'll see a lot of negative values and that's fine;
;;; just remember that higher is always better.
;;; 
;;; These functions also traditionally operate with different bounds on the
;;; minimum and maximum values of the numbers in the individuals' vectors.  
;;; Let's assume that for all of these functions, these values can legally
;;; range from -5.12 to 5.12 inclusive.  One function (schwefel) normally goes from
;;; about -511 to +512, so if you look at the code you can see I'm multiplying
;;; the values by 100 to properly scale it so it now uses -5.12 to 5.12.


(defun sum-f (ind)
  "Performs the Sum objective function.  Assumes that ind is a list of floats"
  (reduce #'+ ind))

(defun step-f (ind)
  "Performs the Step objective function.  Assumes that ind is a list of floats"
  (+ (* 6 (length ind))
     (reduce #'+ (mapcar #'floor ind))))

(defun sphere-f (ind)
  "Performs the Sphere objective function.  Assumes that ind is a list of floats"
  (- (reduce #'+ (mapcar (lambda (x) (* x x)) ind))))

(defun rosenbrock-f (ind)
  "Performs the Rosenbrock objective function.  Assumes that ind is a list of floats"
  (- (reduce #'+ (mapcar (lambda (x x1)
			   (+ (* (- 1 x) (- 1 x))
			      (* 100 (- x1 (* x x)) (- x1 (* x x)))))
			 ind (rest ind)))))

(defun rastrigin-f (ind)
  "Performs the Rastrigin objective function.  Assumes that ind is a list of floats"
  (- (+ (* 10 (length ind))
	(reduce #'+ (mapcar (lambda (x) (- (* x x) (* 10 (cos (* 2 pi x)))))
			    ind)))))

(defun schwefel-f (ind)
  "Performs the Schwefel objective function.  Assumes that ind is a list of floats"
  (- (reduce #'+ (mapcar (lambda (x) (* (- x) (sin (sqrt (abs x)))))	
			 (mapcar (lambda (x) (* x 100)) ind)))))




; sample input
(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'sum-f
  :printer #'simple-printer)



#|
Sample inputs/outputs

For tournament size : 2

(evolve 50 1000
 	:setup #'float-vector-sum-setup
	:creator #'float-vector-creator
	:selector #'tournament-selector
	:modifier #'float-vector-modifier
        :evaluator #'sum-f
	:printer #'simple-printer)


Best Individual of All Processed Generations :
Fitness : 102.236626
Individual : (5.1159368 5.108865 5.1159506 5.1195064 5.103363 5.109765
              5.1177125 5.112349 5.1195884 5.1043143 5.1175265 5.113255 ...)



(evolve 50 2000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'sum-f
  :printer #'simple-printer)


Best Individual of All Processed Generations :
Fitness : 102.201584
Individual : (5.119849 5.1018815 5.118759 5.1169715 5.107739 5.095802 5.109308
              5.080068 5.1196504 5.10306 5.1178565 5.105535 ...)


(evolve 100 2000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'sum-f
  :printer #'simple-printer)


Best Individual of All Processed Generations :
Fitness : 102.36601
Individual : (5.118922 5.115107 5.119434 5.1191435 5.1190906 5.1175685 5.119939
              5.1199727 5.116152 5.1188726 5.11968 5.1180754 ...)


(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'step-f
  :printer #'simple-printer)


Best Individual of All Processed Generations :
Fitness : 220
Individual : (5.0912995 5.0267124 5.0460215 5.101073 5.105019 5.042077
              5.0234165 5.0254483 5.0413322 5.098801 5.07938 5.0505857 ...)


(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'sphere-f
  :printer #'simple-printer)


Best Individual of All Processed Generations :
Fitness : -0.0044313665
Individual : (0.013427541 -0.0035852194 0.002470851 -0.016265497 0.003099978
              0.0068015233 -0.0030542687 -0.004129395 -0.0070693344
              -0.021646805 -0.02308649 -0.01506215 ...)


(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'rosenbrock-f
  :printer #'simple-printer)

Best Individual of All Processed Generations :
Fitness : -19.682245
Individual : (0.36526144 0.16863585 0.055856794 0.027752655 0.014042739
              -0.010263041 0.019963779 0.0072015524 0.0054325983 0.051831685
              0.02183424 -0.038807794 ...)


(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'rastrigin-f
  :printer #'simple-printer)

Best Individual of All Processed Generations :
Fitness : -2.957311439566098d0
Individual : (-0.018631041 -0.004766941 -7.8751147e-4 0.0043728873 -0.028091595
              0.013930082 -0.013049468 -0.010090085 -4.35777e-4 0.031444315
              0.029134825 -0.022521283 ...)


(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'schwefel-f
  :printer #'simple-printer)


Best Individual of All Processed Generations :
Fitness : 8374.568
Individual : (4.1989665 4.211687 4.1978607 4.2141876 4.22817 4.1953835 4.21904
              4.199632 4.2273836 4.218354 4.191541 4.209193 ...)


For tournament size 10 :

(evolve 50 1000
  :setup #'float-vector-sum-setup
  :creator #'float-vector-creator
  :selector #'tournament-selector
  :modifier #'float-vector-modifier
        :evaluator #'sum-f
  :printer #'simple-printer)

Best Individual of All Processed Generations :
Fitness : 102.26083
Individual : (5.1158915 5.117499 5.1145473 5.11641 5.109796 5.0902047 5.097047
              5.114358 5.119789 5.1164865 5.118658 5.1100245 ...)

|#






