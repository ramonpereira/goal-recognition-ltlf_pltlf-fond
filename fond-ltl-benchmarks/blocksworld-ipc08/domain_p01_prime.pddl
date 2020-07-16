(define (domain blocks-domain)
	(:requirements :non-deterministic :equality :typing)
	(:types block)
	(:predicates (holding ?b - block) (emptyhand) (ontable ?b - block) (on ?b1 - block ?b2 - block) (clear ?b - block) (turnDomain) (q3 ?b13 - block ?b11 - block ?b107 - block ?b236 - block ?b99 - block) (q2 ?b13 - block ?b11 - block ?b107 - block ?b236 - block ?b99 - block) (q1 ?b13 - block ?b11 - block ?b107 - block ?b236 - block ?b99 - block))
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
		:parameters (?b13 - block ?b11 - block ?b107 - block ?b236 - block ?b99 - block)
		:precondition (and (or (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (ontable ?b99) (on ?b236 ?b99) (clear ?b107)) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (ontable ?b99) (on ?b236 ?b99) (clear ?b107)) (q3 ?b13 ?b11 ?b107 ?b236 ?b99)) (not (turnDomain)))
		:effect (and (q3 ?b13 ?b11 ?b107 ?b236 ?b99) (not (q2 ?b13 ?b11 ?b107 ?b236 ?b99)) (not (q1 ?b13 ?b11 ?b107 ?b236 ?b99)) (turnDomain))
	)
	(:action trans-1
		:parameters (?b13 - block ?b11 - block ?b107 - block ?b236 - block ?b99 - block)
		:precondition (and (or (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (not (ontable ?b13))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (not (ontable ?b11))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (not (clear ?b11))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (not (emptyhand))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (not (clear ?b13))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (not (on ?b107 ?b236))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (not (ontable ?b99))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (ontable ?b99) (not (on ?b236 ?b99))) (and (q1 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (ontable ?b99) (on ?b236 ?b99) (not (clear ?b107))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (not (ontable ?b13))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (not (ontable ?b11))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (not (clear ?b11))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (not (emptyhand))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (not (clear ?b13))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (not (on ?b107 ?b236))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (not (ontable ?b99))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (ontable ?b99) (not (on ?b236 ?b99))) (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (ontable ?b13) (ontable ?b11) (clear ?b11) (emptyhand) (clear ?b13) (on ?b107 ?b236) (ontable ?b99) (on ?b236 ?b99) (not (clear ?b107)))) (not (turnDomain)))
		:effect (and (q2 ?b13 ?b11 ?b107 ?b236 ?b99) (not (q3 ?b13 ?b11 ?b107 ?b236 ?b99)) (not (q1 ?b13 ?b11 ?b107 ?b236 ?b99)) (turnDomain))
	)
)