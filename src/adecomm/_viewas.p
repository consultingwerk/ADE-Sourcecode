/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _viewas.p

Description:   
   Display and handle the dialog box for specifying a VIEW-AS clause for
   this field.

Input Parameter:
   p_ReadOnly  - True if box should be non-modifiable.
   p_DType     - The currently selected datatype for this field (code #)
   p_DTypeStr  - The character string value of the datatype.

Input-Output Parameter:
   p_Viewas    - The current view-as phrase

Output Parameter:
   p_Modified  - Set to yes if a modification was made, no otherwise.

Author: Laura Stern

Date Created: 08/04/92 
     Modified 06/18/98 Change DTYPE_RAW from 6 to 8 DLM
     Mario B. 12/4/98 Added syntax for LIST-ITEM-PAIRS to COMBO-BOX and
                      SELECTION-LIST.  Modified LIST-ITEMS for consistency.
     D McMann 03/16/99 Changed number of buffer-line for tty editor
  K. McIntosh 09/09/04 Ensure that nothing displays in dialog for field of
                       foreign data-type    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}
{adecomm/adeintl.i}
{adecomm/commeng.i}

Define INPUT            PARAMETER p_ReadOnly as logical NO-UNDO.
Define INPUT            PARAMETER p_DType    as integer NO-UNDO.
Define INPUT            PARAMETER p_DTypeStr as char    NO-UNDO.
Define INPUT-OUTPUT PARAMETER p_Viewas   as char    NO-UNDO.
Define OUTPUT       PARAMETER p_Modified as logical NO-UNDO init no.

/* Symbolic constants for dtype values. These match the underlying dtype
   value. */
&global-define           DTYPE_CHARACTER   1
&global-define           DTYPE_DATE        2
&global-define           DTYPE_LOGICAL     3
&global-define           DTYPE_INTEGER     4
&global-define           DTYPE_DECIMAL     5
&global-define           DTYPE_RAW         8
&global-define           DTYPE_RECID       7
&global-define 	         DTYPE_DATETM      34
&global-define 	         DTYPE_DATETMTZ    40
&global-define 	         DTYPE_INT64       41

Define stream viewas.

/* Each entry is a comma delimited list containing the set of view-as
   widgets that make sense for the data type.
*/
DEFINE VARIABLE ViewAs_Relevant AS CHARACTER EXTENT 9 NO-UNDO INITIAL
   [/* character */  "COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,TEXT",
    /* date             */  "COMBO-BOX,FILL-IN,RADIO-SET,TEXT",
    /* logical          */  "COMBO-BOX,FILL-IN,RADIO-SET,TEXT,TOGGLE-BOX",
    /* integer          */  "COMBO-BOX,FILL-IN,RADIO-SET,SLIDER,TEXT",
    /* decimal          */  "COMBO-BOX,FILL-IN,RADIO-SET,TEXT",
    /* recid            */  "COMBO-BOX,FILL-IN,RADIO-SET,TEXT",
    /* datetime         */  "FILL-IN",
    /* datetime-tz      */  "FILL-IN",
    /* int64            */  "COMBO-BOX,FILL-IN,RADIO-SET"
   ].

/* Index into ViewAs_Relevant array - will be set based on the data type. */
Define var ix_DTypes as integer NO-UNDO.

/* Form fields */
Define var ViewAs_Choices as char NO-UNDO 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      view-as SELECTION-LIST SINGLE INNER-CHARS 15 INNER-LINES 4 SCROLLBAR-V.
   &ELSE
      view-as SELECTION-LIST SINGLE INNER-CHARS 16 INNER-LINES 6.
   &ENDIF

Define var syntax as char NO-UNDO
   view-as EDITOR INNER-CHARS 54 
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
         INNER-LINES 4 BUFFER-LINES 9
      &ELSE
               INNER-LINES 7
      &ENDIF
      .

Define button btn_Ok          label "OK"     {&STDPH_OKBTN} AUTO-GO.
Define button btn_Cancel label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
Define button btn_Copy   
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      label "Copy Syntax" size 13 by 1.
   &ELSE
      label "&Copy Selected Syntax" size 22 by 1.125.
   &ENDIF

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   Define button    btn_Help label "&Help" {&STDPH_OKBTN}.
   Define rectangle rect_Btns {&STDPH_OKBOX}.
