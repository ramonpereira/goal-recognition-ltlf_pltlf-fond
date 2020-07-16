(define (problem zeno_19_10_6_11709)
  (:domain zenotravel)
  (:objects c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 - city p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 - person a0 a1 a2 a3 a4 a5 - aircraft f0 f1 f2 f3 f4 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3) (next f3 f4)
         (atperson p0 c9) (notboarding p0) (notdebarking p0)
         (atperson p1 c18) (notboarding p1) (notdebarking p1)
         (atperson p2 c12) (notboarding p2) (notdebarking p2)
         (atperson p3 c16) (notboarding p3) (notdebarking p3)
         (atperson p4 c9) (notboarding p4) (notdebarking p4)
         (atperson p5 c0) (notboarding p5) (notdebarking p5)
         (atperson p6 c12) (notboarding p6) (notdebarking p6)
         (atperson p7 c15) (notboarding p7) (notdebarking p7)
         (atperson p8 c18) (notboarding p8) (notdebarking p8)
         (atperson p9 c12) (notboarding p9) (notdebarking p9)
         (ataircraft a0 c8) (fuellevel a0 f0) (notrefueling a0)
         (ataircraft a1 c12) (fuellevel a1 f4) (notrefueling a1)
         (ataircraft a2 c5) (fuellevel a2 f3) (notrefueling a2)
         (ataircraft a3 c17) (fuellevel a3 f4) (notrefueling a3)
         (ataircraft a4 c15) (fuellevel a4 f2) (notrefueling a4)
         (ataircraft a5 c3) (fuellevel a5 f2) (notrefueling a5)
  )
  (:goal (and (atperson p0 c15) (atperson p1 c13) (atperson p2 c11) (atperson p3 c14) (atperson p4 c5) (atperson p5 c9) (atperson p6 c6) (atperson p7 c5) (atperson p8 c10) (atperson p9 c14)))
)