(define (problem zeno-pb1)
  (:domain zenotravel)
  (:objects c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 - city p0 p1 p2 p3 p4 - person a0 a1 a2 - aircraft f0 f1 f2 f3 f4 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3) (next f3 f4)
         (atperson p0 c0) (notboarding p0) (notdebarking p0)
         (atperson p1 c8) (notboarding p1) (notdebarking p1)
         (atperson p2 c9) (notboarding p2) (notdebarking p2)
         (atperson p3 c7) (notboarding p3) (notdebarking p3)
         (atperson p4 c12) (notboarding p4) (notdebarking p4)
         (ataircraft a0 c14) (fuellevel a0 f2) (notrefueling a0)
         (ataircraft a1 c1) (fuellevel a1 f3) (notrefueling a1)
         (ataircraft a2 c9) (fuellevel a2 f2) (notrefueling a2)
  )
  (:goal (and (goal_state)))
)
