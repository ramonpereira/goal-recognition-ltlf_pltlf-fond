(define (problem strips-log-x-1)
   (:domain logistics-strips)
   (:objects package3 package2 package1
             city3 city2 city1 
             truck3 truck2 truck1 plane2 plane1 
             city3-1 city2-1 city1-1 city3-2 city2-2 city1-2)
   (:init 
          (obj package3)
          (obj package2)
          (obj package1)
          
          (city city3)
          (city city2)
          (city city1)
          
          (truck truck3)
          (truck truck2)
          (truck truck1)
          (not (flattire truck1))
          (not (flattire truck2))
          (not (flattire truck3))

      	  ;(hasspare truck1)
      	  ;(hasspare truck2)
      	  (hasspare truck3)
          
          (airplane plane2)
          (airplane plane1)
          (not (needfuel plane1))
          (needfuel plane2)
          
          (location city3-1)
          (location city2-1)
          (location city1-1)
          (airport city3-2)
          (location city3-2)
          (airport city2-2)
          (location city2-2)
          (airport city1-2)
          (location city1-2)

          (spare-tire-in city1-1)
          (spare-tire-in city2-1)
          (spare-tire-in city2-2)
          (spare-tire-in city3-2)
          
          (in-city city3-2 city3)
          (in-city city3-1 city3)
          (in-city city2-2 city2)
          (in-city city2-1 city2)
          (in-city city1-2 city1)
          (in-city city1-1 city1)
          
          (at plane2 city3-2)
          (at truck3 city3-1)
          (at truck2 city2-1)
          (at truck1 city1-1)

          (at package3 city1-1)
          (at package2 city1-2)
          (at package1 city2-1))
   (:goal (and
               (at package3 city3-1)
               (at package2 city1-2)
               (at package1 city2-1))))