(define (problem zeno_6_2_2_3846)
  (:domain zenotravel)
  (:objects c0 c1 c2 c3 c4 c5 - city p0 p1 - person a0 a1 - aircraft f0 f1 f2 f3 f4 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3) (next f3 f4)
         (atperson p0 c3) (notboarding p0) (notdebarking p0)
         (atperson p1 c4) (notboarding p1) (notdebarking p1)
         (ataircraft a0 c1) (fuellevel a0 f1) (notrefueling a0)
         (ataircraft a1 c0) (fuellevel a1 f4) (notrefueling a1)
  )
  (:goal (and (atperson p0 c3) (atperson p1 c4)))
)
