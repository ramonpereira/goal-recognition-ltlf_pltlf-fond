(define (problem tidyup_inst_mdp__07)
    (:domain tidyup_v2)
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
      k_door_l2 - location
      o_door1_l1 - location
      o_door1_l2 - location
      o_door2_l1 - location
      o_door2_l2 - location
      o_door3_l1 - location
      o_door3_l2 - location
      o_door4_l1 - location
      o_door4_l2 - location
      o_door5_l1 - location
      o_door5_l2 - location
      k_table_l - location
      desk1_l - location
      desk2_l - location
      desk3_l - location
      cup1 - movableobject
      kitchen_door - door
      o_door1 - door
      o_door2 - door
      o_door3 - door
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
      (belongstodoor o_door2_l1 o_door2)
      (belongstodoor o_door2_l2 o_door2)
      (belongstodoor o_door3_l1 o_door3)
      (belongstodoor o_door3_l2 o_door3)
      (belongstotable k_table_l kitchentable)
      (belongstotable desk1_l desk1)
      (belongstotable desk2_l desk2)
      (belongstotable desk3_l desk3)
      (locationinroom initlocation kitchen)
      (locationinroom k_table_l kitchen)
      (locationinroom desk1_l office1)
      (locationinroom desk2_l office2)
      (locationinroom desk3_l office3)
      (locationinroom kdoorl1 kitchen)
      (locationinroom k_door_l2 corridor)
      (locationinroom o_door1_l1 office1)
      (locationinroom o_door1_l2 corridor)
      (locationinroom o_door2_l1 office2)
      (locationinroom o_door2_l2 corridor)
      (locationinroom o_door3_l1 office3)
      (locationinroom o_door3_l2 office2)
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
      (armatside rightarm)
      (armatside leftarm)
      (handfree rightarm)
      (handfree leftarm)
    ))
)