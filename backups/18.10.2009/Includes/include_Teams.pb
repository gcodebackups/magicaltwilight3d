; -----------------------------------------------------------------------------------------------------
; --- Include Team  -----------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------
; --- zeigt auf, wer mit wem verb�ndet ist etc.
; -----------------------------------------------------------------------------------------------------
; jedes Team hat eine eigene Liste Mit Freunden und eine mit Feinden..
; so kann es passieren, dass figur1 figur 2 angreift, aber nicht umgekehrt (wobei. figur2 wehrt sich)
; der Team-name ist nur dazu da, dass sich die Wesen ins team eingliedern k�nnen (wenns schon besteht)
; wenn man mit andrem Team mit "liebend" verb�ndet ist, ist Team2 = team1, von Wertung her. (connected teams)
; -----------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------
; --- Procedures   ------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

   Procedure team_IsFreund          ( *Team1.team  , *Team2.team ) ; pr�ft, ob *team2 ein Freund von *team1 ist.. aber nicht ob team2 auch so denkt ;); 0: feind, 1: freund, #team_verhaltnis_neutral: neutral.
      Protected x.i
      
      If *Team1 = *Team2 ; wenns beide vom gleichen team sind, sinds automatisch befreundet. (auch ohne dass es deffiniert ist)
         ProcedureReturn #team_verhaltnis_Bruderschaftlich
      EndIf 
      
      For x = 0 To *Team1\anzahl_teams -1
          If *Team1\Team_ID[x]         = *Team2 
             If *Team1\Verhaltnis[x]   > #team_verhaltnis_neutral
                  ProcedureReturn 1
             ElseIf *Team1\Verhaltnis[x] <= #team_verhaltnis_neutral 
                  ProcedureReturn 0
             EndIf 
          EndIf 
      Next 
      
      ProcedureReturn #team_verhaltnis_neutral  ; standard: sie sind neutral.
   EndProcedure 
   
   Procedure Team_SetTeamVerhaltnis ( *Team1.team , *Team2.team , Verhaltnis = #team_verhaltnis_neutral ); Freund/feind- Level .. siehe  #team_verhaltnis...
      Protected x.i , break_Team1.i , break_Team2.i
      
      ; sicherheitscheck
      If Not *Team1 Or Not *Team2 ; wenn eines der teams gar net existiert.
          ProcedureReturn 0 
      EndIf 
      
      ; 1. Team1 �berpr�fen
         ; schaun, ob team1 schon team2 in liste hat
            For x = 0 To *Team1 \anzahl_teams -1   ; alle teams �berpr�fen, die schon eingespeichert sind.
               If *Team1\Team_ID [x]   = *Team2  ; wenn schon ein verh�ltnis zu team 2 vorhanden
                  *Team1\Verhaltnis[x] = Verhaltnis ;
                  break_Team1          = 1          ; es wurde abgebruchen -> team gefunden -> kein neues anlegen!!
                  Break                          ; suche weiterhin abbrechen.
               EndIf 
            Next 
            
         If Not break_Team1 ; wenn aber noch kein verhaltnis vorhanden
            If *Team1\anzahl_teams  + 1 > #team_max_Connections ; d�rfen ja nur 50 teams zusammen..
               ProcedureReturn 0 ; damit der andere dann nicht den einen zum Freund macht... 
            EndIf 
            *Team1\anzahl_teams  + 1
            x                    = *Team1\anzahl_teams -1
            *Team1\Team_ID[x]    = *Team2 
            *Team1\Verhaltnis[x] = Verhaltnis 
         EndIf 
      
      ; 2. Team �berpr�fen 
      
         ; schaun, ob team1 schon team2 in liste hat
            For x = 0 To *Team2 \anzahl_teams -1   ; alle teams �berpr�fen, die schon eingespeichert sind.
               If *Team2\Team_ID [x]   = *Team1  ; wenn schon ein verh�ltnis zu team 2 vorhanden
                  *Team2\Verhaltnis[x] = Verhaltnis ; 
                  break_Team2          = 1       ; es wurde abgebruchen -> team gefunden -> kein neues anlegen!!
                  Break                          ; suche weiterhin abbrechen.
               EndIf 
            Next 
            
         If Not break_Team2                      ; wenn aber noch kein verhaltnis vorhanden
            If *Team2\anzahl_teams  + 1 > #team_max_Connections ; d�rfen ja nur 40 teams zusammen..
               ProcedureReturn 0                 ; einfach abbrechen..
            EndIf 
            *Team2\anzahl_teams  + 1
            x                    = *Team2\anzahl_teams -1
            *Team2\Team_ID[x]    = *Team1 
            *Team2\Verhaltnis[x] = Verhaltnis 
         EndIf
         
         ProcedureReturn 1 ; successful
      
   EndProcedure 
   
   Procedure Team_GetFeindLevel     ( *Team1.team , *Team2.team) ; schaut, wie stark man verfeindet ist 
      
      For x = 0 To *Team1\anzahl_teams -1  ; pr�fen ob team1 mit team2 feind ist.. wenn ja: feindlevel ausgeben.
         If *Team1\Team_ID [x] = *Team2 
            ProcedureReturn    ( #team_verhaltnis_neutral - *Team1\Verhaltnis[x] ) ; neutral - Status = feindlevel. (z.b. 3 - 0 (totfeind) = 3 -> h�chstes feindlevel)
         EndIf 
      Next 
      
      ProcedureReturn #team_verhaltnis_neutral ; wenn nicht deffiniert: die teams sind neutral.
      
   EndProcedure 
   
   Procedure team_GetFreundLevel    ( *Team1.team , *Team2.team) ; schaut, wie stark man befreundet ist.
      
      For x = 0 To *Team1\anzahl_teams -1 ; pr�fen ob team1 mit team2 feind ist.. wenn ja: feindlevel ausgeben.
         If *Team1\Team_ID [x] = *Team2 
            ProcedureReturn    ( *Team1\Verhaltnis[x] - #team_verhaltnis_neutral) ; Freundschaftslevel.. von neutral bis liebend.
         EndIf 
      Next 
      
      ProcedureReturn #team_verhaltnis_neutral ; wenn nicht deffiniert: die teams sind neutral.
   
   EndProcedure 
   
   Procedure team_AddTeam           ( name.s ) ; f�gt ein neues Team hinzu. bzw. wenn schon vorhanden, wirds nur erg�nzt.
      Protected *team.team 
      
      ResetList(team())
      
         While NextElement( team()) 
            
            If team()\name = name ; wenn team schon existiert
                Debug "team existiert schon"
                ProcedureReturn team()
            EndIf 
         
         Wend 
         
         ; wenn aber noch nicht existiert (wenn schon w�re procedure ja schon abgebrochen)
         
         *team = AddElement( team())  ; add neues team ohne jegliche eigenschaften, au�er halt dem namen ;)
         *team \ name         = name 
         
         ProcedureReturn *team  ; herausgeben f�r r�ckgabewert.
         
   EndProcedure 
   
    
; jaPBe Version=3.7.12.680
; Build=0
; CompileThis=..\Wegfindung TESTER.pb
; FirstLine=14
; CursorPosition=28
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF