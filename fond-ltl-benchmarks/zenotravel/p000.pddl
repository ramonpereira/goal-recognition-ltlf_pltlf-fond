(define (problem zeno_3)
  (:domain zenotravel)
  (:objects c1 c2 c3 - city p0 p1 - person a0 a1 - aircraft f0 f1 f2 f3 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3)
         (atperson p0 c2) (notboarding p0) (notdebarking p0)
         (atperson p1 c3) (notboarding p1) (notdebarking p1)
         (ataircraft a0 c2) (fuellevel a0 f1) (notrefueling a0)
         (ataircraft a1 c1) (fuellevel a1 f3) (notrefueling a1)
  )
  (:goal (and (atperson p0 c2) (atperson p1 c3)))
)