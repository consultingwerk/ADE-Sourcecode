/*************************************************************/
/* Copyright (c) 2005-2011 by Progress Software Corporation. */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _drwflds2.p
    Purpose     : draw selected fields to a file

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Feb 11 18:07:30 EST 2012
    Notes       : split from drwflds.p for external calls 
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 
{adeuib/sharvars.i}
{adeuib/uniwidg.i} 
{adeuib/layout.i}
{adecomm/adestds.i}
{adecomm/adeintl.i}
 
define input  parameter pcDbName           as character no-undo.
define input  parameter pcTableNames       as character no-undo.
define input  parameter pcFieldNames       as character no-undo.
define input  parameter plUseDataObject    as logical no-undo.
define input  parameter pcSDOClobCols      as character no-undo.
DEFINE OUTPUT PARAMETER dbf_temp_file      AS CHARACTER NO-UNDO.
 

DEFINE STREAM temp_file.
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
/* ***************************  Main Block  *************************** */
/*procedure ProcessOk:*/
    DEFINE VAR cClobMapping AS CHARACTER                     NO-UNDO.
    DEFINE VAR cLocalFld    AS CHARACTER                     NO-UNDO.
    DEFINE VAR iNumFld      AS INTEGER                       NO-UNDO.
    DEFINE VAR fwidth       AS INTEGER                       NO-UNDO.
    DEFINE VAR fld_name     AS CHARACTER FORMAT "X(12)"      NO-UNDO.
    DEFINE VAR fld_leader   AS CHARACTER                     NO-UNDO.
    DEFINE VAR f-row        AS INTEGER                       NO-UNDO.
    DEFINE VAR f-col        AS INTEGER                       NO-UNDO.
    DEFINE VAR numrows      AS INTEGER                       NO-UNDO.
    DEFINE VAR numcols      AS INTEGER                       NO-UNDO.
    DEFINE VAR to-row       AS INTEGER                       NO-UNDO.
    DEFINE VAR to-col       AS INTEGER                       NO-UNDO.
    DEFINE VAR tt-def       AS CHARACTER                     NO-UNDO.
    DEFINE VAR c            AS INTEGER                       NO-UNDO.
    DEFINE VAR i            AS INTEGER                       NO-UNDO.
    define var numEnt       as integer                       no-undo.    
    DEFINE BUFFER x_U FOR _U.
  
  nument = num-entries(pcfieldNames).
  
  /* We need to fully specify the names of the fields: db.table.field.
     The fld_names may already include the table (if we selected multiple tables),
     otherwise add the database.table leader on each file name is... */
  IF pcDbName NE "Temp-Tables":U THEN DO:
    IF NUM-ENTRIES(ENTRY(1,pcFieldNames),".") eq 1
      THEN fld_leader = pcDbName + "." + pcTableNames + "." .
      ELSE fld_leader = pcDbName + "." .
  END.  /* If not dealing with temp-tables */

  /* Get information about the frame we are drawing in.  Find the lower edge
     corner of all widgets already in the frame so that we can import at the
     correct spot.  NOTE: in a column-label frame, look at all non-RECTANGLE
     widgets.  In a side-label frame, just look at DB Field widgets in 
     deciding how much to skip. */
  FIND _U WHERE _U._HANDLE eq _h_frame.
  FIND _L WHERE RECID(_L) eq _U._lo-recid.
  FIND _C WHERE RECID(_C) eq _U._x-recid.

  /* Create a temporary file to IMPORT */
  RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_DBFIELD}, {&STD_EXT_UIB}, OUTPUT dbf_temp_file).
  OUTPUT STREAM temp_file TO VALUE(dbf_temp_file) {&NO-MAP}.
  PUT STREAM temp_file UNFORMATTED
      "&ANALYZE-SUSPEND _EXPORT-NUMBER " _UIB_VERSION SKIP
      "&ANALYZE-RESUME" SKIP.

  /* If there are temp-table definitions, write them out here */
  RUN gen-tt-def(OUTPUT tt-def).
  PUT STREAM temp_file UNFORMATTED tt-def SKIP.

  IF plUseDataObject THEN 
  DO:
    DO iNumFld = 1 TO NUM-ENTRIES(pcFieldNames):
      fld_name = ENTRY(iNumFld, pcFieldNames).
      IF fld_name BEGINS "Temp-Tables":U THEN
        fld_name = REPLACE(fld_name, "Temp-Tables.":U, "":U).
      IF fld_name BEGINS "RowObject":U THEN
        fld_name = REPLACE(fld_name, "RowObject.":U, "":U).
      /* If the field is a clob field, add a local LONGCHAR variable to the frame */
      IF LOOKUP(fld_name, pcSDOClobCols) > 0 THEN
      DO:
        /* Rename the local field if there is already a field on the viewer 
           with the same name. */
        cLocalFld = IF NUM-ENTRIES(fld_name, ".":U) > 1 
                    THEN ENTRY(2, fld_name, ".":U)
                    ELSE fld_name.
        i = 0.
        /* First check for other fields */
        NameCheck:
        DO WHILE TRUE:
          FIND FIRST x_U WHERE x_U._NAME EQ cLocalFld 
               AND x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
               AND x_U._STATUS NE "DELETED":U NO-ERROR.
          IF AVAILABLE x_U THEN
          DO:
            IF i > 0 THEN
              cLocalFld = SUBSTRING(cLocalFld, 1, INDEX(cLocalFld, "-":U) - 1).
            i = i + 1.
            cLocalFld = cLocalFld + "-":U + STRING(i).
          END.  /* if avail x_U */
          ELSE LEAVE NameCheck.
        END.  /* do while true */
        /* Second check for other CLOB fields that may already have the same name
           local name */
        LocalNameCheck:
        DO WHILE TRUE:
          FIND FIRST x_U WHERE x_U._LOCAL-NAME EQ cLocalFld 
               AND x_U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
               AND x_U._STATUS NE "DELETED":U NO-ERROR.
          IF AVAILABLE x_U THEN
          DO:
            IF i > 0 THEN
              cLocalFld = SUBSTRING(cLocalFld, 1, INDEX(cLocalFld, "-":U) - 1).
            i = i + 1.
            cLocalFld = cLocalFld + "-":U + STRING(i).
          END.  /* if avail x_U */
          ELSE LEAVE LocalNameCheck.
        END.  /* do while true */
        /* If the data source has qualified fields there could be a name clash 
           with other fields in the source being added at the same time.  
           If it clashes with another field already in the mapping, create a 
           unique name for the local field. */ 
        IF NUM-ENTRIES(fld_name, ".":U) > 1 THEN
        DO:
          DO WHILE LOOKUP(cLocalFld, cClobMapping) > 0:
            IF i > 0 THEN
              cLocalFld = SUBSTRING(cLocalFld, 1, INDEX(cLocalFld, "-":U) - 1).
            i = i + 1.
            cLocalFld = cLocalFld + "-" + STRING(i).
          END.  /* do while */
        END.  /* if SBO data source */
        /* Add to mapping - format is 
           localfield,SDOName.fieldname[,...] */
        cClobMapping = cClobMapping + 
                       (IF cClobMapping NE "":U THEN ",":U ELSE "":U) +
                       cLocalFld + ",":U + fld_name.
        PUT STREAM temp_file UNFORMATTED 
          "DEFINE VARIABLE " cLocalFld " AS LONGCHAR" SKIP
          "    VIEW-AS EDITOR LARGE SIZE 30 BY 1." SKIP(1).
      END.  /* if clob */
    END.  /* do iNumFld */
    /* Assign frame datafield-mapping so that mapping is used in readinit.i to 
       set _U name, table and buffer correctly */
    _C._DATAFIELD-MAPPING = cClobMapping.
  END.  /* if useDataObject */

  /* Figure out the area in which to draw the fields in the frame */
  IF _C._SIDE-LABELS THEN RUN adeuib/_chklbls.p (_L._FONT). /* adjust x to start */
  ASSIGN f-row   = 1.0 + (_frmy / SESSION:PIXELS-PER-ROW)  /* starting row */
         f-col   = 1.0 + (_frmx / SESSION:PIXELS-PER-COL). /* starting column */
         
  IF (_second_corner_x - _frmx) / SESSION:PIXELS-PER-COLUMN < .9 OR
     (_second_corner_y - _frmy) / SESSION:PIXELS-PER-ROW < .9 THEN DO:
    IF (_second_corner_x - _frmx) / SESSION:PIXELS-PER-COLUMN < .9 THEN
      ASSIGN fwidth = _h_frame:WIDTH - f-col.
    IF (_second_corner_y - _frmy) / SESSION:PIXELS-PER-ROW < .9 THEN
      ASSIGN numrows = _h_frame:HEIGHT - f-row.
  END.  /* If either part of the click is close */
  ELSE 
    ASSIGN
      to-row  = 1.0 + (_second_corner_y / SESSION:PIXELS-PER-ROW)  /* ending row */
      numrows = to-row - f-row
      to-col  = 1.0 + (_second_corner_x / SESSION:PIXELS-PER-COLUMN)  /* ending col */
      fwidth  = to-col - f-col.
  IF numrows = ? OR numrows < 1 THEN numrows = 1.
  ASSIGN numrows = MAX(1,numrows)
         numcols = MAX(1, (NumEnt / numrows)). /* number of columns needed */
  IF NumEnt MOD numrows <> 0 then numcols = numcols + 1.
  /* Write out the FORM statement */
  PUT STREAM temp_file UNFORMATTED 
    /* Skip to the next line, unless there are no lines left, in which case
       we start at the top again */
    "FORM " .
  DO i = 1 TO NumEnt:
    fld_name = fld_leader + ENTRY(i, pcFieldNames).
    IF fld_name BEGINS "Temp-Tables":U THEN
      fld_name = REPLACE(fld_name, "Temp-Tables.":U, "":U).
    
    /* Check the mapping for the field name to get the local field
       name for the frame. */
    cLocalFld = REPLACE(fld_name, "RowObject.":U, "":U).
    
    IF LOOKUP(cLocalFld, cClobMapping) > 0 THEN
      fld_name = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                  INPUT cLocalFld,
                                  INPUT cClobMapping,
                                  INPUT FALSE,
                                  INPUT ",":U).

    PUT STREAM temp_file UNFORMATTED SKIP "    ":U fld_name.
    IF (i - 1) MOD numrows ne 0 THEN DO: /* same column */
      PUT STREAM temp_file UNFORMATTED " COLON " (IF c > 0 THEN c ELSE f-col).
    END.
    ELSE DO: /* new column */
      c = IF i eq 1 THEN f-col  /* First Column */
          ELSE c + fwidth / numcols.
      PUT STREAM temp_file UNFORMATTED " AT ROW " f-row " COL " c " COLON-ALIGNED".
    END.
  END.
  IF _C._SIDE-LABELS THEN
    PUT STREAM temp_file UNFORMATTED SKIP
      "  WITH SIDE-LABELS SCROLLABLE".
  ELSE DO:   /* Column LABELS */
    PUT STREAM temp_file UNFORMATTED SKIP
      "  WITH DOWN SCROLLABLE".
  END.  
  /* Add Frame attributes that would affect the default size of a fill-in
     (e.g. THREE-D and FONT) */
  PUT STREAM temp_file UNFORMATTED
         (IF _L._3-D THEN " THREE-D" ELSE "") + 
         (IF _L._FONT ne ? THEN " FONT " + STRING(_L._FONT) ELSE "") + 
         "." SKIP "ENABLE ALL." SKIP.
  
  OUTPUT STREAM temp_file CLOSE.
  /* Debugging Code: Look at the file before we return */
/*   RUN adeuib/_prvw4gl.p (dbf_temp_file, ?, ?, ?).                        */
/*   RUN adecomm/_pwmain.p (INPUT "_ab.p"    /* PW Parent ID  */ ,          */
/*                          INPUT dbf_temp_file      /* Files to open */ ,  */
/*                          INPUT "" /* PW Command    */ ).                 */
/*  pldrawn = TRUE.*/
/*END.  /* DO because we have at least one field */*/


PROCEDURE gen-tt-def :
/*------------------------------------------------------------------------------
  Purpose:  Fill up a character parameter with the temp-table definition    
  Parameters:  def-line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER def-line AS CHARACTER                         NO-UNDO.  
  RUN adeuib/_getttdefs.p(RECID(_P), NO, OUTPUT def-line).  
END PROCEDURE.
