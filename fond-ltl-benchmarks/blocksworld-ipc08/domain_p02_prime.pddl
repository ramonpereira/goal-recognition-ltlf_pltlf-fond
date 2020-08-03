(define (domain blocks-domain)
	(:requirements :non-deterministic :equality :typing)
	(:types block)
	(:predicates (holding ?b - block) (emptyhand) (ontable ?b - block) (on ?b1 - block ?b2 - block) (clear ?b - block) (q1 ?b-00 - block ?b-01 - block ?b-02 - block ?b1-03 - block ?b1-04 - block) (q2 ?b-00 - block ?b-01 - block ?b-02 - block ?b1-03 - block ?b1-04 - block) (q3 ?b-00 - block ?b-01 - block ?b-02 - block ?b1-03 - block ?b1-04 - block) (turnDomain))
	(:action pick-up
		:parameters (?b1 - block ?b2 - block)
		:precondition (and (not (= ?b1 ?b2)) (emptyhand) (clear ?b1) (on ?b1 ?b2) (turnDomain))
		:effect (and (oneof (and (holding ?b1) (clear ?b2) (not (emptyhand)) (not (clear ?b1)) (not (on ?b1 ?b2))) (and (clear ?b2) (ontable ?b1) (not (on ?b1 ?b2)))) (not (turnDomain)))
	)
	(:action pick-up-from-table
		:parameters (?b - block)
		:precondition (and (emptyhand) (clear ?b) (ontable ?b) (turnDomain))
		:effect (and (oneof (and) (and (holding ?b) (not (emptyhand)) (not (ontable ?b)))) (not (turnDomain)))
	)
	(:action put-on-block
		:parameters (?b1 - block ?b2 - block)
		:precondition (and (holding ?b1) (clear ?b2) (turnDomain))
		:effect (and (oneof (and (on ?b1 ?b2) (emptyhand) (clear ?b1) (not (holding ?b1)) (not (clear ?b2))) (and (ontable ?b1) (emptyhand) (clear ?b1) (not (holding ?b1)))) (not (turnDomain)))
	)
	(:action put-down
		:parameters (?b - block)
		:precondition (and (holding ?b) (turnDomain))
		:effect (and (ontable ?b) (emptyhand) (clear ?b) (not (holding ?b)) (not (turnDomain)))
	)
	(:action pick-tower
		:parameters (?b1 - block ?b2 - block ?b3 - block)
		:precondition (and (emptyhand) (on ?b1 ?b2) (on ?b2 ?b3) (turnDomain))
		:effect (and (oneof (and) (and (holding ?b2) (clear ?b3) (not (emptyhand)) (not (on ?b2 ?b3)))) (not (turnDomain)))
	)
	(:action put-tower-on-block
		:parameters (?b1 - block ?b2 - block ?b3 - block)
		:precondition (and (holding ?b2) (on ?b1 ?b2) (clear ?b3) (turnDomain))
		:effect (and (oneof (and (on ?b2 ?b3) (emptyhand) (not (holding ?b2)) (not (clear ?b3))) (and (ontable ?b2) (emptyhand) (not (holding ?b2)))) (not (turnDomain)))
	)
	(:action put-tower-down
		:parameters (?b1 - block ?b2 - block)
		:precondition (and (holding ?b2) (on ?b1 ?b2) (turnDomain))
		:effect (and (ontable ?b2) (emptyhand) (not (holding ?b2)) (not (turnDomain)))
	)
	(:action trans-0
		:parameters (?b-00 - block ?b-01 - block ?b-02 - block ?b1-03 - block ?b1-04 - block)
		:precondition (and (or (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (not (emptyhand))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (not (ontable ?b-00))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (not (ontable ?b-01))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (not (ontable ?b-02))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (not (on ?b1-03 ?b-00))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (not (on ?b1-04 ?b-01))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (not (clear ?b-02))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (clear ?b-02) (not (clear ?b1-03))) (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (clear ?b-02) (clear ?b1-03) (not (clear ?b1-04))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (not (emptyhand))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (not (ontable ?b-00))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (not (ontable ?b-01))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (not (ontable ?b-02))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (not (on ?b1-03 ?b-00))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (not (on ?b1-04 ?b-01))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (not (clear ?b-02))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (clear ?b-02) (not (clear ?b1-03))) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (clear ?b-02) (clear ?b1-03) (not (clear ?b1-04)))) (not (turnDomain)))
		:effect (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (not (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04)) (not (q3 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04)) (turnDomain))
	)
	(:action trans-1
		:parameters (?b-00 - block ?b-01 - block ?b-02 - block ?b1-03 - block ?b1-04 - block)
		:precondition (and (or (and (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (clear ?b-02) (clear ?b1-03) (clear ?b1-04)) (and (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (emptyhand) (ontable ?b-00) (ontable ?b-01) (ontable ?b-02) (on ?b1-03 ?b-00) (on ?b1-04 ?b-01) (clear ?b-02) (clear ?b1-03) (clear ?b1-04)) (q3 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04)) (not (turnDomain)))
		:effect (and (q3 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04) (not (q1 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04)) (not (q2 ?b-00 ?b-01 ?b-02 ?b1-03 ?b1-04)) (turnDomain))
	)
)