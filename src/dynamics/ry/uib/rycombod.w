&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME QueryTablefrmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS QueryTablefrmAttributes 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: rycombod.w 

  Description: Instance Attributes Dialog for ICF Dynamic Combo.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  Modified: 08/27/2001 (Mark Davies)
            If more than one field is displayed in the combo's list items 
            and the developer changes the substitute field to view fields 
            in a different order or change the delimiter, the field is reset 
            upon selecting the OK button.

 Modifed:  08/28/2001 (Mark Davies)
           The Dynamic Lookup and Combo's Base Query String editor 
           concatenates the whole query string and thus causes the 
           string to be invalid. Make sure that when enter was pressed 
           that spaces are left in its place.

Modified: 09/25/2001         Mark Davies (MIP)
          1. Allow detaching of combo from template if properties
             were changed.
          2. Remove references to KeyFieldValue and SavedScreenValue
          3. Reposition Product and Product module combos to template
             combo or combo smartobject.
          4. Grey-out object description when disabled.
Modified: 10/01/2001        Mark Davies (MIP)
          Resized the dialog to fit in 800x600
Modofied: 10/16/2001        Mark Davies (MIP)
          1. Removed 'Sort' option and added Inner Lines
Modified: 01/16/2002        Mark Davies (MIP)
          Fixed issue #3683 - Data is lost have it has been saved when 
          dismissing a window
Modified: 03/15/2002        Mark Davies (MIP)
          Added custom super procedure support for Dynamic Lookups
          Fix for issue #3420 - Dynamic Lookups (and Combos) should 
          have "CustomSuperProc" properties, and should launch this 
          procedure.
Modified: 06/21/2002        Mark Davies (MIP)
          Made changes to comply with V2 Repository changes.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER p_hSMO                   AS HANDLE     NO-UNDO.

{src/adm2/globals.i}

def var cButtonPressed as character no-undo.

run showMessages in gshSessionManager ({errortxt.i 'AF' '40' '?' '?' '"This procedure (ry/uib/rycombod.w) has been deprecated. Please report any occurrences of this message to Tech Support"'},
                                       'INF',
                                       '&Ok',
                                       '&Ok',
                                       '&Ok',
                                       'Deprecated procedure',
                                       Yes,
                                       ?,
                                       output cButtonPressed) no-error.

run adeuib/_dynamiccombod.w (p_hSMO).

/* EOF */