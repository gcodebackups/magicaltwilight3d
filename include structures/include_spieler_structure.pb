; -----------------------------------------------------------------------------------------------------------------
; --- Konstants  --------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------

   Enumeration ; sprungarten
      #spi_jump_not        ; spring nicht
      #spi_jump_normal     ; springt einfach
      #spi_jump_flugrolle  ; springt doppelt --> also in flugrolle
   EndEnumeration 
   
   Enumeration ; spieler EXIST
      #spi_exist_not
      #spi_exist_normal
      #spi_exist_ghost  ; also nur rumfliegen und zuschauen, nichts tun k�nnen.. ohne K�rper
   EndEnumeration
    
      ; die Drehrichrungen des Spielers
    #spi_action_rotate_Left      = 1  ; auf -90 grad drehen
    #spi_action_rotate_Right     = 2  ; auf 90 grad drehen 
    #spi_action_rotate_Forward   = 4  ; auf 0 grad drehen
    #spi_action_rotate_Back      = 8  ; auf 180 grad drehen
    #spi_action_move             = 16 ; in die aktuelle drehrichtung bewegen
   
   
    #spi_standard_leben         = 100
    #spi_standard_maxleben      = 100
    #spi_standard_mana          = 50
    #spi_standard_maxmana       = 50
    #spi_standard_schild        = 2
    #spi_standard_angriff       = 5
    #spi_standard_name          = "Tom"
    #spi_standard_team          = #team_wesen_bundnis_mensch
    #spi_standard_speed         = #anz_Walkspeed                 ; der anz_walkspeed..
    #spi_standard_animationlist = "stehen,1,155|sword,445,491|bowload,0,0|bowshoot,0,0|magic,0,0|springenstarten,260,167|springenlanden,267,288|flugrolleload,260,167|flugrolle_land,267,288|laufen,162,183|gehen,162,183|benutzen,0,0|reden,0,0|die_back,712,733|die_front,760,788|trank,0,0|"
   
; -----------------------------------------------------------------------------------------------------------------
; --- Structures --------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------

   Structure spi_Camera
     motionspeed .f  ; movement speed of the main figure
     pointer     .i  ; pointer zur Irr camera
     anglevert   .f  ; winkel, wie weit �bre der cam geflogen wird.
     targetnode  .i  ; Node des Spielers (krieger etc)
     relative_rotation.f ; zus�tzliche rotation um y (wenn er nach rechts/links l�uft)
     Action_flags.i ; konstanten #spi_rotate_left etc. damit man wei� in welche Richtungen er l�uft.
     distance    .f  ; entferneung cam-spieler
     IsFPS       .i  ; wenn 1 dann FPS camera, dann muss die spielfigur ausgeblendet werden.. , ansonsten 3rd person cam mit spielerfigur :)
   EndStructure
   
   Structure spi_spieler
     Anzahl_Sacke.i ; Anzahl der freigeschalteten S�cke (1,2 oder 3)
     InventarID  .i ; name, leben,team, Waffe etc ist ja alles in WESEN gekl�rt.
     WesenID     .i ; link zum WESEN, dass die komplette 3D sachen durchf�hrt (scarascara hmpf.... )
     exist.i                 ; ob er noch lebt, oder nur Zuschauer ist.
   EndStructure 
   
   Structure spi_inventar
      itemID.i [401] ; die Items selbst. also von 0 bis 400!! das 401-te gibt es nicht.
      anzahl.i       ; anzahl der current inventar-items.
   EndStructure 
   
   
; -----------------------------------------------------------------------------------------------------------------
; --- Globals    --------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------

   Global spi_camera.spi_Camera
   Global NewList spi_spieler.spi_spieler()
   Global NewList spi_inventar.spi_inventar()
    
; jaPBe Version=3.9.12.818
; Build=0
; FirstLine=27
; CursorPosition=43
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF