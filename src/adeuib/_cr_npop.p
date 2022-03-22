/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _cr_npop.p

Description:
   Creates pop-up menu on the New button in the UIB Main Window which serves as
   as shortcut to creating New objects in the UIB.

Input Parameters:
   hNewButton (hdl) - handle to 'new' button

Output Parameters:
   <None>

Author: Gerry Seidl

Date Created: 2/16/95

Date Modified: 5/16/95 gfs - added support for 'NEW-' cst types.
----------------------------------------------------------------------------*/
{adeuib/custwidg.i} /* _custom & _palette_item temp-table defs */
{adeuib/sharvars.i} /* UIB shared variables */

DEFINE INPUT PARAMETER hNewButton AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE        newpopup   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE        newmi      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE        oldpopup   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE        nlist      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE        i          AS INTEGER       NO-UNDO.
DEFINE VARIABLE        so-type    AS CHARACTER     NO-UNDO.

/* If there already is a popup menu, delete it */
ASSIGN oldpopup = hNewButton:POPUP-MENU.
IF VALID-HANDLE(oldpopup) THEN DELETE WIDGET oldpopup.

CREATE MENU newpopup
  ASSIGN POPUP-ONLY = TRUE.
         
/* First, add Container and records */
FOR EACH _custom WHERE _custom._type = "Container":
  so-type = "".
  DO i = 1 TO NUM-ENTRIES(_custom._attr, CHR(10)):      
      IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "TYPE" THEN
        so-type = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),5,-1,"CHARACTER")).
      IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "NEW-TEMPLATE" THEN
        FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),13,-1,"CHARACTER")).
  END.
 /* FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).*/

  IF FILE-INFO:FULL-PATHNAME NE ? and so-type = "" THEN DO:
    CREATE MENU-ITEM newmi
      ASSIGN PARENT = newpopup
             LABEL  = _custom._name
             TRIGGERS:
               ON CHOOSE PERSISTENT 
                  RUN Open_Untitled IN _h_uib (FILE-INFO:FULL-PATHNAME).
             END TRIGGERS.
  END.    
  ELSE IF FILE-INFO:FULL-PATHNAME NE ? and so-type > "" THEN DO:
     CREATE MENU-ITEM newmi
        ASSIGN PARENT = newpopup
               LABEL  = _custom._name
               TRIGGERS:
                 ON CHOOSE PERSISTENT 
                    RUN Open_SO_Untitled IN _h_uib (so-type, FILE-INFO:FULL-PATHNAME).
               END TRIGGERS.
  END.
END.

IF VALID-HANDLE(newmi) THEN /* created at least one Container */
CREATE MENU-ITEM newmi
  ASSIGN PARENT  = newpopup
         SUBTYPE = "RULE".

ASSIGN newmi = ?.

/* Step 2 - "NEW" SmartObjects, such as base and wizard versions */
FOR EACH _custom WHERE _custom._type = "SmartObject" BY _custom._name:
  DO i = 1 TO NUM-ENTRIES(_custom._attr, CHR(10)):
    IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "TYPE" THEN
      so-type = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),5,-1,"CHARACTER")).
    IF ENTRY(i,_custom._attr,CHR(10)) BEGINS "NEW-TEMPLATE" THEN
      FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(ENTRY(i,_custom._attr,CHR(10))),13,-1,"CHARACTER")).
  END.
  IF FILE-INFO:FULL-PATHNAME NE ? AND so-type NE "" THEN DO:
    CREATE MENU-ITEM newmi
      ASSIGN PARENT = newpopup
             LABEL  = _custom._name
             TRIGGERS:
               ON CHOOSE PERSISTENT 
                  RUN Open_SO_Untitled IN _h_uib (so-type, FILE-INFO:FULL-PATHNAME).
             END TRIGGERS.
  END.    
END.
           
IF VALID-HANDLE(newmi) THEN
CREATE MENU-ITEM newmi
  ASSIGN PARENT  = newpopup
         SUBTYPE = "RULE".
ASSIGN newmi = ?.

/* Third, add Procedure and records */
FOR EACH _custom WHERE _custom._type = "Procedure":
  FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
    CREATE MENU-ITEM newmi
      ASSIGN PARENT = newpopup
             LABEL  = _custom._name
             TRIGGERS:
               ON CHOOSE PERSISTENT 
                  RUN Open_Untitled IN _h_uib (FILE-INFO:FULL-PATHNAME).
             END TRIGGERS.
  END.    
END.

IF VALID-HANDLE(newmi) THEN
CREATE MENU-ITEM newmi
  ASSIGN PARENT  = newpopup
         SUBTYPE = "RULE".
ASSIGN newmi = ?.

/* Third, add Procedure and records */
FOR EACH _custom WHERE _custom._type = "WebObject":
  FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_attr),13,-1,"CHARACTER")).
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
    CREATE MENU-ITEM newmi
      ASSIGN PARENT = newpopup
             LABEL  = _custom._name
             TRIGGERS:
               ON CHOOSE PERSISTENT 
                  RUN Open_Untitled IN _h_uib (FILE-INFO:FULL-PATHNAME).
             END TRIGGERS.
  END.    
END.
IF VALID-HANDLE(newmi) THEN /* created at least one WebObject */
CREATE MENU-ITEM newmi
  ASSIGN PARENT  = newpopup
         SUBTYPE = "RULE".
ASSIGN newmi = ?.


/* Third, add path to template chooser */
CREATE MENU-ITEM newmi
  ASSIGN PARENT = newpopup
         LABEL  = "&Choose Other Template..."
         TRIGGERS:
           ON CHOOSE PERSISTENT RUN choose_template IN _h_uib.
         END TRIGGERS.
        
/* Last, attach pop-up menu to the 'New' button */ 
ASSIGN hNewButton:POPUP-MENU = newpopup.

RETURN.