&ENDIF
FORM
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
      "Enter VIEW-AS phrase here:       " view-as TEXT at  2 
      SKIP

      p_Viewas  VIEW-AS EDITOR SCROLLBAR-VERTICAL
                INNER-CHARS 73 INNER-LINES 5 
                BUFFER-LINES 6                                    at  2
      SKIP(1)
   
      "To see syntax, select a widget type.       " view-as TEXT at  2 
      btn_Copy at 48
      SKIP
   
      ViewAs_Choices at  2 SPACE(2)
      syntax                                             
   
      {adecomm/okform.i
         &STATUS = no
         &OK     = btn_OK
         &CANCEL = btn_Cancel}
   &ELSE
      SKIP ({&TFM_WID})
      "Enter VIEW-AS phrase here:" view-as TEXT at  2 
      SKIP
   
      p_Viewas  VIEW-AS EDITOR SCROLLBAR-VERTICAL
                INNER-CHARS 70 INNER-LINES 6
                {&STDPH_ED4GL_SMALL}                        at  2
   
      SKIP({&VM_WIDG})
   
      "To see syntax, select a widget type.     " view-as TEXT at  2 
      SKIP({&VM_WID})
   
      ViewAs_Choices at  2 SPACE(2)
      syntax 
      SKIP({&VM_WID})

      btn_Copy at 1 /* will be centered later */

      {adecomm/okform.i
         &BOX    = rect_btns
         &STATUS = no
         &OK     = btn_OK
         &CANCEL = btn_Cancel
         &HELP   = btn_Help}
   &ENDIF

   with frame fld_viewas NO-LABELS 
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      view-as DIALOG-BOX TITLE "View-As Phrase".


/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_viewas
   apply "END-ERROR" to frame fld_viewas.


/*----- SELECTION of OK BUTTON or GO -----*/
on GO of frame fld_viewas  /* or OK because of AUTO-GO */
do:
   Define var tmpfile as char NO-UNDO.
   Define var val     as char NO-UNDO.

   /* If nothing was there in the first place, nothing will change.
      Otherwise, the user's view-as phrase will be replaced with 
      the unknown value.
   */
   val = TRIM(p_Viewas:screen-value in frame fld_viewas).
   if val = "" OR val = "?" OR val = ? then 
   do:
      /* If user comes in with nothing and leaves with nothing, 
               leave modified as no.
      */
      if p_Viewas <> "" AND p_Viewas <> "?" AND p_Viewas <> ? then 
               p_Modified = yes.
      p_Viewas:screen-value in frame fld_viewas = ?.
      return.
   end.

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
      run adecomm/_setcurs.p ("WAIT").
   &ENDIF
   run adecomm/_tmpfile.p (INPUT "", INPUT ".dct", OUTPUT tmpfile).
   output stream viewas TO VALUE(tmpfile) {&NO-MAP}.

   put stream viewas CONTROL
      "DEFINE VAR x AS " p_DTypeStr 
      CHR(10)
      p_Viewas:screen-value in frame fld_viewas
      CHR(10).

   output stream viewas CLOSE.

   compile VALUE(tmpfile) NO-ERROR.
   OS-DELETE VALUE(tmpfile).
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
      run adecomm/_setcurs.p ("").
   &ENDIF

   if compiler:error then 
   do:
      message "Your VIEW-AS phrase contains a syntax error." SKIP
                    "This statement does not compile:" SKIP(1)
                    "DEFINE VAR x AS" p_DTypeStr SKIP
                    p_Viewas:screen-value in frame fld_viewas SKIP(1)
                    error-status:get-message(1)
                    view-as alert-box error buttons OK.

      p_Viewas:CURSOR-OFFSET in frame fld_viewas = 
        INTEGER(compiler:FILE-OFFSET) - 17 - LENGTH(p_DTypeStr,"CHARACTER":u).
      apply "entry" to p_Viewas in frame fld_viewas.
      return NO-APPLY.
   end.
   else p_Modified = yes.
end.


