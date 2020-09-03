(define (domain logistics)
  (:requirements :typing :non-deterministic)
  (:types obj)
  (:predicates  
      (OBJ ?obj - obj)
      (TRUCK ?truck - obj)
      (LOCATION ?loc - obj)
      (AIRPLANE ?airplane - obj)
      (CITY ?city - obj)
      (AIRPORT ?airport - obj)
      (needfuel ?airplane - obj)
      (flattire ?truck - obj)
      (at ?obj ?loc - obj)
      (in ?obj1 ?obj2 - obj)
      (incity ?obj ?city - obj)
      (sparetirein ?loc - obj)
      (hasspare ?truck - obj)
  )

(:action LOAD-TRUCK
  :parameters
   (?obj
    ?truck
    ?loc - obj)
  :precondition
   (and (OBJ ?obj) (TRUCK ?truck) (LOCATION ?loc)
   (at ?truck ?loc) (at ?obj ?loc))
  :effect
   (and (not (at ?obj ?loc)) (in ?obj ?truck)))

(:action LOAD-AIRPLANE
  :parameters
   (?obj
    ?airplane
    ?loc - obj)
  :precondition
   (and (OBJ ?obj) (AIRPLANE ?airplane) (LOCATION ?loc)
   (at ?obj ?loc) (at ?airplane ?loc))
  :effect
   (and (not (at ?obj ?loc)) (in ?obj ?airplane)))

(:action UNLOAD-TRUCK
  :parameters
   (?obj
    ?truck
    ?loc - obj)
  :precondition
   (and (OBJ ?obj) (TRUCK ?truck) (LOCATION ?loc)
        (at ?truck ?loc) (in ?obj ?truck))
  :effect
   (and (not (in ?obj ?truck)) (at ?obj ?loc)))

(:action UNLOAD-AIRPLANE
  :parameters
   (?obj
    ?airplane
    ?loc - obj)
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
    ?city - obj)
  :precondition
   (and (TRUCK ?truck) (LOCATION ?loc-from) (LOCATION ?loc-to) (CITY ?city)
   (at ?truck ?loc-from)
   (not (flattire ?truck))
   (incity ?loc-from ?city)
   (incity ?loc-to ?city))
  :effect
  (oneof
   (and (flattire ?truck))
   (and (not (at ?truck ?loc-from)) (at ?truck ?loc-to)))
  )

(:action CHANGE-TIRE-TRUCK
  :parameters
   (?truck - obj)
  :precondition (and (TRUCK ?truck) (flattire ?truck) (hasspare ?truck))
  :effect (and (not (flattire ?truck)))
)

(:action LOAD-TIRE-TRUCK
    :parameters (?truck ?loc - obj)
    :precondition (and (TRUCK ?truck) (LOCATION ?loc) (at ?truck ?loc) (sparetirein ?loc))
    :effect (and (hasspare ?truck) (not (sparetirein ?loc)))
)

(:action FLY-AIRPLANE
  :parameters
   (?airplane
    ?loc-from
    ?loc-to - obj)
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
   (?airplane - obj)
  :precondition (and (AIRPLANE ?airplane) (needfuel ?airplane))
  :effect (and (not (needfuel ?airplane)))
)
)