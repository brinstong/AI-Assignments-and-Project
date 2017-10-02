(load "mancala.lisp")

(defpackage :brinston-gonsalves
   (:use :common-lisp-user :common-lisp)
   (:export computer-make-move)
)
(in-package :brinston-gonsalves)

;; some optimization
(declaim 
	(optimize 
		(speed 3)
		(space 1)
		(debug 0)
		(compilation-speed 0)
		(safety 0)
	)
)



;; checks if the pit (num) is exactly reachable from the owners side 
;; such that the owner can utilize the big-win-rule.
(defun is-reachable (state num)
	(dotimes (n (- num (left-pit (player-owner num))))	;iterate over owners pits
		(let ((pit (+ (left-pit (player-owner num)) n))) ; set current pit
			(if (equalp (elt (state-board state) pit) (- num pit)) ; check if value of pit equals value reuired to utilize big-win-rule
				(return-from is-reachable t)
			)
		)
	)
	(return-from is-reachable nil)
)


(defun evaluate (state max-player)

   "Evaluates the game situation for MAX-PLAYER.
 Returns the value of STATE for MAX-PLAYER (who
 is either *player-1* or *player-2*).  This should
 be a value ranging from *min-wins* to *max-wins*."

 

 	(let* (
 			(my-score 0)
 			(my-mancala (elt (state-board state) (mancala-pit max-player))) ; stones currently in my mancala
 			(opp-mancala (elt (state-board state) (mancala-pit (other-player max-player)))) ; stones currently in opposite players mancala
 			(stones-left (- (* (* 2 *num-pits*) *initial-stones-per-pit*) (+ my-mancala opp-mancala))) ; stones that are currently available to play in the game.
 		)


 		;; if summation of either mancala with the stones left is less than the stones in other mancala
 		;; the game has already been won or lost. 
 		(if (> my-mancala (+ opp-mancala stones-left))
 			(return-from evaluate *max-wins*) ; we definately win
 			(if (> opp-mancala (+ my-mancala stones-left))
 				(return-from evaluate *min-wins*) ; we definately lose
 			)
 		)

 		;; compare the two mancala pits.
 		(let (temp-score)
	 		(if (> my-mancala opp-mancala)
	 			(setf temp-score (/ opp-mancala (+ my-mancala opp-mancala)))
	 			(if (> opp-mancala my-mancala)
	 				(setf temp-score (/ my-mancala (+ my-mancala opp-mancala)))
	 				(setf temp-score 0.5)
	 			)
	 		)

	 		(setf my-score (* temp-score 30)) ;; normalize and set the calculated score on 0 to 30 scale
 		)

		 ;; opposite player
		 ;; checks if the opponent can utilize the go-again-rule in the current state
 		(if *go-again-rule*
 			(let ((counter 0))
	 			(dotimes (n *num-pits*)
					(let ((num (+ n (left-pit (other-player max-player)))))
						(if (not (equalp (- (mancala-pit (other-player max-player)) num) (elt (state-board state) num)))
							(setf counter (+ counter 1))
						)
					)
	 			)
	 			; we found out in how many possible cases can the opponent not utilize the rule and accordingly weigh the case.
	 			(setf my-score (+ my-score (* (/ counter *num-pits*) 10))) ;; normalize and set the calculated score on 0 to 10 scale
 			)
 		)

 		;; ai bot
 		;; checks if we can utilize the go-again-rule in the current state
 		(if *go-again-rule*
 			(let ((counter 0))
	 			(dotimes (n *num-pits*)
					(let ((num (+ n (left-pit max-player))))
						(if (equalp (- (mancala-pit max-player) num) (elt (state-board state) num))
							(setf counter (+ counter 1))
						)
					)
				)
				; we found out in how many possible cases can we utilize the rule and accordingly weigh the case.
				(setf my-score (+ my-score (* (/ counter *num-pits*) 20))) ;; normalize and set the calculated score on 0 to 20 scale
 			)
 		)

 		;; opposite player
 		;; checks if the opponent can utilize the big-win-rule in the current state
 		(if *big-win-rule*
 			(dotimes (n *num-pits*)
				(let ((num (+ n (left-pit max-player))))
					(if (and 	(equalp (elt (state-board state) (pit-opposite num)) 0) 
								(>= (elt (state-board state) num) 1) 
								(is-reachable state (pit-opposite num))
						)
						; we find out in how many possible cases can the opponent utilize the rule and according to the number of stones in opposite pit, we weigh the case.
						(setf my-score (+ my-score (* (/ (- stones-left (elt (state-board state) (pit-opposite num))) stones-left) 10))) ;; normalize and set the calculated score on 0 to 10 scale
					)
				)
 			)
 		)


 		;; ai bot
 		;; checks if we can utilize the big-win-rule in the current state
 		(if *big-win-rule*
 			(dotimes (n *num-pits*)
				(let ((num (+ n (left-pit (other-player max-player)))))
					(if (and 
							(equalp (elt (state-board state) num) 0) 
							(>= (elt (state-board state) (pit-opposite num)) 1)
							(is-reachable state num)
						)
						; we find out in how many possible cases can we utilize the rule and according to the number of stones in opposite pit, we weigh the case.
						(setf my-score (+ my-score	(*	(/ (elt (state-board state) (pit-opposite num)) stones-left) 30))) ;; normalize and set the calculated score on 0 to 30 scale
					)
				)
 			)
 		)
 		;; we scale the calculated score in between min-wins and max-wins and return the scaled value
 		(return-from evaluate (+ (* (/ my-score 100) (- *max-wins* *min-wins*)) *min-wins*))
 	)
)


