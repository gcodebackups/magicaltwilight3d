#max_knoten = 255  ; x knoten pro level maximal.

Enumeration        ; die listen.
   #liste_None
   #liste_Open
   #liste_Gesch
EndEnumeration 

Enumeration      ; status des algorythmus
   #status_laufend
   #status_gefunden
   #status_delay
   #status_unerreichbar
EndEnumeration 

Structure knoten
   name.s                   ; editor-name des knotens ( zum besseren basteln..)
   anzahl_knoten.b          ; wie viele knoten sind mit unserm verkn�pft..
   remoteknoten.w[10]       ; IDs der verkn�pften knoten
   Gwert.f					    ; Geh wert
   Fwert.f				     	 ; g+h wert
   Hwert.f				       ; Distance-knoten-ziel
   parent.l
   liste.b                  ; gibt seine aktuelle liste an (rechenzeit ersparnis)
   x.f
   y.f
   z.f
EndStructure 


Global Dim     knoten.knoten(#max_knoten)
Global NewList geschlist.i  ()
Global NewList openlist.i   ()
Global NewList aufraumlist.i()

   Procedure.f dist (x.f,y.f,z.f,x1.f,y1.f,z1.f) ; abstand von 3d objekten
      ProcedureReturn Sqr( (x1-x)*(x1-x) + (y1-y)*(y1-y) + (z1-z)*(z1-z))
   EndProcedure 
   
Procedure inserttogeschlist ( id.i , Fwert.f = 0)
   
   knoten         ( id )\liste                  = #liste_Gesch 
   AddElement     ( geschlist())                ; Einf�gen des neuen Objektes.
   geschlist      ( ) = id                      ; �bergabe der ID zur Liste..
   
EndProcedure 

Procedure inserttoopenlist( id.i , Fwert.f = 0)
   
   If Not ListSize( openlist()) = 0
      ; wenn schon ein Element da: dann neues in F-wert inserten.
      ResetList ( openlist())
      
      While NextElement(openlist())          
         If knoten        ( openlist())\Fwert < Fwert  ; sobald der Fwert des einzuf�genden teils kleiner ist, als der der (sortiertn) liste, 
            InsertElement ( openlist())                ; Einf�gen des neuen Objektes.
               openlist   () = id                      ; �bergabe der ID zur Liste..
         EndIf 
      Wend 
   
   Else 
      
      ; wenn noch kein andres Element vorhanden        : als erstes Element erstellen.
            AddElement ( openlist())                   ; Einf�gen des neuen Objektes.
            openlist   () = id                         ; �bergabe der ID zur Liste.. 
      
   EndIf 
   
EndProcedure 

Procedure addclearknoten ( *knotenID.i ) 
    Protected *aufraumlist.i
    
      *aufraumlist = AddElement ( aufraumlist())
      *aufraumlist = *knotenID 
      
EndProcedure 

Procedure calcneighbours( id  )
   ; �berpr�ft alle verbundenen Knoten unseres ID-knotens, und berechnet g-h-f-werte.
   
   For x = 1 To knoten(id)\anzahl_knoten 
      
      aktiv = knoten(id)\remoteknoten[x]
      
      If knoten  (aktiv)\liste   = #liste_None                   ; in open list hinzuf�gen
         
         knoten  (aktiv)\liste   = #liste_Open 
         knoten  (aktiv)\Gwert   = dist( knoten(id   )\x , knoten(id   )\y , knoten(id   )\z , knoten(aktiv )\x , knoten(aktiv )\y , knoten(aktiv )\z) + knoten(id)\Gwert
         knoten  (aktiv)\Hwert   = dist( knoten(aktiv)\x , knoten(aktiv)\y , knoten(aktiv)\z , knoten(ZielID)\x , knoten(ZielID)\y , knoten(ZielID)\z)
         knoten  (aktiv)\Fwert   = knoten(aktiv)\Gwert   + knoten(aktiv)\Hwert ; 
         knoten  (aktiv)\parent  = @geschlist()                  ; viech kommt von Geschlist-
         addclearknoten          ( aktiv )                       ; alle ver�nderten knoten werden zum sp�teren aufr�umen gespeichert.
         inserttoopenlist        ( knoten(aktiv)\Fwert , aktiv)  ; einf�gen in die Open-Liste..
         
      ElseIf knoten(aktiv)\liste = #liste_Open                   ; auf umweg-gefahr pr�fen
         
         If knoten (aktiv)\Gwert > dist ( knoten(id   )\x , knoten(id   )\y , knoten(id   )\z , knoten(aktiv )\x , knoten(aktiv )\y , knoten(aktiv )\z) + knoten(id)\Gwert
            knoten (aktiv)\parent= id   ; wenn man �ber ID leichter zum Aktiv-knoten kommt, wird �ber ID gegangen (ID wird dann parent)
            knoten (aktiv)\Gwert   = dist( knoten(id   )\x , knoten(id   )\y , knoten(id   )\z , knoten(aktiv )\x , knoten(aktiv )\y , knoten(aktiv )\z) + knoten(id)\Gwert
         EndIf 
         
      EndIf 
   
   Next 
      
EndProcedure 

Procedure clearknoten()  ; l�scht alle knoten-ver�nderungen. (aufr�umen nach wegfindung)
   ClearList ( openlist() )
   ClearList ( geschlist()) 
   
EndProcedure 

; Procedure addclearknoten( id )
   ; 
   ; AddElement     ( aufraumlist())
      ; aufraumlist ( ) = id
      ; 
; EndProcedure 

Procedure getleastfwert () ; gibt listenelement mit am wenigsten Fwert aus.

   LastElement    (openlist()) ; da schon vorsortiert.. kleinster f-wert ist am ende.
   ProcedureReturn openlist()
   
EndProcedure 

Procedure Outputpath_getzielID() ; berechnet den niedrigsten F-wert der geschliste (wenn pfad berechnet)
   
   Protected Fwert.l  
   
   ResetList( geschlist())
      
      If NextElement       ( geschlist())
      
         Fwert             = geschlist()
      
         While NextElement ( geschlist())
            
            If Fwert > geschlist()
               Fwert = geschlist()
            EndIf 
        
         Wend 
      
      EndIf 
      
      ProcedureReturn Fwert 
EndProcedure 


Procedure.s outputpath(StartID.l , ZielID.l)  ; l�ufte den pfad r�ckw�rts von ziel zu start.
  
   ; zur�ckgehen vom ziel zum start, und so auch speichern; also Knoten, wo Mensch als n�chstes hin muss ist ganz rechts im string.
   Static pfad.s 
   
   
EndProcedure 

Procedure.s GetPath( StartID.l , ZielID.l , max_knoten.l )

   ; pfadfinding nach Waypoints (hier "Knoten")
   ; Gwert.f					; Geh wert ("beweg-wert)
   ; Fwert.f					; g+h wert
   ; Hwert.f					; Distance-knoten-ziel
   
   Static    newelement.l , gefunden.w , anzahl_knoten.l 
   Protected pfad.s
   
    inserttoopenlist  ( StartID )         ; kann evtl raus.. wohl eher symbolisch, diese zeile.
    inserttogeschlist ( StartID )         ; in geschlist, damits nichtmehr �berpr�ft wird.
    calcneighbours    ( StartID )         ; alle umliegenden Knoten berechnen.. in openliste tun
   
   ; ---
   ; schleife
   ; ---
   
   Repeat 
   
      newelement               = getleastfwert ()           ; Knoten, der am n�hsten am ziel ist.
      If Not ( newelement      = ZielID Or newelement = 0 ) ; wenns null ist, gibts kein element mehr, ziel unerreichbar.
         
         If max_knoten         = -1     Or max_knoten < anzahl_knoten
            
            anzahl_knoten      + 1
            inserttogeschlist  ( newelement )               ; vor nochmaligem berechnen sch�tzen.
            calcneighbours     ( newelement )               ; umliegende knoten �berpr�fen
           
         Else 
            gefunden           = #status_delay              ; bei n�chstem Durchlauf weiterrechnen..
         EndIf  
         
      ElseIf newelement        = 0   ; ziel unerreichbar..
         gefunden              = #status_unerreichbar
      Else                           ; ziel erreicht.
         gefunden              = #status_gefunden
         inserttogeschlist     ( newelement )
      EndIf  
      
   Until gefunden > #status_laufend 
   
   
   ; --------
   ; aufr�umen
   ; --------
   
   If gefunden      = #status_gefunden
      pfad.s        = outputpath( StartID , ZielID)
      Isresume      = 0
      newelement    = 0
      gefunden      = 0
      anzahl_knoten = 0
   ElseIf gefunden  = #status_unerreichbar  ; einfach den n�chstliegenden ausgeben (das Geschlistelement mit geringstem F-wert)
      pfad.s        = outputpath( StartID , ZielID)
      Isresume      = 0
      newelement    = 0
      gefunden      = 0
      anzahl_knoten = 0
   EndIf 
   
   clearknoten()           ; knotendaten wieder alle auf 0 setzen.
   ProcedureReturn pfad.s  ; pfad ausgeben  -- quest complete.
   
EndProcedure 

; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 131
; FirstLine = 74
; Folding = p-
; EnableUnicode
; EnableXP
; CurrentDirectory = C:\Programme MAX\PureBasic 4.3 BETA\ 
; jaPBe Version=3.8.8.716
; Build=0
; FirstLine=0
; CursorPosition=18
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF