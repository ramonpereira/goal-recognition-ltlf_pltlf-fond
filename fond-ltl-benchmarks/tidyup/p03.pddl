(define (problem tidyupinstmdp03)
    (:domain tidyup)
    (:objects
      kitchentable - table
      desk1 - table
      kitchen - room
      corridor - room
      office1 - room
      initlocation - location
      kdoorl1 - location
      kdoorl2 - location
      odoor1l1 - location
      odoor1l2 - location
      ktablel - location
      desk1l - location
      cup1 - movableobject
      cup2 - movableobject
      book1 - movableobject
      kitchendoor - door
      odoor1 - door
      leftarm - arm
      rightarm - arm
      sponge - movableobject
    )
    (:init
      (on cup1 desk1)
      (on cup2 desk1)
      (on book1 kitchentable)
      (attachedtobasesponge)
      (atbase initlocation)
      (handfree leftarm)
      (handfree rightarm)
      (armatside leftarm)
      (armatside rightarm)
      (belongstodoor kdoorl1 kitchendoor)
      (belongstodoor kdoorl2 kitchendoor)
      (belongstodoor odoor1l1 odoor1)
      (belongstodoor odoor1l2 odoor1)
      (belongstotable ktablel kitchentable)
      (belongstotable desk1l desk1)
      (locationinroom initlocation kitchen)
      (locationinroom ktablel kitchen)
      (locationinroom desk1l office1)
      (locationinroom kdoorl1 kitchen)
      (locationinroom kdoorl2 corridor)
      (locationinroom odoor1l1 office1)
      (locationinroom odoor1l2 corridor)
    )
    ;(:goal (and (atbase desk1l) (wiped kitchentable) (on cup1 kitchentable) (on cup2 kitchentable) (handfree rightarm) (handfree leftarm)))
    ;(:goal (and (atbase desk1l) (wiped desk1) (on book1 desk1) (on cup2 kitchentable) (handfree rightarm) (handfree leftarm)))
    ;(:goal (and (atbase desk1l) (wiped desk1) (on cup1 kitchentable) (on book1 desk1) (handfree rightarm) (handfree leftarm)))
    ;(:goal (and (atbase desk1l) (wiped desk1) (on cup1 kitchentable) (on cup2 kitchentable) (on book1 desk1) (handfree rightarm) (handfree leftarm)))
    (:goal (goal_state))
)