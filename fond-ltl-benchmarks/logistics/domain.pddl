(define (domain logistics-strips)
  (:requirements :strips) 
  (:predicates  
      (OBJ ?obj)
      (TRUCK ?truck)
      (LOCATION ?loc)
      (AIRPLANE ?airplane)
      (CITY ?city)    
      (AIRPORT ?airport)
      (needfuel ?airplane)
      (flattire ?truck)
      (at ?obj ?loc)
      (in ?obj1 ?obj2)
      (in-city ?obj ?city)
      (spare-tire-in ?loc)
      (hasspare ?truck)
  )

(:action LOAD-TRUCK
  :parameters
   (?obj
    ?truck
    ?loc)
  :precondition
   (and (OBJ ?obj) (TRUCK ?truck) (LOCATION ?loc)
   (at ?truck ?loc) (at ?obj ?loc))
  :effect
   (and (not (at ?obj ?loc)) (in ?obj ?truck)))

(:action LOAD-AIRPLANE
  :parameters
   (?obj
    ?airplane
    ?loc)
  :precondition
   (and (OBJ ?obj) (AIRPLANE ?airplane) (LOCATION ?loc)
   (at ?obj ?loc) (at ?airplane ?loc))
  :effect
   (and (not (at ?obj ?loc)) (in ?obj ?airplane)))

(:action UNLOAD-TRUCK
  :parameters
   (?obj
    ?truck
    ?loc)
  :precondition
   (and (OBJ ?obj) (TRUCK ?truck) (LOCATION ?loc)
        (at ?truck ?loc) (in ?obj ?truck))
  :effect
   (and (not (in ?obj ?truck)) (at ?obj ?loc)))

(:action UNLOAD-AIRPLANE
  :parameters
   (?obj
    ?airplane
    ?loc)
  :precondition
   (and (OBJ ?obj) (AIRPLANE ?airplane) (LOCATION ?loc)
        (in ?obj ?airplane) (at ?airplane ?loc))
  :effect
   (and (not (in ?obj ?airplane)) (at ?obj ?loc)))

(:action DRIVE-TRUCK
  :parameters
   (?truck
    ?loc-from
    ?loc-to
    ?city)
  :precondition
   (and (TRUCK ?truck) (LOCATION ?loc-from) (LOCATION ?loc-to) (CITY ?city)
   (at ?truck ?loc-from)
   (not (flattire ?truck))
   (in-city ?loc-from ?city)
   (in-city ?loc-to ?city))
  :effect
  (oneof
   (and (flattire ?truck))
   (and (not (at ?truck ?loc-from)) (at ?truck ?loc-to)))
  )

(:action CHANGE-TIRE-TRUCK
  :parameters
   (?truck)
  :precondition (and (TRUCK ?truck) (flattire ?truck) (hasspare ?truck))
  :effect (and (not (flattire ?truck)))
)

(:action LOAD-TIRE-TRUCK
    :parameters (?truck ?loc)
    :precondition (and (TRUCK ?truck) (LOCATION ?loc) (at ?truck ?loc) (spare-tire-in ?loc))
    :effect (and (hasspare ?truck) (not (spare-tire-in ?loc)))
)

(:action FLY-AIRPLANE
  :parameters
   (?airplane
    ?loc-from
    ?loc-to)
  :precondition
   (and (AIRPLANE ?airplane) (AIRPORT ?loc-from) (AIRPORT ?loc-to)
  (at ?airplane ?loc-from) (not (needfuel ?airplane)))
  :effect
  (oneof
   (and (needfuel ?airplane))
   (and (not (at ?airplane ?loc-from)) (at ?airplane ?loc-to))
  )
)

(:action REFUEL-AIRPLANE
  :parameters
   (?airplane)
  :precondition (and (AIRPLANE ?airplane) (needfuel ?airplane))
  :effect (and (not (needfuel ?airplane)))
)
)