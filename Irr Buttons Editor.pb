
; ----------------------------------------------------------------------------------------------------------------------
; -- Constants
; ----------------------------------------------------------------------------------------------------------------------

Enumeration 
   #edit_gadget_art_button
   #edit_gadget_art_scrollbar
   #edit_gadget_art_text
   #edit_gadget_art_listview
   #edit_gadget_art_image
   #edit_gadget_art_window
   #edit_gadget_art_combobox
   #edit_gadget_art_checkbox
   #edit_gadget_art_editbox
   #edit_gadget_art_menu
   
   ;buttons, um alles zu bearbeiten
   #edit_gadget_select_gadgets ; cursor wird zum pfeil, falls dieses button angeklickt wurde.
   #edit_gadget_delete_gadgets
EndEnumeration

Enumeration 
   #edit_status_Addgadgets  ; gadgets hinzuf�gen
   #edit_status_select      ; gadgets markieren (per box)
   #edit_status_resize      ; gr��e ver�ndern
   #edit_status_edit        ; daten ver�ndern (text etc)
   #edit_status_move        ; gadgets bewegen.
EndEnumeration

; ----------------------------------------------------------------------------------------------------------------------
; -- include
; ----------------------------------------------------------------------------------------------------------------------

XIncludeFile #PB_Compiler_Home + "includes\irrlichtWrapper_include.pbi"

; ----------------------------------------------------------------------------------------------------------------------
; -- Structures
; ----------------------------------------------------------------------------------------------------------------------
   
   Structure editorbutton
      x.f
      y.f
      name.s              ; angezeigter Name des gadgetes
      x2.f                ; x2 = rechter rand des gadgets
      y2.f                ; y2 = unterer rand
      id.i                ; die irrlicht id des buttons
      NR.i                ; die Nummer (z.b. #edit_gadget_art_button)
   EndStructure 
   
   Structure Outputgadget
      name.s
      x.f
      y.f
      x2.f
      y2.f
      id.i
      
   EndStructure 
   
; ----------------------------------------------------------------------------------------------------------------------
; -- Globals
; ----------------------------------------------------------------------------------------------------------------------

Global NewList Edit_Button.editorbutton ()
Global ScreenWidth = 1024
Global ScreenHeight = 768
Global editorstatus

; ----------------------------------------------------------------------------------------------------------------------
; -- Procedures
; ----------------------------------------------------------------------------------------------------------------------

   Procedure save( name.s)
   
   EndProcedure 
   
   Procedure load ( name.s)
   
   EndProcedure 
   
   Procedure save_to_clipboard()
   
   EndProcedure 
   
   Procedure addgadget( art.i , x.f , y.f , x2.f , y2.f )
   
   EndProcedure 
   
   Procedure SetcurrentGadgetArt ( art )
   
   EndProcedure
   
   Procedure getcurrentgadgetart()
   
   EndProcedure 
   
   Procedure setcurrentwindow ( id)
   
   EndProcedure 
   
   Procedure getcurrentwindow ()
   
   EndProcedure 
   
   Procedure setcurrentgadget (id)
   
   EndProcedure 
   
   Procedure getcurrentgaget()
   
   EndProcedure
   
   Procedure ResizeGadget_ (id)
   
   EndProcedure 
   
   Procedure examine ()
   
   EndProcedure 
   
; ----------------------------------------------------------------------------------------------------------------------
; -- Gadget erstellen
; ----------------------------------------------------------------------------------------------------------------------


IrrStartEx( #IRR_EDT_OPENGL , ScreenWidth ,ScreenHeight,0,1,0,32,1,0,1,0)

  IrrSetWindowCaption( "Irr Button Editor" )
  
  For     x = 0 To #edit_gadget_art_menu
     
     Select x 
        
        Case #edit_gadget_art_button
            gadgetname.s = "Button"
        Case #edit_gadget_art_checkbox
            gadgetname = "Checkbox"
        Case #edit_gadget_art_combobox
           gadgetname = "Combobox"
        Case #edit_gadget_art_editbox
           gadgetname = "Editbox"
        Case #edit_gadget_art_image
           gadgetname = "Image"
        Case #edit_gadget_art_listview
           gadgetname = "List"
        Case #edit_gadget_art_menu
           gadgetname = "Menu"
        Case #edit_gadget_art_scrollbar
           gadgetname = "Scrollbar"
        Case #edit_gadget_art_text
           gadgetname = "Text"
        Case #edit_gadget_art_window
           gadgetname = "Window"
      EndSelect 
      
      If AddElement ( Edit_Button() )
      
         Edit_Button()\name = gadgetname
         Edit_Button()\x    = x * ScreenWidth / (#edit_gadget_art_menu+2) + ( x * ScreenWidth/ 2000)
         Edit_Button()\y    = 10
         Edit_Button()\x2   = x * ScreenWidth/ (#edit_gadget_art_menu+2) + (x * ScreenWidth/2000) + ScreenWidth/(#edit_gadget_art_menu+2)
         Edit_Button()\y2   = 25
         Edit_Button()\NR   = x
         Edit_Button()\id   = IrrGuiAddButton( Edit_Button()\name , Edit_Button()\x , Edit_Button()\y , Edit_Button()\x2  , Edit_Button()\y2 , 0 , x) ; #edit_gadget_art_menu muss da bei das letzte button sein, dass erstellt wrid!
         
      EndIf 
  
  Next 

  *OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )
  
 
; ----------------------------------------------------------------------------------------------------------------------
; -- Hauptschleife
; ----------------------------------------------------------------------------------------------------------------------
  
  ; while the scene is still running
  While IrrRunning()
  
      ; begin the scene, erasing the canvas to white before rendering
      IrrBeginScene( 255,255,255 )
      
      ; gadgets pr�fen.
      While IrrGuiEventAvailable()
         *guievent.IRR_GUI_EVENT = IrrReadGuiEvent()
   
         If *guievent\EventType > 0 
            
            ;{ schaun, ob Editor-gadgets gedr�ckt wurden.
            ResetList( Edit_Button())  
            
               While NextElement( Edit_Button())
                  
                  If *guievent\Caller = Edit_Button()\id And *guievent\EventType = #IRR_EGET_BUTTON_CLICKED
                     
                     If Edit_Button()\NR < #edit_gadget_art_menu  ; wenn etwas hinzugef�gt wird (Fenster etc.)
                        SetcurrentGadgetArt ( Edit_Button()\NR )
                     Else 
                     
                     EndIf 
                     
                  EndIf
                  
               Wend 
            ;}
            
           ;{ schaun, ob gadgetes verschoben werden oder �hnliches. 
           
           ;}
           
         EndIf
      Wend
    
     ; keyboard einlesen
    
      While IrrKeyEventAvailable()
          *KeyEvent.IRR_KEY_EVENT = IrrReadKeyEvent()
      Wend
  
      
      ; status verwalten
      
      Select editorstatus ; der status des Editors.
         
         Case #edit_status_Addgadgets
         
         Case #edit_status_edit
         
         Case #edit_status_move
         
         Case #edit_status_resize
         
         Case #edit_status_select
      
      EndSelect 
  
  
      IrrDrawScene()      
      IrrDrawGUI()
      IrrEndScene()
      
  Wend
  
  ; -----------------------------------------------------------------------------
  ; Stop the irrlicht engine and release resources
  IrrStop()

End

; jaPBe Version=3.7.2.629
; Build=0
; Language=0x0000 Language Neutral
; FirstLine=13
; CursorPosition=26
; ExecutableFormat=Console
; DontSaveDeclare
; IDE Options = PureBasic 4.10 Beta 2 (Windows - x86)
; CursorPosition = 83
; FirstLine = 74 
; jaPBe Version=3.9.12.819
; Build=0
; FirstLine=90
; CursorPosition=103
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF