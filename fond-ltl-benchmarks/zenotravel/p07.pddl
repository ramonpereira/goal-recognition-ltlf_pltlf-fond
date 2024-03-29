(define (problem zeno_12_5_3_24564)
  (:domain zenotravel)
  (:objects c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 - city p0 p1 p2 p3 p4 - person a0 a1 a2 - aircraft f0 f1 f2 f3 f4 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3) (next f3 f4)
         (atperson p0 c5) (notboarding p0) (notdebarking p0)
         (atperson p1 c4) (notboarding p1) (notdebarking p1)
         (atperson p2 c6) (notboarding p2) (notdebarking p2)
         (atperson p3 c9) (notboarding p3) (notdebarking p3)
         (atperson p4 c9) (notboarding p4) (notdebarking p4)
         (ataircraft a0 c10) (fuellevel a0 f1) (notrefueling a0)
         (ataircraft a1 c7) (fuellevel a1 f0) (notrefueling a1)
         (ataircraft a2 c4) (fuellevel a2 f2) (notrefueling a2)
  )
  (:goal (and (atperson p0 c3) (atperson p1 c9) (atperson p2 c4) (atperson p3 c2) (atperson p4 c6)))
)
