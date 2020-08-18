(define (problem tidyup_inst_mdp__02)
    (:domain tidyup_v2)
    (:objects
      kitchentable - table
      desk1 - table
      kitchen - room
      corridor - room
      office1 - room
      initlocation - location
      kdoorl1 - location
      k_door_l2 - location
      o_door1_l1 - location
      o_door1_l2 - location
      k_table_l - location
      desk1_l - location
      cup1 - movableobject
      kitchen_door - door
      o_door1 - door
    )
    (:init
      (on cup1 desk1)
      (attachedtobase sponge)
      (atbase initlocation)
      (handfree leftarm)
      (handfree rightarm)
      (armatside leftarm)
      (armatside rightarm)
      (belongstodoor kdoorl1 kitchen_door)
      (belongstodoor k_door_l2 kitchen_door)
      (belongstodoor o_door1_l1 o_door1)
      (belongstodoor o_door1_l2 o_door1)
      (belongstotable k_table_l kitchentable)
      (belongstotable desk1_l desk1)
      (locationinroom initlocation kitchen)
      (locationinroom k_table_l kitchen)
      (locationinroom desk1_l office1)
      (locationinroom kdoorl1 kitchen)
      (locationinroom k_door_l2 corridor)
      (locationinroom o_door1_l1 office1)
      (locationinroom o_door1_l2 corridor)
    )
    (:goal (and
      (wiped kitchentable)
      (tablestateknown kitchentable)
      (wiped desk1)
      (tablestateknown desk1)
      (attachedtobase sponge)
      (on cup1 kitchentable)
      (armatside rightarm)
      (armatside leftarm)
      (handfree rightarm)
      (handfree leftarm)
    ))
)