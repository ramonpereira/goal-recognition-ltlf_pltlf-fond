(define (problem tidyupinstmdp10)
    (:domain tidyupv2)
    (:objects
      kitchentable - table
      desk1 - table
      desk2 - table
      desk3 - table
      kitchen - room
      corridor - room
      office1 - room
      office2 - room
      office3 - room
      initlocation - location
      kdoorl1 - location
      kdoorl2 - location
      odoor1l1 - location
      odoor1l2 - location
      odoor2l1 - location
      odoor2l2 - location
      odoor3l1 - location
      odoor3l2 - location
      odoor4l1 - location
      odoor4l2 - location
      odoor5l1 - location
      odoor5l2 - location
      ktablel - location
      desk1l - location
      desk2l - location
      desk3l - location
      cup1 - movableobject
      cup2 - movableobject
      cup3 - movableobject
      cup4 - movableobject
      kitchendoor - door
      odoor1 - door
      odoor2 - door
      odoor3 - door
    )
    (:init
      (on cup1 desk1)
      (on cup2 desk2)
      (on cup3 desk3)
      (on cup4 desk3)
      (attachedtobase sponge)
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
      (belongstodoor odoor3l1 odoor3)
      (belongstodoor odoor3l2 odoor3)
      (belongstotable ktablel kitchentable)
      (belongstotable desk1l desk1)
      (belongstotable desk2l desk2)
      (belongstotable desk3l desk3)
      (locationinroom initlocation kitchen)
      (locationinroom ktablel kitchen)
      (locationinroom desk1l office1)
      (locationinroom desk2l office2)
      (locationinroom desk3l office3)
      (locationinroom kdoorl1 kitchen)
      (locationinroom kdoorl2 corridor)
      (locationinroom odoor1l1 office1)
      (locationinroom odoor1l2 corridor)
      (locationinroom odoor2l1 office2)
      (locationinroom odoor2l2 corridor)
      (locationinroom odoor3l1 office3)
      (locationinroom odoor3l2 office2)
    )
    (:goal (and
      (wiped kitchentable)
      (tablestateknown kitchentable)
      (wiped desk1)
      (tablestateknown desk1)
      (wiped desk2)
      (tablestateknown desk2)
      (wiped desk3)
      (tablestateknown desk3)
      (attachedtobase sponge)
      (on cup1 kitchentable)
      (on cup2 kitchentable)
      (on cup3 kitchentable)
      (on cup4 kitchentable)
      (armatside rightarm)
      (armatside leftarm)
      (handfree rightarm)
      (handfree leftarm)
    ))
)