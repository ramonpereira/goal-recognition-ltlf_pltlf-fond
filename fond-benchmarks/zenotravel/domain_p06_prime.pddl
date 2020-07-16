(define (domain zenotravel)
	(:requirements :typing :non-deterministic)
	(:types aircraft person city flevel)
	(:predicates (atperson ?p - person ?c - city) (ataircraft ?a - aircraft ?c - city) (boarding ?p - person ?a - aircraft) (notboarding ?p - person) (in ?p - person ?a - aircraft) (debarking ?p - person ?a - aircraft) (notdebarking ?p - person) (fuellevel ?a - aircraft ?l - flevel) (next ?l1 - flevel ?l2 - flevel) (flying ?a - aircraft ?c - city) (zooming ?a - aircraft ?c - city) (refueling ?a - aircraft) (notrefueling ?a - aircraft) (turnDomain) (q3 ?p92 - person ?c93 - city ?p16 - person ?c55 - city ?p34 - person ?c96 - city ?p01 - person ?c33 - city ?p03 - person ?c32 - city) (q2 ?p92 - person ?c93 - city ?p16 - person ?c55 - city ?p34 - person ?c96 - city ?p01 - person ?c33 - city ?p03 - person ?c32 - city) (q1 ?p92 - person ?c93 - city ?p16 - person ?c55 - city ?p34 - person ?c96 - city ?p01 - person ?c33 - city ?p03 - person ?c32 - city))
	(:action start-boarding
		:parameters (?p - person ?a - aircraft ?c - city)
		:precondition (and (atperson ?p ?c) (ataircraft ?a ?c) (turnDomain))
		:effect (and (not (atperson ?p ?c)) (not (notboarding ?p)) (boarding ?p ?a) (not (turnDomain)))
	)
	(:action complete-boarding
		:parameters (?p - person ?a - aircraft ?c - city)
		:precondition (and (boarding ?p ?a) (ataircraft ?a ?c) (turnDomain))
		:effect (and (oneof (and) (and (not (boarding ?p ?a)) (in ?p ?a) (notboarding ?p))) (not (turnDomain)))
	)
	(:action start-debarking
		:parameters (?p - person ?a - aircraft ?c - city)
		:precondition (and (in ?p ?a) (ataircraft ?a ?c) (turnDomain))
		:effect (and (not (in ?p ?a)) (not (notdebarking ?p)) (debarking ?p ?a) (not (turnDomain)))
	)
	(:action complete-debarking
		:parameters (?p - person ?a - aircraft ?c - city)
		:precondition (and (debarking ?p ?a) (ataircraft ?a ?c) (turnDomain))
		:effect (and (oneof (and) (and (not (debarking ?p ?a)) (atperson ?p ?c) (notdebarking ?p))) (not (turnDomain)))
	)
	(:action start-flying
		:parameters (?a - aircraft ?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel)
		:precondition (and (ataircraft ?a ?c1) (fuellevel ?a ?l1) (next ?l2 ?l1) (notrefueling ?a) (forall (?p - person) (and (notboarding ?p) (notdebarking ?p))) (turnDomain))
		:effect (and (not (ataircraft ?a ?c1)) (flying ?a ?c2) (not (turnDomain)))
	)
	(:action complete-flying
		:parameters (?a - aircraft ?c2 - city ?l1 - flevel ?l2 - flevel)
		:precondition (and (flying ?a ?c2) (fuellevel ?a ?l1) (next ?l2 ?l1) (turnDomain))
		:effect (and (oneof (and) (and (not (flying ?a ?c2)) (ataircraft ?a ?c2) (not (fuellevel ?a ?l1)) (fuellevel ?a ?l2))) (not (turnDomain)))
	)
	(:action start-zooming
		:parameters (?a - aircraft ?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel ?l3 - flevel)
		:precondition (and (ataircraft ?a ?c1) (fuellevel ?a ?l1) (next ?l2 ?l1) (next ?l3 ?l2) (notrefueling ?a) (forall (?p - person) (and (notboarding ?p) (notdebarking ?p))) (turnDomain))
		:effect (and (not (ataircraft ?a ?c1)) (zooming ?a ?c2) (not (turnDomain)))
	)
	(:action complete-zooming
		:parameters (?a - aircraft ?c2 - city ?l1 - flevel ?l2 - flevel ?l3 - flevel)
		:precondition (and (zooming ?a ?c2) (fuellevel ?a ?l1) (next ?l2 ?l1) (next ?l3 ?l2) (turnDomain))
		:effect (and (oneof (and) (and (not (zooming ?a ?c2)) (ataircraft ?a ?c2) (not (fuellevel ?a ?l1)) (fuellevel ?a ?l3))) (not (turnDomain)))
	)
	(:action start-refueling
		:parameters (?a - aircraft ?c - city ?l - flevel ?l1 - flevel)
		:precondition (and (ataircraft ?a ?c) (notrefueling ?a) (fuellevel ?a ?l) (next ?l ?l1) (turnDomain))
		:effect (and (refueling ?a) (not (notrefueling ?a)) (not (turnDomain)))
	)
	(:action complete-refuling
		:parameters (?a - aircraft ?l - flevel ?l1 - flevel)
		:precondition (and (refueling ?a) (fuellevel ?a ?l) (next ?l ?l1) (turnDomain))
		:effect (and (oneof (and) (and (not (refueling ?a)) (notrefueling ?a) (fuellevel ?a ?l1) (not (fuellevel ?a ?l)))) (not (turnDomain)))
	)
	(:action trans-0
		:parameters (?p92 - person ?c93 - city ?p16 - person ?c55 - city ?p34 - person ?c96 - city ?p01 - person ?c33 - city ?p03 - person ?c32 - city)
		:precondition (and (or (and (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (atperson ?p34 ?c96) (atperson ?p01 ?c33) (atperson ?p03 ?c32)) (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (atperson ?p34 ?c96) (atperson ?p01 ?c33) (atperson ?p03 ?c32)) (q3 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32)) (not (turnDomain)))
		:effect (and (q3 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (not (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32)) (not (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32)) (turnDomain))
	)
	(:action trans-1
		:parameters (?p92 - person ?c93 - city ?p16 - person ?c55 - city ?p34 - person ?c96 - city ?p01 - person ?c33 - city ?p03 - person ?c32 - city)
		:precondition (and (or (and (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (not (atperson ?p92 ?c93))) (and (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (not (atperson ?p16 ?c55))) (and (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (not (atperson ?p34 ?c96))) (and (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (atperson ?p34 ?c96) (not (atperson ?p01 ?c33))) (and (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (atperson ?p34 ?c96) (atperson ?p01 ?c33) (not (atperson ?p03 ?c32))) (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (not (atperson ?p92 ?c93))) (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (not (atperson ?p16 ?c55))) (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (not (atperson ?p34 ?c96))) (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (atperson ?p34 ?c96) (not (atperson ?p01 ?c33))) (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (atperson ?p92 ?c93) (atperson ?p16 ?c55) (atperson ?p34 ?c96) (atperson ?p01 ?c33) (not (atperson ?p03 ?c32)))) (not (turnDomain)))
		:effect (and (q2 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32) (not (q3 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32)) (not (q1 ?p92 ?c93 ?p16 ?c55 ?p34 ?c96 ?p01 ?c33 ?p03 ?c32)) (turnDomain))
	)
)