(define (problem pb2)
   (:domain logistics)
   (:objects package3 package2 package1 - obj
             city4 city3 city2 city1 - obj
             truck3 truck2 truck1 plane2 plane1 - obj
             city4u1 city3u1 city3u2 city2u1 city2u2 city2u3 city1u1 city1u2 - obj)
   (:init 
          (obj package3)
          (obj package2)
          (obj package1)
          
          (city city4)
          (city city3)
          (city city2)
          (city city1)
          
          (truck truck3)
          (truck truck2)
          (truck truck1)
          
          (airplane plane2)
          (airplane plane1)
          (needfuel plane2)
          
          (location city3u1)
          (location city3u2)
          (airport city3u2)
          
          (location city2u1)
          (location city2u2)
          (location city2u3)
          (airport city2u3)
          
          (location city1u1)
          (location city1u2)
          (airport city1u2)

          (location city4u1)
          (airport city4u1)

          (sparetirein city1u1)
          (sparetirein city2u1)
          (sparetirein city3u1)
          
          (incity city4u1 city4)

          (incity city3u2 city3)
          (incity city3u1 city3)
          
          (incity city2u3 city2)
          (incity city2u2 city2)
          (incity city2u1 city2)
          
          (incity city1u2 city1)
          (incity city1u1 city1)
          
          (at plane1 city4u1)
          (at plane2 city3u2)
          
          (at truck3 city3u1)
          (at truck2 city2u1)
          (at truck1 city1u1)

          (at package3 city1u1)
          (at package2 city2u1)
          (at package1 city3u1))
   
   (:goal (and (at package3 city3u2) (at package1 city2u1) (at package2 city3u2)))
   ;(:goal (and (at package2 city1u2) (at package3 city4u1) (at package1 city2u1)))
   ;(:goal (and (at package2 city1u2) (at package1 city3u2) (at package3 city4u1)))
   ;(:goal (and (at package3 city3u2) (at package1 city3u2) (at package2 city1u2)))
)