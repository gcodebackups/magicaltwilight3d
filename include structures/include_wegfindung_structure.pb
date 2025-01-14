; ------------------------------------------------------------------------------------------------------------------------------
; -- constants
; ------------------------------------------------------------------------------------------------------------------------------

   #max_knoten = 255  
   
   Enumeration         ; die listen.
      #Weg_liste_None  ; keine liste  : standard
      #Weg_liste_Open  ; offene liste : waypoint muss noch �berpr�ft wernden
      #Weg_Liste_Gesch ; geschliste   : ist schon �berpr�ft.
   EndEnumeration 
   
   Enumeration      ; status des algorythmus
      #Weg_status_laufend
      #Weg_status_gefunden
      #Weg_status_delay
      #Weg_status_unerreichbar
   EndEnumeration 

; ------------------------------------------------------------------------------------------------------------------------------
; -- structures
; ------------------------------------------------------------------------------------------------------------------------------

; ------------------------------------------------------------------------------------------------------------------------------
; -- Globals
; ------------------------------------------------------------------------------------------------------------------------------

   Global NewList weg_geschlist.i  () ; geschliste: alle waypoints, die schon feststehen.
   Global NewList weg_openlist.i   () ; openliste: alle Waypoints, die noch bearbeitet werden m�ssen
   Global NewList weg_aufraumlist.i() ; aufraumliste: alle waypoints, die ver�ndert sind. (gesch+openlist)
   Global weg_gefunden.i              ; ob der weg gefunden wurde oder nicht ;)
   Global weg_zielID.i                ; zielid  
; jaPBe Version=3.8.8.716
; Build=0
; FirstLine=0
; CursorPosition=31
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF