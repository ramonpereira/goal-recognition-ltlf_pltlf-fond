
(define (problem triangle-tire-2)
  (:domain triangle-tire)
  (:objects l11 l12 l13 l14 l15 l21 l22 l23 l24 l25 l31 l32 l33 l34 l35 l41 l42 l43 l44 l45 l51 l52 l53 l54 l55 - location)
  (:init (vehicleat l11)(road l11 l12)(road l12 l13)(road l13 l14)(road l14 l15)(road l11 l21)(road l12 l22)(road l13 l23)(road l14 l24)(road l21 l12)(road l22 l13)(road l23 l14)(road l24 l15)(sparein l21)(sparein l22)(sparein l23)(sparein l24)(road l31 l32)(road l32 l33)(road l21 l31)(road l23 l33)(road l31 l22)(road l33 l24)(sparein l31)(sparein l33)(road l31 l41)(road l32 l42)(road l41 l32)(road l42 l33)(sparein l41)(sparein l42)(road l41 l51)(road l51 l42)(sparein l51)(sparein l51)(notflattire))
  (:goal (vehicleat l15)))

