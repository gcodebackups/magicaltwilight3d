; -----------------------------------------------------------------------------------------------------------------
; --- Kampfsystem -------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------
; verwaltet fliegende Pfeile, Magie etc.
; Hat nichts mit Animationsverwaltung am hut!!! des macht include_wesen bzw. etc.
; -----------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------
; --- Procedures --------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------

   Procedure kam_SchiesPfeil ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen) ; schie�t einen Pfeil in richtung gegner ab. (kann danebenfliegen)
      ; vorher Reichweite der Wesenwaffe pr�fen *wesenid\Waffen_Anz_ID
      Protected *waffe.item_waffe , *item.ITEM , x.f , y.f , z.f , x1.f , y1.f , z1.f, vect.IRR_VECTOR , distance.f , rotx.f ,roty.f , rotz.f 

         *item                 = *WesenID          \ Waffe_Item_ID
         *waffe                = *item             \ WaffenID 
         wes_getposition       ( *WesenID          , @x    , @y      , @z  )
         wes_getposition       ( *WesenID\gegnerid , @x1   , @y1     , @z1 )
         IrrGetNodeRotation    ( wes_getNodeID( *WesenID ) , @rotx   , @roty , @rotz ) ; roty f�r Pfeilroty.
         distance              = math_distance3d( x , y , z , x1 , y1 , z1)
         vect                  \x = ( x1 - x ) / distance ; einheitsvector .. "normalize" berechnen
         vect                  \y = ( y1 - y ) / distance 
         vect                  \y = ( z1 - z ) / distance 
         
         
         *geschoss.geschoss = AddElement ( geschoss())
         
         If Not *geschoss  ; wenn RAM voll.
            ProcedureReturn 0
         EndIf 
         
            With *geschoss 
               \WesenID  = *WesenID 
               \bewegx   = vect\x * #meter ; 60 Meter pro Sekunde (pfeildurchschnittsgeschwindigkeit f�r 20g-pfeil) .. wir gehen von 60 FPS aus. 
               \bewegy   = vect\y * #meter 
               \bewegz   = vect\z * #meter 
               \schaden  = *waffe\angriff
               \anz_mesh = anz_addmesh ( #pfad_pfeil_mesh , x , y , z ,#pfad_pfeil_texture, #IRR_EMT_PARALLAX_MAP_SOLID , #pfad_pfeil_normalmap ,0,#anz_col_box , #anz_ColType_movable , 0,roty )
            EndWith 
            ;
            ; SOUND Nicht vergessen!!
   
   EndProcedure 
   
   Procedure kam_getGeschossNodeID (*geschossID.geschoss )
      If *geschossID 
         ProcedureReturn anz_getObject3DIrrNode( anz_getobject3dByAnzID( *geschossID ))
      EndIf 
   EndProcedure 
   
   Procedure kam_moveGeschoss ( *geschossID.geschoss ,bewegx.f , bewegy.f,bewegz.f) ; bewegt den Pfeil wieder weiter (fliegen)
      Protected x.f , y.f , z.f
      
      ; NODEID des Pfeiles
      *node  = kam_getGeschossNodeID( *geschossID ) ; pr�ft gleichzeitig, ob geschossID �berhaupt existiert.

      If *node                ; wenn vorhanden (evtl trotzdem aber nicht geladen=1):
         
         anz_getMeshPosition  ( anz_getobject3dByAnzID( *anz_mesh ) , @x , @y , @z )
         anz_setobjectPos     ( *node , x + bewegx , y + bewegy , z + bewegz )
         ProcedureReturn      *geschossID   ; successfull
      EndIf 
      
   EndProcedure 
   
   Procedure kam_SchiesZauber ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen , kam_Zauber_NR.i) 
      ; vorher Reichweite des Zaubers pr�fen *wesenid\Waffen_Anz_ID
      ; SOUND Nicht vergessen!!
      
   EndProcedure 
   
   ; focus wesen
   
   Procedure kam_nextfocuswesen()
      ProcedureReturn NextElement ( kam_focuswesen() )
   EndProcedure 

    Procedure kam_getFocuswesen()   ; gibt eine Liste von Wesen zur�ck, die im Visier des Spielers sind.
        ProcedureReturn kam_focuswesen()
    EndProcedure 
    
    Procedure kam_Focuswesen_Reset ()  ; �berpr�ft das Fokus-Item
        Protected x.f, y.f , z.f , SpielerRoty.f , spieler_wesen_dist.f , dist.f , WesenID.i , OldFocuswesen.i , divisioncorrectur.i
        Protected px.f , py.f , pz.f , pix.f , piy.f ,piz.f , wesenWinkel.f , Xdist.f , smallest_Fi.f = 50 ; smallest fi muss schon maximal sein (> 45 �)
        
        OldFocuswesen     = wes_Focuswesen 
        wes_Focuswesen    = 0
        
        wes_Examine_Reset(spi_GetPlayerNode( spi_getcurrentplayer())) ; alle umliegenden wesens �berpr�fen
        
            While wes_examine_Next()
                
                If Not anz_getobject3dIsGeladen( anz_getobject3dByAnzID( wes_Examine_get_AnzMeshID() ,#anz_art_mesh ) ) ; nat�rlich muss wesen geladen sein ;)
                    Continue 
                EndIf 
                ; --------------------- PAUSE ------------------------------
                ; -----------------------------------------------------------
                ; zu fertig zumweitermachen.. aber an und f�r sich isses hier nicht schwer.
                IrrGetNodeRotation         ( spi_GetPlayerNode( spi_getcurrentplayer() ) ,@x   , @SpielerRoty, @z ) ; spielernode rotation
                IrrGetNodeAbsolutePosition ( spi_GetPlayerNode( spi_getcurrentplayer() ) ,@px  , @py  , @pz )  ; spielernode position 
                IrrGetNodeAbsolutePosition ( wes_Examine_get_IrrNode( )                  ,@pix , @piy , @piz ) ; wesen position.. in dem fall absolute, weils um abstand wesen/spieler geht.
                SpielerRoty                = math_FixFi( - SpielerRoty ) ; spielerroty wird umgedreht ( also - spielerroty) weil spieler ja immer zu wesens schaun soll.
                
                If math_distance3d         ( px,py,pz,pix,piy,piz) < #meter*1.7 ; wenn der abstand von wesen zu spieler kleiner 1.7 m ist .. ;math_square_distance2d  ( 0 , pz , 0 , piz )     < #meter * 2 And math_square_distance2d( 0 , pz , 0 , piz) > - 1.3* #meter  ; wesen darf max. 2m �ber und 1m unterhalb von spieler sein.
                
                    ; Suchen aller im Winkel liegenden wesens        ( berechnen des wesen- und spieler drehwinkels)   
                    ; Xdist                  = math_square_distance2d ( px , 0 , pix , 0 ) ; nur der X - Abstand zwischen den beiden Nodes
                    ; Ydist                  = math_square_distance2d ( py , 0 , piy , 0 ) ; nur der y - Abstand zwischen den beiden Nodes
                    Xdist                  = math_distance3d        ( px , pz , 0 , pix , piz , 0 ) ; Xdist = b des cosinussatzes.
                    ; dist                   = math_distance3d        ( px , pz , 0 , pix , piz , 0 ) ; nur die 2D - distance. sonst rechung = falsch.
                    dist                   = #meter            ; beliebigen wert= l�nge von c 
                    Ydist                  = math_distance3d        ( pix , piz , 0 , dist + px , pz , 0) 
                    
                    If Round( 2* Xdist * dist,0) = 0 : divisioncorrectur = 1 : Else : divisioncorrectur = 0 : EndIf   ; kontrolle, damits nicht division durch null wird.
                    wesenWinkel             = math_RadToFi           ( ACos((-(Ydist*Ydist) + (Xdist*Xdist) + (dist*dist)) / ( divisioncorrectur+ 2*Xdist * dist ))) ; cos alpha = -a�+b�+c�/(2*b*c)
                    If wesenWinkel > 2147483648  Or wesenWinkel < -2147483648   ; wenn leere menge rauskommt, bei acos (was nur bei 180 und 360� der fall ist) 
                        If px > pix 
                        wesenWinkel = 180
                        Else 
                        wesenWinkel = 360
                        EndIf 
                    EndIf 
                    
                    If pz > piz 
                        wesenWinkel = math_FixFi( 360 - wesenWinkel  )
                    EndIf 
                    Debug "wesenwinkel: "  + StrF( wesenWinkel , 1)
                    Debug " spielerrot:"  + StrF( SpielerRoty ,1)
                    
                    ; Ob wesen In Sichtwinkel - Kontrolle
                    If math_IsFiInBereich( wesenWinkel , SpielerRoty-45 , SpielerRoty + 45); wesenWinkel         > SpielerRoty - 45  And wesenWinkel < SpielerRoty + 45 ; wenn der wesenwinkel im Bereich des Spielerwinkels liegt.
                        ; herausfinden des am n�chsten liegenden wesens (nur vom Winkel her!!)
                        If math_betrag     ( wesenWinkel- SpielerRoty ) < smallest_Fi 
                        Debug "got wesen"
                        smallest_Fi     = math_betrag     ( wesenWinkel- SpielerRoty )
                        smallest_wesenID = kam_getFocuswesen()  ; kpause.. ist nicht kontrlliert. kan auch falsch sein, hier ^^ ...
                        EndIf 
                
                    EndIf 
                
                EndIf 
                
            Wend 
        
        
        ; wesen als Selektiert setzen.
        
        wesen_Focuswesen = smallest_wesenID 
        
        ProcedureReturn wesen_Focuswesen
    
    EndProcedure 

   Procedure kam_UpdateKampfSystem()  ; pfeile etc. treffen lassen usw.
       Protected vector.IRR_VECTOR , endvector.IRR_VECTOR  ; beides mehrmals benutzt..
       Protected *node.i , *anz_object3d.anz_Object3d , *anz_mesh.anz_mesh ,*wes_wesen.wes_wesen , *wes_absender.wes_wesen
       
       
       ResetList ( geschoss())  
       
          While NextElement ( geschoss())
             
             With geschoss()
                
                kam_moveGeschoss( geschoss() , geschoss()\bewegx , geschoss()\bewegy , geschoss()\bewegz )
                
                ;{ pr�fen, ob und wenn, welches node getroffen wurde
                   
                   anz_getMeshPosition           ( geschoss()\anz_mesh ,@vector\x , @vector\y , @vector\z )
                   endvector\x = vector\x + geschoss()\bewegx 
                   endvector\y = vector\y + geschoss()\bewegy 
                   endvector\z = vector\z + geschoss()\bewegz 
                   
                   *node = IrrGetCollisionNodeFromRay            ( @vector , @endvector  )
                   
                   If *node ; Irgendetwas wurde getroffen. wenn= wesen: abziehen. ansonsten kurz stecken bleiben, nach zeit verschwinden.
                      
                      *anz_object3d         = anz_getobject3dByNodeID ( *node )
                      
                      If *anz_object3d      ; wenn object3d �berhaupt existiert..
                      
                           *anz_mesh        = *anz_object3d\id                      ; anz_mesh id auslesen.
                           
                           If *anz_object3d And *anz_object3d\art = #anz_art_mesh   ; wenns ein anz_obj3d ist ( standard)
                           
                              If *anz_mesh\WesenID > 0                          ; wenns ein lebewesen ist(war
                                 
                                 *wes_wesen            = *anz_mesh\WesenID 
                                 *wes_absender         = geschoss()\WesenID 
                                 
                                 If Not team_IsFreund  ( *wes_wesen\Team  ,  *wes_absender\Team ) ; wenn ein gegner getroffen wurde:
                                       
                                       wes_SetLeben    ( *wes_wesen , *wes_wesen\leben - geschoss()\schaden ) ; leben v. Wesen reduzieren.
                                       
                                 EndIf 
                                 
                              EndIf 
                           EndIf 
                              
                              anz_attachobject    ( geschoss()\anz_mesh , *node ) ; am Wesen, das getroffen wurde festmachen. PAUSE.. k.a., wie irr_setparten funktioniert... hoffe, er berechnet relative posiiton automatisch (andernfalls hauts den pfeil sonstwo hin..)
                              anz_delete_object3d ( anz_getobject3dByAnzID ( geschoss()\anz_mesh ) , 10000 ) ; l�scht nach 10 sekunden das teilens.
                              DeleteElement       ( geschoss())
                       EndIf 
                       
                   EndIf 
                   
                ;}
               
                ;{ Schaun, dass Pfeil nicht ewig fliegt --> l�schen nach 170 m. dist zu Absender
                   ; benutzt vector\x,y,z [= pfeilpos] von "pr�fen, ob +welches node getroffen" 
                   ; benutzt endvector\xyz
                   
                   *wes_absender          = geschoss()\WesenID 
                   anz_getMeshPosition    ( *wes_absender\anz_Mesh_ID , @endvector\x , @endvector\y , @endvector\z )
                   If math_distance3d     ( vector\x , vector\y , vector\z , endvector\x , endvector\y , endvector\z ) > #meter * 170 ; wenns mehr als 170 meter entfernt ist (pfeil)
                      anz_delete_object3d ( anz_getobject3dByAnzID ( geschoss()\anz_mesh ) , 10000 )                               ; l�scht nach 10 sekunden das teilens.
                      DeleteElement       ( geschoss())
                   EndIf 
                
                ;}
                
             EndWith 
             
          Wend  
       
   EndProcedure 

   Procedure kam_SchiesSchwert  ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen ) ; schl�gt mit dem Schwert einmal zu.(Animation wird hier niht geretelt!!
      ; SOUND Nicht vergessen!!
      ; zieht dem gegnerween einfach den schadenswert ab, ohne irgendwas zu werfen! (name nur wegen gleichheit mit Rest)
      *waffe_item.ITEM          = *WesenID\Waffe_Item_ID 
      *waffe.item_waffe         = *waffe_item\WaffenID
      wes_SetLeben              ( *ZielwesenID  , *ZielwesenID \leben - *waffe\angriff )
      Debug "neues leben: " + StrF( *ZielwesenID \leben - *waffe\angriff ,2)
   EndProcedure
   
; Wenn Gegner = in n�he    ; zum Ressourcensparen
; Figur1 bewegt sich �ber die Bewegpunkte zum n�chsten Punkt, der an Figur2 grenzt.
; Figur1 geht "Querfeldein" auf Figur2 zu
; 
; Wenn in Figur in Reichweite
; 
	; Wenn Figur1 = Fernkampf
		; Figur1 macht Bogenangriff:
		; => Animation der Figur+ Element Pfeil wird erstellt, mit Ziel: Figur2.position
		; Pfeil bekommt 3d Sound + isanimiert (dreht sich im Wind, etc) + schatten.
		; + kleiner partikeleffekt, Luft wird um ihn herum geteilt.
	; Wenn Figur1 = Zauber
		; Figur1 macht Angriffszauber (h�rtesten habenden)	
		; => Zauberanimation, wenn erledigt: Objekt Zauberkugel wird erstellt mit Ziel Figur2.position.
		; Zauberkugel bekommt 3d sound + particeleffekt
	; Wenn Figur1 = Nahkampf
		; Figur1 macht Nahkampf => Graphische Animation + sound d. Schwertes.
		; Gegner kann per zufall mit schild verteidigen
		; falls nicht:
; 
			; kritischer Treffer        = getcriticaltreffer          (Figur1\kritischertrefferchange)	   	; R�ckgabewert = entweder 3, oder, wenn fehlgeschlagen: 1.
			; ausweichechange     = getausweichechange  (Figur2\ausweichchange) 		 	; r�ckgabewert = 0, wenn successfull, oder 1, wenn fehlgeschlagen!
			; Figur2\lebensenergie = Figur2\lebensenergie - (Figur1\Angriff (der waffe) + Figur1\st�rke *2 + Figur1\Geschicklichkeit/3) /    (Figur2\Rustungsklasse / 5) * kritischerTreffer * ausweichechange
; 
		; endfalls
	; endwenn 
; 
; Wenn Pfeil collision mit Figur2 
 	; Figur2\lebensenergie = Figur2\lebensenergie - (Figur1\Angriff (des bogens) + Figur1\Geschicklichkeit*2 + Figur1\st�rke/3) /    (Figur2\schild)
	; deleteelement Pfeil
; 
; Wenn aber Zauber collision mit Figur2
	; Figur2\lebensenergie = Figur2\lebensenergie - Zauber\angriff * Figur1\zauberlevel (der art der Kugel) /    (Figur2\schild / 3)
	; Wenn Zauber = eis:
		; Figur2 = eingeeist f�r Zauber\wirkungsdauer (in Sekunden.f) => kann sich nicht bewegen; wird leicht durchsichtig + Eiskristalle
		; Figur2\Dauerschaden = Zauber\angriff * Figur1\zauberlevel( von eis) / 3
		; Ger�usch von belastet werdendem eis.
	; Wenn Zauber = feuer
		; Figur2 = verbrannt f�r Zauber\wirkungsdauer (in Sekunden.f) => bekommt rote Feuerpartikel und rotes Gl�hen.
		; Figur2\Dauerschaden = Zauber\angriff * Figur1\zauberlevel( von eis) / 3
		; Ger�usch von Brand.
	; Wenn Zauber = Stein
		; beim Aufprall fliegen Steine durch die Gegend => partikel.
		; Splittergr�usch
	; Wenn Zauber = Nekromantie
		; Schwarzer Rauch mit rosarotem schein steigt giftig auf.
		; Zischendes Ger�usch von geplatztem Gasrohr
		; Spezialwirkung der Zauber unterschiedlich..
	; Wenn Zauber = Blutmagie
		; Kurz wird Bildschirm rotget�nt, und alles verlangsamt sich f�r eine halbe Sekunde, da bei der Blutmagie der Spieler mit seinen Zaubern direkt verbunden ist.
		; ebenfalls ein Zischendes Ger�usch
	; endwenn
; endwenn
; 
; Wenn Figur2\lebensenergie > 0
 	; Figur2 macht gegenangriff
	; alles von forn.
; ansonsten:
	; Figur2 = tot.
; endwenn
 
; jaPBe Version=3.8.8.716
; FoldLines=000B002B002D0031003300400042004600A700CF00D100DC
; Build=0
; CompileThis=..\Wegfindung TESTER.pb
; FirstLine=67
; CursorPosition=135
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF