RSRC                    PackedScene            i�^��cT                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script 2   res://addons/sensetree/behavior_tree/node/tree.gd ��������   Script @   res://addons/sensetree/behavior_tree/node/composite/sequence.gd ��������   Script @   res://addons/sensetree/behavior_tree/node/composite/selector.gd ��������   Script P   res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_has_key.gd ��������   Script U   res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_assign_value.gd ��������   Script =   res://addons/sensetree/behavior_tree/node/decorator/delay.gd ��������   Script U   res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_modify_value.gd ��������   Script >   res://addons/sensetree/behavior_tree/node/decorator/invert.gd ��������   Script V   res://addons/sensetree/behavior_tree/node/leaf/blackboard/blackboard_compare_value.gd ��������   Script M   res://addons/sensetree/example/node/behavior/action/go_to_waypoint_action.gd ��������   Script P   res://addons/sensetree/example/node/behavior/action/change_visibility_action.gd ��������   Script =   res://addons/sensetree/behavior_tree/node/decorator/await.gd ��������   Script O   res://addons/sensetree/example/node/behavior/action/take_resource_action.gd.gd ��������   Script K   res://addons/sensetree/example/node/behavior/action/fulfill_need_action.gd ��������   Script H   res://addons/sensetree/example/node/behavior/action/roam_area_action.gd ��������   8   res://addons/sensetree/demo/resource/actor/villager.res �         PackedScene          	         names "   >      Villager SenseTree    script    frames_per_tick    Node 	   Villager    Needs    Initialize Needs    Initialize Hunger    Has Hunger Need    blackboard_key    Assign Hunger 
   key_value    Initialize Thirst    Has Thirst Need    Assign Thirst    Initialize Drowsiness    Has Drowsiness Need    Assign Drowsiness    Increase Needs    Postpone Hunger Increase    Increase Hunger    modification_value    Postpone Thirst Increase    Increase Thirst    Postpone Drowsiness Increase    Increase Drowsiness    Fulfill Needs    Fulfill Drowsiness    Not 
   Is Drowsy    comparison_value    comparison_operator 	   Go Sleep    Go Home 
   max_speed    Go 'Inside'    change_visibility    Await 7 Seconds    timer_duration    Reduce Drowsy    modification_operator    Go 'Outside'    Fulfill Thirst    Is Thirsty 	   Go Drink    Go To Water Source    Wait 5 Seconds    Reduce Thirst    Fulfill Hunger 
   Is Hungry    Go Eat    Go To Meal Storage    Postpone Take Meal 
   Take Meal    storage_targets 	   Has Meal    Await Fulfill Hunger    need_fulfillment_resource_key 	   need_key    need_decrement_value    Roam    roaming_radius    	   variants    $                                                    hunger_level                0       thirst_level       drowsiness_level                         4       6       3                         60             	        �B      
                       �@      80       @                                          meal       1             P                 pB     pC      node_count    0         nodes     
  ��������       ����                                  ����                          ����                          ����                          ����                          ����         	                    
   ����         	                             ����                          ����         	                       ����         	                             ����             
             ����         	   	       
             ����         	   	                          ����                          ����      
                    ����         	                             ����      
                    ����         	                             ����      
                    ����         	   	                          ����                          ����                          ����                          ����         	   	                                 ����                       !   ����         "                    #   ����         $                    %   ����         &                    '   ����         	   	         (                    )   ����                       *   ����                          ����                       +   ����         	                                ,   ����             !          -   ����             !          .   ����             #          /   ����         	            (                    0   ����             %             ����             &          1   ����         	                      %          2   ����             (          3   ����             (          4   ����      
   &          *          5   ����         6  @   	                (          7   ����         	          (          8   ����         &          -          0   ����         9      :      ;                     <   ����      !   "   "   =   #             conn_count              conns               node_paths              editable_instances              version             RSRC