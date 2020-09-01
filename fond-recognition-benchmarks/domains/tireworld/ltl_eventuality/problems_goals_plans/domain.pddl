(define (domain tire)
  (:requirements :typing :strips :non-deterministic)
  
  (:types location)
  
  (:predicates 
    (vehicleat ?loc - location) 
    (sparein ?loc - location) 
    (road ?from - location ?to - location) 
    (notflattire) 
    (hasspare)
  )
  
  ;; Two (and) effects give us 1/3 probability of getting a flat -- the original probability was 2/5
  (:action move-car
    :parameters (?from - location ?to - location)
    :precondition (and (vehicleat ?from) (road ?from ?to) (notflattire))
    :effect (and (vehicleat ?to) (not (vehicleat ?from)) (oneof (and) (and) (not (notflattire))))
  )
  
  (:action loadtire
    :parameters (?loc - location)
    :precondition (and (vehicleat ?loc) (sparein ?loc))
    :effect (and (hasspare) (not (sparein ?loc)))
  )
  
  (:action changetire
    :parameters (?loc - location)
    :precondition (and (vehicleat ?loc) (hasspare))
    :effect (oneof (and) (and (not (hasspare)) (notflattire))) ;; The original domain has a 50% chance of a spare change failing
  )
  
)

