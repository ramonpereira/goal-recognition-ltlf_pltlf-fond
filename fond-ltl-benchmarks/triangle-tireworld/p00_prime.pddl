(define (problem triangle-tire-p01)
	(:domain triangle-tire)
	(:objects l11 - location l12 - location l13 - location l14 - location l15 - location l21 - location l22 - location l23 - location l24 - location l25 - location l31 - location l32 - location l33 - location l34 - location l35 - location l41 - location l42 - location l43 - location l44 - location l45 - location l51 - location l52 - location l53 - location l54 - location l55 - location)
	(:init (notflattire) (q1 l22 l33) (road l11 l12) (road l11 l21) (road l12 l13) (road l12 l22) (road l13 l14) (road l13 l23) (road l14 l15) (road l14 l24) (road l21 l12) (road l21 l22) (road l21 l31) (road l22 l13) (road l22 l23) (road l22 l32) (road l23 l14) (road l23 l24) (road l23 l33) (road l24 l15) (road l31 l22) (road l31 l32) (road l31 l41) (road l32 l23) (road l32 l33) (road l32 l42) (road l33 l24) (road l41 l32) (road l41 l51) (road l42 l33) (road l51 l42) (sparein l13) (sparein l14) (sparein l21) (sparein l22) (sparein l23) (sparein l24) (sparein l31) (sparein l33) (sparein l41) (sparein l42) (sparein l51) (turnDomain) (vehicleat l11))
(:goal (and (q4 l22 l33) (turnDomain)))
)