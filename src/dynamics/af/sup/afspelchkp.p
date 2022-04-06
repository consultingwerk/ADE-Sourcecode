&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: afspelchkp.p

  Description: Spell check Structured Include

  Purpose: This template should be used to create structured include files.

  Input Parameters:
      iop_string - The word/string to be spell checked.

  Output Parameters:
      <none>

  History:
  (010000)  Task:      1997/07/23   Jennifer Bond
            This spellcheck procedure was adapted from the Progress example
            in dlc$/src/samples/activex/spellcheck/spell.p.  The contents
            of the fill-in or editor to be checked are passed into this
            programme by an input-output parameter 'iop_string', which is
            passed to either Word for Office 95 or Office 97, depending
            which is being used.  The spell check is then done by Word,
            and the corrected string passed back to the programme from 
            which it was sent.

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afspelchkp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001



DEFINE INPUT-OUTPUT PARAMETER iop_string   AS  CHARACTER   NO-UNDO.

DEFINE VARIABLE wordAppl    AS COM-HANDLE      NO-UNDO.
DEFINE VARIABLE i           AS INTEGER         NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = .19
         WIDTH              = 31.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


/*
 * First we need to determine if we are running on a system with Word for 
 * Office 95 or Office 97 since the Automation Objects are dramatically 
 * different. We do this by looking for a particular Object and if it fails
 * then we try the other version. This is done by accessing the system 
 * registry
 */

LOAD "Word.Application" BASE-KEY "HKEY_CLASSES_ROOT" NO-ERROR. /* Open Registry key */
IF error-status:error THEN DO:

    /* Office 95 Word 
     *
          * When the Spell Check button is pressed, create an Automation Object 
          * for Word.Basic
          * 
          * Copy the text from iop_string and put into a new file created in Word.
          * The spelling check is done on that Word file and all changes are put
          * into that unnamed file. This is all done by the ToolsSpelling() method.
          *
          * Once that completes, we take the updated contents of the unnamed file 
          * and copy it back into the edit control on the Progress frame. We then 
          * close the Automation Object without saving the file.
          */

    CREATE "Word.Basic" wordAppl.
    NO-RETURN-VALUE wordAppl:FileNew.
    NO-RETURN-VALUE wordAppl:Insert(iop_string).
    ASSIGN i = wordAppl:ToolsSpelling NO-ERROR.
    NO-RETURN-VALUE wordAppl:AppHide("Microsoft Word").
    NO-RETURN-VALUE wordAppl:EditSelectAll.
    iop_string = wordAppl:Selection().
    NO-RETURN-VALUE wordAppl:FileClose(2).
    NO-RETURN-VALUE wordAppl:AppClose("Microsoft Word").
END. 

ELSE DO: 
    UNLOAD "Word.Application". /* Close Registry key */
    /* Office 97 Word
     *
     * When the Spell Check button is pressed,create an Automation Object for 
     * Word.Application
     *
     * Copy the text from iop_string and put into a new document in an OLE 
     * Collection.  The spelling check is done on that document and all 
     * changes are put into that document. This is all done by the 
     * CheckGrammar() method.
     *
     * Once that completes, we take the updated contents of the document 
     * and copy it back into the edit control on the Progress frame. We then 
     * quit the Automation Object.
     */

    CREATE "Word.Application" wordAppl.
    wordAppl:Documents:Add().
    wordAppl:Documents:Item(1):Range(0,0):InsertAfter(iop_string).
    wordAppl:Options:CheckGrammarWithSpelling = TRUE.
    wordAppl:Documents:Item(1):CheckGrammar().
    wordAppl:Visible = FALSE.
    iop_string = wordAppl:Documents:Item(1):Range(0,wordAppl:Documents:Item(1):Characters:Count):Text.

    /* 
     * The following two lines demonstrate a different way to do the 
     * selection of the text.
     *       wordAppl:Documents:Item(1):Select. 
     *       iop_string:SCREEN-VALUE=wordAppl:Selection:Text.
     */

    wordAppl:Quit(0).
END.

RELEASE OBJECT wordAppl.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


