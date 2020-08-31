(define (domain tidyup)
    (:requirements :strips :typing :equality :non-deterministic)
    (:types room location table door movableobject arm)

    (:predicates 
        (tablestateknown ?t - table)
        (on ?o - movableobject ?t - table)
        (wiped ?s - table)
        (handfree ?a - arm)
        (grasped ?o - movableobject ?a - arm)
        (grasped_sponge ?a - arm)
        (attachedtobase_sponge)
        (attachedtobase ?o - movableobject)
        (dooropen ?d - door)
        (doorstateknown ?d - door)
        (armatside ?a - arm)
        (belongstodoor ?l - location ?d - door)
        (belongstotable ?l - location ?t - table)
        (locationinroom ?l - location ?r - room)
        (atbase ?l - location)
    ) 

    (:action pickup-object
     :parameters (?l - location ?o - movableobject ?t - table ?a - arm)
     :precondition 
        (and 
            (atbase ?l)
            (belongstotable ?l ?t)
            (on ?o ?t)
            (handfree ?a)
            (tablestateknown ?t)
            (armatside ?a)
        )
     :effect 
        (oneof
            (and 
                (not (on ?o ?t))
                (grasped ?o ?a)
                (not (handfree ?a))
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
            (and 
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
        )
    ) 
 
    (:action pickup-object-blind
     :parameters (?l - location ?o - movableobject ?t - table ?a - arm)
     :precondition 
        (and 
            (atbase ?l)
            (belongstotable ?l ?t)
            (on ?o ?t)
            (handfree ?a)
            (not (tablestateknown ?t))
            (armatside ?a)
        ) 
     :effect 
        (oneof
            (and 
                (not (on ?o ?t))
                (grasped ?o ?a)
                (not (handfree ?a))
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
            (and 
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
            (and 
                (not (on ?o ?t))
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
        )
    ) 
 
    (:action putdown-object
     :parameters (?l - location ?o - movableobject ?t - table ?a - arm)
     :precondition
        (and
            (atbase ?l)
            (belongstotable ?l ?t)
            (grasped ?o ?a)
            (tablestateknown ?t)
            (armatside ?a)
        )
     :effect
        (oneof
            (and
                (on ?o ?t)
                (not (grasped ?o ?a))
                (handfree ?a)
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
            (and
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
        )
    )  
 
    (:action putdown-object-blind
     :parameters (?l - location ?o - movableobject ?t - table ?a - arm)
     :precondition
        (and
            (atbase ?l)
            (belongstotable ?l ?t)
            (grasped ?o ?a)
            (not (tablestateknown ?t))
            (armatside ?a)
        )
     :effect
        (oneof
            (and
                (on ?o ?t)
                (not (grasped ?o ?a))
                (handfree ?a)
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
            (and
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
            (and
                (not (grasped ?o ?a))
                (handfree ?a)
                (not (armatside ?a))
                (not (tablestateknown ?t))
            )
        )
    ) 
 
    (:action wipe
     :parameters (?l - location ?t - table ?a - arm)
     :precondition
        (and
            (atbase ?l)
            (grasped_sponge ?a)
            (tablestateknown ?t)
            (armatside ?a)
            (belongstotable ?l ?t)
            (not (wiped ?t))
        )
     :effect
        (and 
            (not (armatside ?a))
            (wiped ?t)
        )
    )
 
    (:action detach-sponge
     :parameters (?a - arm)
     :precondition
        (and
            (handfree ?a)
            (attachedtobase_sponge)
            (armatside ?a)
        )
     :effect
        (and
            (grasped_sponge ?a)
            (not (attachedtobase_sponge))
            (not (armatside ?a))
            (not (handfree ?a))
        )
    )
 
    (:action attach-sponge
    :parameters (?a - arm)
    :precondition
        (and
            (grasped_sponge ?a)
            (armatside ?a)
        )
    :effect
        (and
            (not (grasped_sponge ?a))
            (attachedtobase_sponge)
            (not (armatside ?a))
            (handfree ?a)
        )
    )

    (:action sense-table-state
    :parameters (?l - location ?t - table)
    :precondition
        (and
            (atbase ?l)
            (belongstotable ?l ?t)
            (not (tablestateknown ?t))
        )
    :effect
        (and
            (tablestateknown ?t)
        )
    )

    (:action sense-table-state-untucked-right
    :parameters (?l - location ?t - table)
    :precondition
        (and
            (atbase ?l)
            (belongstotable ?l ?t)
            (not (tablestateknown ?t))
        )
    :effect
        (oneof
            (and
                (tablestateknown ?t)
            )
            (and)
        )
    )

    (:action sense-table-state-untucked-left
    :parameters (?l - location ?t - table)
    :precondition
        (and
            (atbase ?l)
            (belongstotable ?l ?t)
            (not (tablestateknown ?t))
        )
    :effect
        (oneof
            (and
                (tablestateknown ?t)
            )
            (and)
        )
    )    

    (:action sense-door-state
    :parameters (?l - location ?d - door)
    :precondition
        (and
            (atbase ?l)
            (belongstodoor ?l ?d)
            (not (doorstateknown ?d))
        )
    :effect
        (and
            (doorstateknown ?d)
        )
    )

    (:action sense-door-state-untucked-right
    :parameters (?l - location ?d - door)
    :precondition
        (and
            (atbase ?l)
            (belongstodoor ?l ?d)
            (not (doorstateknown ?d))
        )
    :effect
        (oneof
            (and
                (doorstateknown ?d)
            )
            (and)
        )
    )

    (:action sense-door-state-untucked-left
    :parameters (?l - location ?d - door)
    :precondition
        (and
            (atbase ?l)
            (belongstodoor ?l ?d)
            (not (doorstateknown ?d))
        )
    :effect
        (oneof
            (and
                (doorstateknown ?d)
            )
            (and)
        )
    )    

    (:action open-door
     :parameters (?l - location ?d - door ?a - arm)
     :precondition
        (and
            (atbase ?l)
            (belongstodoor ?l ?d)
            (doorstateknown ?d)
            (not (dooropen ?d))
            (handfree ?a)
        )
     :effect
        (and 
            (not (armatside ?a))
            (dooropen ?d)
            (not (doorstateknown ?d))
        )
    )
 
    (:action drive
     :parameters (?r - room ?s ?g - location)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (locationinroom ?s ?r)
            (locationinroom ?g ?r)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )
    
    (:action drive-untucked-right-arm
     :parameters (?r - room ?s ?g - location ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (locationinroom ?s ?r)
            (locationinroom ?g ?r)
            (not (armatside ?a))
            (handfree ?a)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )

    (:action drive-untucked-left-arm
     :parameters (?r - room ?s ?g - location ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (locationinroom ?s ?r)
            (locationinroom ?g ?r)
            (not (armatside ?a))
            (handfree ?a)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )

    (:action drive-untucked
     :parameters (?r - room ?s ?g - location ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (locationinroom ?s ?r)
            (locationinroom ?g ?r)
            (not (armatside ?a))
            (handfree ?a)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )
    
    (:action drive-untucked-carrying
     :parameters (?r - room ?s ?g - location ?o - movableobject ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (locationinroom ?s ?r)
            (locationinroom ?g ?r)
            (not (armatside ?a))
            (grasped ?o ?a)
        )
     :effect
        (oneof
            (and
                (handfree ?a)
                (not (grasped ?o ?a))         
            )
        )
    )
    
    (:action drive-through-door
     :parameters (?sr ?gr - room ?d - door ?s ?g - location)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (belongstodoor ?s ?d)
            (belongstodoor ?g ?d)
            (locationinroom ?s ?sr)
            (locationinroom ?g ?gr)
            (doorstateknown ?d)
            (dooropen ?d)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g) 
            )
            (and)
        )
    )
    
    (:action drive-through-door-untucked-right-arm
     :parameters (?sr ?gr - room ?d - door ?s ?g - location ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (belongstodoor ?s ?d)
            (belongstodoor ?g ?d)
            (locationinroom ?s ?sr)
            (locationinroom ?g ?gr)
            (doorstateknown ?d)
            (dooropen ?d)
            (not (armatside ?a))
            (handfree ?a)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )

    (:action drive-through-door-untucked-left-arm
     :parameters (?sr ?gr - room ?d - door ?s ?g - location ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (belongstodoor ?s ?d)
            (belongstodoor ?g ?d)
            (locationinroom ?s ?sr)
            (locationinroom ?g ?gr)
            (doorstateknown ?d)
            (dooropen ?d)
            (not (armatside ?a))
            (handfree ?a)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )

    (:action drive-through-door-untucked
     :parameters (?sr ?gr - room ?d - door ?s ?g - location ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (belongstodoor ?s ?d)
            (belongstodoor ?g ?d)
            (locationinroom ?s ?sr)
            (locationinroom ?g ?gr)
            (doorstateknown ?d)
            (dooropen ?d)
            (not (armatside ?a))
            (handfree ?a)
        )
     :effect
        (oneof
            (and
                (not (atbase ?s))
                (atbase ?g)
            )
            (and)
        )
    )
    
    (:action drive-through-door-untucked-carrying
     :parameters (?sr ?gr - room ?d - door ?s ?g - location ?o - movableobject ?a - arm)
     :precondition
        (and
            (not (= ?s ?g))
            (atbase ?s)
            (belongstodoor ?s ?d)
            (belongstodoor ?g ?d)
            (locationinroom ?s ?sr)
            (locationinroom ?g ?gr)
            (doorstateknown ?d)
            (dooropen ?d)
            (not (armatside ?a))
            (grasped ?o ?a)
        )
     :effect
        (and
            (handfree ?a)
            (not (grasped ?o ?a))
        )
    )
    
    (:action arm-to-side
    :parameters (?a - arm)
    :precondition
        (and
            (not (armatside ?a))
        )
    :effect
        (and
            (armatside ?a)
        )
    )
)