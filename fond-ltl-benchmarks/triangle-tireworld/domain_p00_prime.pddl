(define (domain triangle-tire)
	(:requirements :typing :strips :non-deterministic)
	(:types location)
	(:predicates (vehicleat ?loc - location) (sparein ?loc - location) (road ?from - location ?to - location) (notflattire) (q1 ?loc-00 - location ?loc-01 - location) (q2 ?loc-00 - location ?loc-01 - location) (q3 ?loc-00 - location ?loc-01 - location) (q4 ?loc-00 - location ?loc-01 - location) (turnDomain))
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
		:parameters (?loc-00 - location ?loc-01 - location)
		:precondition (and (or (and (q1 ?loc-00 ?loc-01) (not (vehicleat ?loc-00))) (and (q2 ?loc-00 ?loc-01) (not (vehicleat ?loc-00)))) (not (turnDomain)))
		:effect (and (q2 ?loc-00 ?loc-01) (not (q1 ?loc-00 ?loc-01)) (not (q3 ?loc-00 ?loc-01)) (not (q4 ?loc-00 ?loc-01)) (turnDomain))
	)
	(:action trans-1
		:parameters (?loc-00 - location ?loc-01 - location)
		:precondition (and (or (and (q1 ?loc-00 ?loc-01) (vehicleat ?loc-00)) (and (q2 ?loc-00 ?loc-01) (vehicleat ?loc-00)) (and (q3 ?loc-00 ?loc-01) (not (vehicleat ?loc-01)))) (not (turnDomain)))
		:effect (and (q3 ?loc-00 ?loc-01) (not (q1 ?loc-00 ?loc-01)) (not (q2 ?loc-00 ?loc-01)) (not (q4 ?loc-00 ?loc-01)) (turnDomain))
	)
	(:action trans-2
		:parameters (?loc-00 - location ?loc-01 - location)
		:precondition (and (or (and (q3 ?loc-00 ?loc-01) (vehicleat ?loc-01)) (q4 ?loc-00 ?loc-01)) (not (turnDomain)))
		:effect (and (q4 ?loc-00 ?loc-01) (not (q1 ?loc-00 ?loc-01)) (not (q2 ?loc-00 ?loc-01)) (not (q3 ?loc-00 ?loc-01)) (turnDomain))
	)
)