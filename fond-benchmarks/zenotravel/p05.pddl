(define (problem zeno_10_2_2_24056)
  (:domain zenotravel)
  (:objects c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 - city p0 p1 - person a0 a1 - aircraft f0 f1 f2 f3 f4 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3) (next f3 f4)
         (atperson p0 c2) (notboarding p0) (notdebarking p0)
         (atperson p1 c0) (notboarding p1) (notdebarking p1)
         (ataircraft a0 c5) (fuellevel a0 f0) (notrefueling a0)
         (ataircraft a1 c8) (fuellevel a1 f3) (notrefueling a1)
  )
  (:goal (and (atperson p0 c6) (atperson p1 c6)))
)
