(define (problem triangle-tire-3)
	(:domain triangle-tire)
	(:objects l11 l12 l13 l14 l15 l16 l17 l21 l22 l23 l24 l25 l26 l27 l31 l32 l33 l34 l35 l36 l37 l41 l42 l43 l44 l45 l46 l47 l51 l52 l53 l54 l55 l56 l57 l61 l62 l63 l64 l65 l66 l67 l71 l72 l73 l74 l75 l76 l77 - location)
	(:init (notflattire) (q1 l17) (road l11 l12) (road l11 l21) (road l12 l13) (road l12 l22) (road l13 l14) (road l13 l23) (road l14 l15) (road l14 l24) (road l15 l16) (road l15 l25) (road l16 l17) (road l16 l26) (road l21 l12) (road l21 l31) (road l22 l13) (road l23 l14) (road l23 l33) (road l24 l15) (road l25 l16) (road l25 l35) (road l26 l17) (road l31 l22) (road l31 l32) (road l31 l41) (road l32 l33) (road l32 l42) (road l33 l24) (road l33 l34) (road l33 l43) (road l34 l35) (road l34 l44) (road l35 l26) (road l41 l32) (road l41 l51) (road l42 l33) (road l43 l34) (road l43 l53) (road l44 l35) (road l51 l42) (road l51 l52) (road l51 l61) (road l52 l53) (road l52 l62) (road l53 l44) (road l61 l52) (road l61 l71) (road l62 l53) (road l71 l62) (sparein l21) (sparein l22) (sparein l23) (sparein l24) (sparein l25) (sparein l26) (sparein l31) (sparein l35) (sparein l41) (sparein l42) (sparein l43) (sparein l44) (sparein l51) (sparein l53) (sparein l61) (sparein l62) (sparein l71) (turnDomain) (vehicleat l11))
(:goal (and (q3 l17) (turnDomain)))
)