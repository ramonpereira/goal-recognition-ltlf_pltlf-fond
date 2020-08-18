(define (problem zeno_13_5_3_27436)
  (:domain zenotravel)
  (:objects c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 - city p0 p1 p2 p3 p4 - person a0 a1 a2 - aircraft f0 f1 f2 f3 f4 - flevel)
  (:init (next f0 f1) (next f1 f2) (next f2 f3) (next f3 f4)
         (atperson p0 c11) (notboarding p0) (notdebarking p0)
         (atperson p1 c6) (notboarding p1) (notdebarking p1)
         (atperson p2 c12) (notboarding p2) (notdebarking p2)
         (atperson p3 c8) (notboarding p3) (notdebarking p3)
         (atperson p4 c2) (notboarding p4) (notdebarking p4)
         (ataircraft a0 c0) (fuellevel a0 f0) (notrefueling a0)
         (ataircraft a1 c6) (fuellevel a1 f3) (notrefueling a1)
         (ataircraft a2 c1) (fuellevel a2 f4) (notrefueling a2)
  )
  ;(:goal (and (atperson p0 c3) (atperson p1 c4) (atperson p2 c4) (atperson p3 c9) (atperson p4 c4)))
  ;(:goal (and (atperson p0 c3) (atperson p1 c2) (atperson p2 c8) (atperson p3 c7) (atperson p4 c0)))
  ;(:goal (and (atperson p0 c12) (atperson p1 c4) (atperson p2 c3) (atperson p3 c9) (atperson p4 c5)))
  ;(:goal (and (atperson p0 c12) (atperson p1 c2) (atperson p2 c3) (atperson p3 c1) (atperson p4 c8)))
  ;(:goal (and (atperson p0 c10) (atperson p1 c6) (atperson p2 c4) (atperson p3 c1) (atperson p4 c9)))
  ;(:goal (and (atperson p0 c10) (atperson p1 c3) (atperson p2 c7) (atperson p3 c0) (atperson p4 c1)))
  ;(:goal (and (atperson p0 c8) (atperson p1 c6) (atperson p2 c9) (atperson p3 c0) (atperson p4 c3)))
  (:goal (and (atperson p0 c8) (atperson p1 c3) (atperson p2 c4) (atperson p3 c9) (atperson p4 c6)))
)
