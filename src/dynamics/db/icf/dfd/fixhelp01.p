/*****************************************************************
 *  File    : fixHelp01.p 
 *  Purpose : Fixes IssueZilla 3297, which removes the 'Help Contents'
 *            and the 'How to use Help' menu items from the Help band. 
 *            
 *            It also adds default help files in the gsm_help table if 
 *            they don't exist. 
********************************************************************/              
DEFINE VARIABLE cBandItemList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBandItem     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBandName     AS CHARACTER  NO-UNDO.

ASSIGN cBandItemList = "HelpContents,HelpHelp":U
       cBandName    = "Help":U.

SESSION:SET-WAIT-STATE("general").

TRANS-BLK:
DO TRANSACTION ON ERROR UNDO, LEAVE:
  DO i = 1 TO NUM-ENTRIES(cBandItemList):
    cBandItem = ENTRY(i,cBandItemList).
    FIND gsm_menu_item WHERE gsm_menu_item.menu_item_reference = cBandItem 
         NO-LOCK NO-WAIT NO-ERROR.
    IF AVAILABLE gsm_menu_item THEN 
    DO:
      FOR EACH  gsm_menu_structure NO-LOCK
          WHERE gsm_menu_structure.menu_structure_code = cBandName:
        FOR EACH  gsm_menu_structure_item EXCLUSIVE-LOCK
            WHERE gsm_menu_structure_item.menu_structure_obj = gsm_menu_structure.menu_structure_obj
              AND gsm_menu_structure_item.menu_item_obj = gsm_menu_item.menu_item_obj:
          DELETE gsm_menu_structure_item NO-ERROR.
        END.
      END.
    END.
  END.
END.
/* Create new default help topic entries items for each language.
   If a default record exists but not default help file is specified,
   specify the default file as 'prohelp/icabeng.hlp' */
TRANS-BLK2:
DO TRANSACTION :
  LANGUAGE-BLOCK:
  FOR EACH gsc_language NO-LOCK:
    FIND gsm_help EXCLUSIVE-LOCK
      WHERE gsm_help.help_container_filename = ""
        AND gsm_help.help_object_filename     = ""
        AND gsm_help.help_fieldname           = ""
        AND gsm_help.language_obj             = gsc_language.language_obj
        NO-ERROR.
    IF NOT AVAILABLE gsm_help THEN
      CREATE gsm_help NO-ERROR.

    ASSIGN gsm_help.language_obj            = gsc_language.language_obj
           gsm_help.help_container_filename = ""
           gsm_help.help_object_filename    = ""
           gsm_help.help_fieldname          = "" 
           gsm_help.help_filename           = IF help_filename = "" OR help_filename = ? 
                                              THEN "prohelp/icabeng.hlp":U
                                              ELSE help_filename 
           .
    VALIDATE gsm_help NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
       NEXT LANGUAGE-BLOCK.
    
  END. /* END FOR EACH gsc_language */


END.

SESSION:SET-WAIT-STATE("").

/*MESSAGE "HelpFix01 complete"
  VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
