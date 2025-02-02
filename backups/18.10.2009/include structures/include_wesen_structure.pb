
; -----------------------------------------------------------------------------------------------------
; --- Constants ---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

Enumeration ; aktions  Zustande..
  #wes_action_stand
  #wes_action_move
  #wes_action_attack
  #wes_action_defend ; wesen dreht sich zu angreifer hin und greift ihn an, sobald er zuschl�gt ( passiert, wenn Wesen vs. wesen angreift)
  #wes_action_moveAttack
  #wes_action_die
  #wes_action_fliehen
  ; ab hier kommen die aktionen f�r h�here Wesen und Spieler:
  #wes_action_jump_start 
  #wes_action_jump_land
  #wes_action_jump_flugrolle_start
  #wes_action_jump_flugrolle_land
  #wes_action_talk             ; beim reden
  #wes_action_trank_trinken    ; tranktrinken.
  #wes_action_drop_item        ; item wegwerfen
EndEnumeration 

Enumeration ; actionlevels
  #wes_actionlevel_low         ; gehen, stehen, talken.. was halt jederzeit abgebrochen werden kann
  #wes_actionlevel_medium      ; attack, defend, trank, dropitem,use, was nur von high abgebrochen werden kann
  #wes_actionlevel_high        ; springen, landen, flugrolle etc. was nur von highest abgebrochen werden kann.
  #wes_actionlevel_highest     ; die
EndEnumeration 

Enumeration ; wesen ARten
  #wes_art_magie   ; magiebegabtes wesen
  #wes_art_schwert ; nahk�mpfer
  #wes_art_bogen   ; fernk�mpfen
  #wes_art_handler ; h�ndler.. meist neutral...
  #wes_art_tier    ; tier, keine waffen etc.
EndEnumeration

#wes_Standard_Sichtweite = #meter * 12.5 ; die Angriffssichtweite.. ab 8.5 m n�he greifen gegner an.

; -----------------------------------------------------------------------------------------------------
; --- Structures---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

   Structure wes_wesen
      Ladeinterval   .i   ; = Elapsedmilliseconds / 1000 ; zum �berpr�fen, wann leben,mana etc nachgeladen wird.
      Waffe_Item_ID  .i   ; ItemID der Waffe.
      wut            .i   ; entscheidet z.b., ob Wesen angreift, oder wegl�uft. etc.
      leben          .i
      maxleben       .i
      mana           .i
      art            .i    ; die Art des wesens. bogen, nahkampf, fernkampf etc.
      maxmana        .i    ; maxmana
      anz_Mesh_ID    .i    ; pointer zum Object3d.
      name           .s    ; Name des Wesens
      speed          .f    ; Geschwindigkeit in Einheiten/Frame mit der sich das Wesen bewegt ( einfach position + speed addieren.)
      Team           .i    ; B�ndniss des Wesens
      waypoint       .i    ; Pointer zu einem Waypoint an dem das Wesen 'eingeloggt' ist
      pfad           .s    ; Waypoint-pfad. z.b. "1|23432|4345335|25" einfach Reihe von WaypointIDs
      pfad_currentWaypoint .i ; NR des aktuellen wayopints. beginnt mit dem rechtesten pfadeintrag und wird langsam heruntergez�hlt
      action         .i    ; siehe #wes_action_..
      gegnerid       .i    ; wesenID des current_gegners.
      SpielerID      .i    ; wenn das wesen ein spieler ist -> spielerID > 0 (= ID of spieler)
      Action_Level   .i    ; wichtigkeit der aktuellen Aktion (z.b. Die = am wichtigesten)
   EndStructure
   
   Structure wes_examined_Node  ; zum �berpr�fen der umgebungs-items
      nodeID.i            ; Irrlicht-Node
      anz_Mesh_ID.i       ; anz_mesh_id
      Object3dID.i        
      distance.f          ; Abstand zum Spieler
   EndStructure 

; -----------------------------------------------------------------------------------------------------
; --- Globals   ---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

   Global NewList wes_wesen.wes_wesen                   ()
   Global NewList wes_Examined_node.wes_examined_Node   ()
 
; jaPBe Version=3.8.8.716
; Build=0
; FirstLine=0
; CursorPosition=0
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF