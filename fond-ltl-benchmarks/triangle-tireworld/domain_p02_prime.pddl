(define (domain triangle-tire)
	(:requirements :typing :strips :non-deterministic)
	(:types location)
	(:predicates (vehicleat ?loc - location) (sparein ?loc - location) (road ?from - location ?to - location) (notflattire) (turnDomain) (q3 ?loc12 - location) (q1 ?loc12 - location) (q2 ?loc12 - location))
	(:action move-car
		:parameters (?from - location ?to - location)
		:precondition (and (vehicleat ?from) (road ?from ?to) (notflattire) (turnDomain))
		:effect (and (oneof (and (vehicleat ?to) (not (vehicleat ?from))) (and (vehicleat ?to) (not (vehicleat ?from)) (not (notflattire)))) (not (turnDomain)))
	)
	(:action changetire
		:parameters (?loc - location)
		:precondition (and (sparein ?loc) (vehicleat ?loc) (turnDomain))
		:effect (and (not (sparein ?loc)) (notflattire) (not (turnDomain)))
	)
	(:action trans-0
		:parameters (?loc12 - location)
		:precondition (and (or (and (q1 ?loc12) (vehicleat ?loc12)) (and (q2 ?loc12) (vehicleat ?loc12)) (q3 ?loc12)) (not (turnDomain)))
		:effect (and (q3 ?loc12) (not (q1 ?loc12)) (not (q2 ?loc12)) (turnDomain))
	)
	(:action trans-2
		:parameters (?loc12 - location)
		:precondition (and (or (and (q1 ?loc12) (not (vehicleat ?loc12))) (and (q2 ?loc12) (not (vehicleat ?loc12)))) (not (turnDomain)))
		:effect (and (q2 ?loc12) (not (q3 ?loc12)) (not (q1 ?loc12)) (turnDomain))
	)
)