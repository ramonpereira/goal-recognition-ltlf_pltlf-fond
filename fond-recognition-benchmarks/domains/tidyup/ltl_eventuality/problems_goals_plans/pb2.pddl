(define (problem tidyupinstmdp04)
    (:domain tidyup)
    (:objects
      kitchentable - table
      desk1 - table
      desk2 - table
      kitchen - room
      corridor - room
      office1 - room
      office2 - room
      initlocation - location
      kdoorl1 - location
      kdoorl2 - location
      odoor1l1 - location
      odoor1l2 - location
      odoor2l1 - location
      odoor2l2 - location
      ktablel - location
      desk1l - location
      desk2l - location
      cup1 - movableobject
      laptop1 - movableobject
      kitchendoor - door
      odoor1 - door
      odoor2 - door
      leftarm - arm
      rightarm - arm
      sponge - movableobject
    )
    (:init
      (on cup1 kitchentable)
      (on laptop1 desk1)
      (attachedtobase_sponge)
      (atbase initlocation)
      (handfree leftarm)
      (handfree rightarm)
      (armatside leftarm)
      (armatside rightarm)
      (belongstodoor kdoorl1 kitchendoor)
      (belongstodoor kdoorl2 kitchendoor)
      (belongstodoor odoor1l1 odoor1)
      (belongstodoor odoor1l2 odoor1)
      (belongstodoor odoor2l1 odoor2)
      (belongstodoor odoor2l2 odoor2)
      (belongstotable ktablel kitchentable)
      (belongstotable desk1l desk1)
      (belongstotable desk2l desk2)
      (locationinroom initlocation kitchen)
      (locationinroom ktablel kitchen)
      (locationinroom desk1l office1)
      (locationinroom desk2l office2)
      (locationinroom kdoorl1 kitchen)
      (locationinroom kdoorl2 corridor)
      (locationinroom odoor1l1 office1)
      (locationinroom odoor1l2 corridor)
      (locationinroom odoor2l1 office2)
      (locationinroom odoor2l2 corridor)
    )
    (:goal (and (goal_state)))
)