(defun alpha-beta (state current-depth max-depth
       max-player expand terminal evaluate
       alpha beta)


   "Does alpha-beta search.  Note that there is the addition of
 a variable called MAX-PLAYER rather than a function which specifies
 if it's max's turn.  It's just more convenient in this system.
 The MAX-PLAYER variable is set to either *player-1*
 or to *player-2* and indicates if *player-1* or *player-2* should
 be considered 'max' (the other player is then considered to be
 'min')"


 	(let ()
	 	(if (or (funcall terminal state) (>= current-depth max-depth)) ; checks if its the terminal step of the current depth is greater than the specified maximum depth
	 		(funcall evaluate state max-player) ; if so, we evaluate the current state
	 		;;else
	 		(if (equalp (state-turn state) max-player) ;; if it is max-player's turn
	 			(progn
		 			(dolist (c (funcall expand state)) ;; iterate over all reachable states from current state
		 				(let ((mm (alpha-beta c (+ current-depth 1) max-depth max-player expand terminal evaluate alpha beta)))
		 					(setf alpha (max alpha mm))
		 					(if (>= alpha beta)
		 						(return-from alpha-beta beta) ; return beta
		 					)
		 				)

		 			)
		 			(return-from alpha-beta alpha) ; return alpha
		 		) 
	 			;;else else
	 			(progn
	 				(dolist (c (funcall expand state)) ;; iterate over all reachable states from current state
		 				(let ((mm (alpha-beta c (+ current-depth 1) max-depth max-player expand terminal evaluate alpha beta)))
		 					(setf beta (min beta mm))
		 					(if (>= alpha beta)
		 						(return-from alpha-beta alpha) ; return alpha
		 					)
		 				)
		 			)
		 			(return-from alpha-beta beta) ; return beta
	 			)
	 		)
	 	)
 	)
)


 (defun computer-make-move (state max-depth)

   "Given a state, makes a move and returns the new state.
 If there is no move to make (end of game) returns nil.
 Each time this function calls the top-level
 alpha-beta function to search for the quality of a state,
 computer-make-move should print out the state (using PRINT,
 not PRINT-STATE) that is being searched.
 Only search up to max-depth.  The computer should assume
 that he is the player who's turn it is right now in STATE"

	
 	(let 	(best
 				(best-score *min-wins*) ; initialize best-score to min-wins
 				(all-states (moves state)) ; generate all possible states, reachable from current state.
 			)
 		(if (equalp all-states nil) ; if no states are reachable, return nil
 			(return-from computer-make-move nil)
 		)

 		(if (equalp (list-length all-states) 1) ; if only one state is reachable, skip evaluation and return move.
 			(return-from computer-make-move (car all-states))
 		)

 		(dolist (c all-states) ; iterate over all reachable states
 			(let ((score (alpha-beta c 0 max-depth (state-turn state) #'moves #'game-overp #'evaluate *min-wins* *max-wins*))) ; calculate a score for every reachable state using alpha-beta algorithm.
 				(print c) ; print the current top level state that was passed to the alpha beta algorithm.
 				
 				;; iterate to find the score and best-score.
 				(if (> score best-score)
 					(progn
 						(setf best c)
 						(setf best-score score)
 					)
 				)
 			)
 		)
 		(return-from computer-make-move best) ; return the state with the best score.
 	)
 )




(in-package :cl-user)
