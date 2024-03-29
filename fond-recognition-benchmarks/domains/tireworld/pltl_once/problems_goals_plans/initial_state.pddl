(define (problem pb2)
  (:domain tireworld)
  (:objects n00 n01 n02 n10 n11 n12 n20 n21 n22 n30 n31 n32 n41 n51 - location)
  (:init 
         (vehicleat n00)
         
         (road n00 n01) (road n01 n00)
         (road n00 n10) (road n10 n00)
         (road n01 n11) (road n11 n01)
         (road n10 n11) (road n11 n10)
         (road n10 n20) (road n20 n10)
         (road n11 n21) (road n21 n11)
         (road n20 n21) (road n21 n20)
         (road n20 n30) (road n30 n20)
         (road n21 n31) (road n31 n21)
         (road n30 n31) (road n31 n30)
         (road n30 n01) (road n31 n41)
         (road n41 n51) (road n51 n11)
         
         (sparein n00) (sparein n01)
         (sparein n10) (sparein n11)
         (sparein n20) (sparein n21)
         (sparein n30) (sparein n31)
         (sparein n41) (sparein n51)
         (notflattire)
  )
  (:goal (goal_state))
)