/*----- VALUE-CHANGED of VIEWAS_CHOICES -----*/
on value-changed of ViewAs_Choices in frame fld_viewas
do:
   Define var cr as char NO-UNDO.  /* Carriage return */

   cr = CHR(10).

   /* Fill 4GL Editor widget with appropriate syntax for this widget
      type. */
   case SELF:screen-value:
      when "COMBO-BOX" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS COMBO-BOX" + cr +
                  "  [LIST-ITEMS value [,value] ... |" + cr +
            "   LIST-ITEM-PAIRS label,value [,label,value] ...]" + cr +
                  "  [~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height]" + cr +
                  "  [INNER-LINES height]" + cr +
                  "  [SORT] [SUBTYPE]" + cr +
            "  [TOOLTIP <tooltip>]".

      when "FILL-IN" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS FILL-IN [NATIVE]" + cr +
                  "  [~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height]" + cr +
            "  TOOLTIP <tooltip>]".

      when "EDITOR" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS EDITOR" + cr +
                  "  ~{~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height |" + cr +
                  "   INNER-CHARS num-chars INNER-LINES num-lines~}" + cr +
                  "  [SCROLLBAR-HORIZONTAL] [SCROLLBAR-VERTICAL]" + cr +
                  "  [MAX-CHARS chars] [NO-WORD-WRAP] [LARGE]" + cr +
                  "  [BUFFER-CHARS chars] [BUFFER-LINES lines]" + cr +
            "  [NO-BOX]" + cr +
            "  [TOOLTIP <tooltip>]".

      when "RADIO-SET" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS RADIO-SET" + cr +
                  "  RADIO-BUTTONS label, value [,label, value] ..." + cr +
                  "  [HORIZONTAL [EXPAND] | VERTICAL]" + cr +
                  "  [~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height]" + cr +
            "  [TOOLTIP <tooltip>]".

      when "SELECTION-LIST" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS SELECTION-LIST" + cr +
                  "  ~{~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height |" + cr +
                  "   INNER-CHARS num-chars INNER-LINES num-lines~}~}" + cr +
                  "  [SINGLE | MULTIPLE] [NO-DRAG] [SORT]" + cr +
                  "  [SCROLLBAR-HORIZONTAL]" + cr +
            "  [SCROLLBAR-VERTICAL]" + cr +
                  "  [LIST-ITEMS value [,value] ... |" + cr +
            "   LIST-ITEM-PAIRS label,value [,label,value] ...]" + cr +
            "  [TOOLTIP <tooltip>]".

      when "SLIDER" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS SLIDER" + cr +
                  "  MAX-VALUE max-value MIN-VALUE min-value" + cr +
                  "  [HORIZONTAL | VERTICAL]" + cr +
                  "  [~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height]" + cr +
            "  [NO-CURRENT-VALUE] [LARGE-TO-SMALL]" + cr +
            "  [TIC-MARKS LEFT|RIGHT|TOP|BOTTOM|NONE|BOTH" + cr +
            "    [FREQUENCY n]]" + cr +
            "  [TOOLTIP <tooltip>]".

      when "TEXT" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS TEXT" + cr +
                  "  [~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height]" + cr +
            "  [TOOLTIP <tooltip>]".

      when "TOGGLE-BOX" then
               syntax:screen-value in frame fld_viewas = 
                  "VIEW-AS TOGGLE-BOX" + cr +
                  "  [~{SIZE-PIXELS | SIZE-CHARS | SIZE~} width BY height]" + cr +
            "  [TOOLTIP <tooltip>]".
   end.
end.

/*----- CHOOSE of BUTTON COPY -----*/
on choose of btn_Copy in frame fld_viewas
do:
   Define var synhdl  as widget-handle NO-UNDO.
   Define var viewhdl as widget-handle NO-UNDO.
   Define var copytxt as char          NO-UNDO.
   Define var stat    as logical       NO-UNDO.

   synhdl = syntax:HANDLE in frame fld_viewas.
   viewhdl = p_Viewas:HANDLE in frame fld_viewas.

   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      copytxt = synhdl:screen-value.
      viewhdl:screen-value = "".
      stat = viewhdl:insert-string (copytxt).
      apply "entry" to viewhdl.
   &ELSE 
      if synhdl:text-selected then 
      do:
         apply "entry" to synhdl.
         copytxt = synhdl:selection-text.
         apply "entry" to viewhdl.
         /* you can't select text in destination and then select in source
            and have both stay selected so don't bother with replace.
         */
         stat = viewhdl:insert-string (copytxt).
      end.
   &ENDIF
end.

