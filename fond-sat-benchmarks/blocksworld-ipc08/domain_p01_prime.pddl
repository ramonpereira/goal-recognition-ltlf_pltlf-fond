(define (domain blocks-domain)
  (:requirements :non-deterministic :equality :typing)
  (:types block)
  (:predicates (holding ?b - block) (emptyhand) (on-table ?b - block) (on ?b1 - block ?b2 - block) (clear ?b - block) (turnDomain) (q2 ?b25 - block ?b146 - block ?b204 - block) (q3 ?b25 - block ?b146 - block ?b204 - block) (q1 ?b25 - block ?b146 - block ?b204 - block))
  (:action pick-up
    :parameters (?b1 - block ?b2 - block)
    :precondition (and (not (= ?b1 ?b2)) (emptyhand) (clear ?b1) (on ?b1 ?b2) (turnDomain))
    :effect (and (oneof (and (holding ?b1) (clear ?b2) (not (emptyhand)) (not (clear ?b1)) (not (on ?b1 ?b2))) (and (clear ?b2) (on-table ?b1) (not (on ?b1 ?b2)))) (not (turnDomain)))
  )
  (:action pick-up-from-table
    :parameters (?b - block)
    :precondition (and (emptyhand) (clear ?b) (on-table ?b) (turnDomain))
    :effect (and (oneof (and) (and (holding ?b) (not (emptyhand)) (not (on-table ?b)))) (not (turnDomain)))
  )
  (:action put-on-block
    :parameters (?b1 - block ?b2 - block)
    :precondition (and (holding ?b1) (clear ?b2) (turnDomain))
    :effect (and (oneof (and (on ?b1 ?b2) (emptyhand) (clear ?b1) (not (holding ?b1)) (not (clear ?b2))) (and (on-table ?b1) (emptyhand) (clear ?b1) (not (holding ?b1)))) (not (turnDomain)))
  )
  (:action put-down
    :parameters (?b - block)
    :precondition (and (holding ?b) (turnDomain))
    :effect (and (on-table ?b) (emptyhand) (clear ?b) (not (holding ?b)) (not (turnDomain)))
  )
  (:action pick-tower
    :parameters (?b1 - block ?b2 - block ?b3 - block)
    :precondition (and (emptyhand) (on ?b1 ?b2) (on ?b2 ?b3) (turnDomain))
    :effect (and (oneof (and) (and (holding ?b2) (clear ?b3) (not (emptyhand)) (not (on ?b2 ?b3)))) (not (turnDomain)))
  )
  (:action put-tower-on-block
    :parameters (?b1 - block ?b2 - block ?b3 - block)
    :precondition (and (holding ?b2) (on ?b1 ?b2) (clear ?b3) (turnDomain))
    :effect (and (oneof (and (on ?b2 ?b3) (emptyhand) (not (holding ?b2)) (not (clear ?b3))) (and (on-table ?b2) (emptyhand) (not (holding ?b2)))) (not (turnDomain)))
  )
  (:action put-tower-down
    :parameters (?b1 - block ?b2 - block)
    :precondition (and (holding ?b2) (on ?b1 ?b2) (turnDomain))
    :effect (and (on-table ?b2) (emptyhand) (not (holding ?b2)) (not (turnDomain)))
  )
  (:action trans-0
    :parameters (?b25 - block ?b146 - block ?b204 - block)
    :precondition (and (or (and (q1 ?b25 ?b146 ?b204) (not (clear ?b25))) (and (q1 ?b25 ?b146 ?b204) (clear ?b25) (not (on ?b146 ?b204))) (and (q1 ?b25 ?b146 ?b204) (clear ?b25) (on ?b146 ?b204) (not (on ?b25 ?b146))) (and (q2 ?b25 ?b146 ?b204) (not (clear ?b25))) (and (q2 ?b25 ?b146 ?b204) (clear ?b25) (not (on ?b146 ?b204))) (and (q2 ?b25 ?b146 ?b204) (clear ?b25) (on ?b146 ?b204) (not (on ?b25 ?b146)))) (not (turnDomain)))
    :effect (and (q2 ?b25 ?b146 ?b204) (not (q3 ?b25 ?b146 ?b204)) (not (q1 ?b25 ?b146 ?b204)) (turnDomain))
  )
  (:action trans-1
    :parameters (?b25 - block ?b146 - block ?b204 - block)
    :precondition (and (or (and (q1 ?b25 ?b146 ?b204) (clear ?b25) (on ?b146 ?b204) (on ?b25 ?b146)) (and (q2 ?b25 ?b146 ?b204) (clear ?b25) (on ?b146 ?b204) (on ?b25 ?b146)) (q3 ?b25 ?b146 ?b204)) (not (turnDomain)))
    :effect (and (q3 ?b25 ?b146 ?b204) (not (q2 ?b25 ?b146 ?b204)) (not (q1 ?b25 ?b146 ?b204)) (turnDomain))
  )
)