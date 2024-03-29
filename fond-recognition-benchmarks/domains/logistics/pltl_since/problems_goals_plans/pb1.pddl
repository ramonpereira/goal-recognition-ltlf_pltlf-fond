(define (problem pb1)
   (:domain logistics)
   (:objects package3 - obj
             city3 city2 - obj
             truck3 truck2 - obj
             city2u1 city2u3 city3u2 city2u2 - obj)
   (:init 
          (obj package3)
          
          (city city3)
          (city city2)
          
          (truck truck3)
          (truck truck2)

      	  (hasspare truck3)
          (hasspare truck2)
          
          (location city2u1)
          (location city3u2)
          (location city2u2)
          (location city2u3)

          (sparetirein city2u1)
          (sparetirein city2u2)
          (sparetirein city2u3)
          
          (incity city3u2 city3)
          (incity city2u2 city2)
          (incity city2u1 city2)
          (incity city2u3 city2)
          
          (at truck3 city2u1)
          (at truck2 city2u1)

          (at package3 city2u1))
   
   (:goal (goal_state))
)