/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
   on HELP of frame fld_viewas OR choose of btn_Help in frame fld_viewas
      RUN "adecomm/_adehelp.p" ("comm", "CONTEXT", 
                                                  {&View_as_Phrase_Dlg_Box}, ?).
&ENDIF


/*==============================Mainline Code================================*/

Define var ix_types  as integer NO-UNDO.
Define var len       as integer NO-UNDO.
Define var widgtype  as char    NO-UNDO.


/* Fill the choices list with the appropriate view-as types.  Don't presume
   to know what the preprocess DTYPE values are, i.e. that they will match
   the index into the ViewAs_Relevant array (actually RECID doesn't).  
*/
ix_DTypes = (if p_DType = {&DTYPE_CHARACTER} then 1 else
             if p_DType = {&DTYPE_DATE}      then 2 else
             if p_DType = {&DTYPE_LOGICAL}   then 3 else
             if p_DType = {&DTYPE_INTEGER}   then 4 else
             if p_DType = {&DTYPE_DECIMAL}   then 5 else
             if p_DType = {&DTYPE_RECID}     then 6 else
             if p_DType = {&DTYPE_DATETM}    then 7 else
             if p_DType = {&DTYPE_DATETMTZ}  then 8 ELSE
             if p_DType = {&DTYPE_INT64}     then 9 ELSE
                   0). /* the 0 case should never happen, 
                          unless it's a foreign data-type */

IF ix_DTypes NE 0 THEN DO:
  ViewAs_Choices:LIST-ITEMS in frame fld_viewas= ViewAs_Relevant[ix_DTypes].

  /* If there is already a value, select the widget choice which matches
     the view-as syntax (if any). 
  */
  if p_Viewas = "" OR p_Viewas = ? then
    Viewas_Choices = ENTRY(1, Viewas_Relevant[ix_DTypes]).
  else do:
    find_match:
    do ix_types = 1 to NUM-ENTRIES(ViewAs_Relevant[ix_DTypes]):
      widgtype = ENTRY(ix_types, ViewAs_Relevant[ix_DTypes]).

      /* All syntax strings should start with the 8 characters:
               "VIEW-AS ", so start at pos 9 and check if there's a match 
               with this type. 
      */
      len = LENGTH(widgtype,"CHARACTER":u).
      if SUBSTRING(p_Viewas,9,len,"CHARACTER":u) = widgtype then
      do:
               ViewAs_Choices = widgtype.
               leave find_match. 
      end.         
    end.
  end.
END.

/* Run time layout for button area. */
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   {adecomm/okrun.i  
      &BOX    = "rect_Btns"
      &FRAME  = "FRAME fld_viewas"
      &OK     = "btn_OK"
      &CANCEL = "btn_Cancel"}
&ELSE
   {adecomm/okrun.i  
      &FRAME = "frame fld_viewas" 
      &BOX   = "rect_Btns"
      &OK    = "btn_OK" 
      &HELP  = "btn_Help"
   }
&ENDIF

p_Viewas:RETURN-INSERT = yes. /* So Return doesn't hit dflt button in editor */
syntax:read-only in frame fld_viewas = yes.
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   /* It looks better 1 row down  for tty */
   syntax:row in frame fld_viewas = syntax:row in frame fld_viewas + 1.
&ELSE
   btn_Copy:column in frame fld_viewas = 
      (frame fld_viewas:width - btn_Copy:width) / 2.
&ENDIF

/* display stuff and cause syntax to show for selected widget */
display Viewas_Choices p_Viewas with frame fld_viewas.
Viewas_Choices:sensitive in frame fld_viewas = yes.
apply "value-changed" to Viewas_Choices in frame fld_viewas.

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
   set  p_Viewas           when NOT p_ReadOnly
        &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
                btn_Copy       when NOT p_ReadOnly
              &ENDIF
        ViewAs_Choices   when NOT p_ReadOnly
              syntax          
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                btn_Copy       when NOT p_ReadOnly
              &ENDIF
              btn_OK           when NOT p_ReadOnly
              btn_Cancel
              &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                btn_Help
              &ENDIF
              with frame fld_viewas.

   if NOT p_ReadOnly then
      /* Remove any line feeds (which we get on WINDOWS) */
      p_Viewas = replace (p_Viewas, CHR(13), "").
end.

hide frame fld_viewas.




