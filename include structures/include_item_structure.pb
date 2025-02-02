; -----------------------------------------------------------------------------------------------------
; --- Constants ---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

   Enumeration ; Itemarten
      #item_art_kram
      #item_art_geld
      #item_art_leben     ; z.b. apfel , brot etc.
      #item_art_mana      ; was halt mana aufl�dt
      #item_art_lebenmana ; was beides aufl�dt
      #item_art_nahkampf  ; z.b. schwert
      #item_art_fernkampf
      #item_art_magie     ; z.b. zauberstein
      #item_art_quest     ; questgegenstand.
   EndEnumeration 

   Enumeration ; Predefined Items
      #item_predef_geld
      #item_predef_kl_lebenstrank
      #item_predef_kl_manatrank
      #item_predef_m_lebenstrank
      #item_predef_m_manatrank
      #item_predef_gr_lebenstrank
      #item_predef_gr_manatrank
   EndEnumeration 
   
   Enumeration ; Waffenarten
      #item_waffe_nahkampf              ; einfache Nahkampfwaffe.
      #item_waffe_rustung
      #item_waffe_schild
      #item_waffe_fernkampf 
      #item_waffe_zauber 
   EndEnumeration 
   
   Enumeration ; Pfeilarten
      #item_fernkampf_Pfeil       ; es fliegen Pfeile
      #item_fernkampt_Feuerpfeil  ; es fliegen Feuerpfeile
   EndEnumeration 
   
   Enumeration ; zauberarten
      #item_zauber_Feuerlicht     ; es fliegen Feuerpfeile ...
      #item_zauber_Feuerschlag    ; Ein kleines Fl�mmchen, das hell leuchtet und m��ig abzieht.
      #item_zauber_Feuerball      ; FeuerBall fliegt auf gegner zu...
      #item_zauber_Eissplitter
      #item_zauber_Steinschuss
      #item_zauber_Lebensdieb
      #item_zauber_Zerschmettern
   EndEnumeration 
   
   #item_reichweite_kurzbogen = #meter * 5
   #item_reichweite_bogen     = #meter * 8
   #item_reichweite_langbogen = #meter * 12
   
; -----------------------------------------------------------------------------------------------------
; --- Structures---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

Structure ITEM_Predef ; damit man nur die Nummer des zu erstellenden Items eingeben muss (und Position) aber net wieder alle texturen etc.
   exist.w            ; ob das predef Item �berhaupt existiert..
   name.s
   GuiText.s
   price.i
   art.i
   pfad.s
   texture1.s
   texture2.s
   MaterialType.i
   gui_InventarImage_pfad.s ; Konstante zum bild f�rs inventar ;) 
   gui_InventarBigImage_pfad.s ; f�r den ausr�stungsslot des inventars hier.
   Gewicht.f
   Betrag.w      ; wie viel es auf Leben, Angriff etc gibt (abh�ngig von der Itemart, wenn's z.b. ein angriffsBOOster ist;)
   angriff.i     ; nur, wenn Item ne Waffe ist 
   Reichweite.f  ; Schussreichweite bei Fernwaffen
   Waffenart.w   ; ob fern, magie oder nahkampfwaffe etc. 
EndStructure 

Structure item_anz_struct
   pfad.s        ; meshpfad
   x.f
   y.f
   z.f
   texture.s
   MaterialType.i
   normalmap.s
EndStructure

Structure ITEM
   Anz_mesh_struct.item_anz_struct ; beim Droppen muss Item ja wieder runtergeworfen werden -> neuerstellt werden.
   name.s         ; name wird �berm Item angezeigt , wenn in Fokus (PAUSE.. noch nicht eingebaut)
   GuiText.s      ; was im inventar etc. �ber das Item angezeigt wird.
   price.i        ; Goldwert..
   art.i          ; art des Items (siehe #item_art_..)
   anz_Mesh_ID.i  ; Pointer zum Anz_mesh. wenn Waffe in Hand: anz_mesh_ID > 0 and is_visible = 0.!!
   is_Visible.i   ; wenn gecaptured, dann unsichtbar und nicht aufhebbar. 
   Betrag.i       ; wie viel es auf Leben, Angriff etc gibt (abh�ngig von der Itemart.
   WaffenID.i     ; wenns aber ne Waffe ist -> f�r item_waffe!!
   Gewicht.f      ; im Moment noch ignoriert.
   gui_InventarImage.i ; Konstante zum bild f�rs inventar. 
   gui_InventarImage_pfad.s ; pfad zum bild f�r's neuladen etc.
EndStructure

Structure item_waffe ; Zusatzinfos zum normalen Item.. z.b. Waffenreichweite , Angriff, Art etc.
   StructureUnion ; entweder es is 'n schild bzw. r�stung etc.. oder eine Waffe, dann Angriff ;)
      angriff.w
      schild.w
   EndStructureUnion
   Reichweite.f   ; wie weit die Waffe zuschlagen kann. 
   Waffenart .w   ; Art der Waffe.. 
   gui_InventarBigImage.i
EndStructure 

Structure item_examined_Node  ; zum �berpr�fen der umgebungs-items
   nodeID.i      ; pointer zu irrlicht-Node.
   Object3dID.i  ; pointer zu anz_object3d()
   AnzID.i       ; z.b. pointer zu anz_mesh()
   itemID.i      ; die ItemID
   distance.f    ; Entfernung zwischen Wesen und Item (bei Examine etc)
EndStructure 

; -----------------------------------------------------------------------------------------------------
; --- Globals   ---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

Global NewList item.ITEM                               ( )
Global Dim item_predefined.ITEM_Predef                 ( 200 )
Global NewList item_Examined_node.item_examined_Node   ( )
Global NewList item_waffe.item_waffe                   ( )

Global item_FocusItem.i
Global item_check_waiter.i ; counter, um nicht bei jedem durchlauf das aktuell im fokus seiende item zu suchen. 
; jaPBe Version=3.9.12.818
; Build=0
; FirstLine=70
; CursorPosition=95
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF