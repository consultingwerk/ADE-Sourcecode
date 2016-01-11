/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : Lookup dialog call for Dynamics procedure when a lookup 
                  button is choosen
    Purpose     :
    Description :
    Notes       :
  ----------------------------------------------------------------------*/  
DEFINE INPUT  PARAMETER phWindow           AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcClassList        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModule    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plOpenInAppBuilder AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pcTitle            AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcPathedFileName   AS CHARACTER NO-UNDO . 

{src/adm2/globals.i}

/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}
 
 DEFINE VARIABLE cFilename          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOK                AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRepDesManager     AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cCalcRelativePath  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRootDir       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcRelPathSCM    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFullPath      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcObject        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcFile          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCalcError         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iClass             AS INTEGER    NO-UNDO.

 RUN adeuib/_opendialog.w (INPUT phWindow,
                           INPUT pcProductModule,
                           INPUT plOpenInAppBuilder,
                           INPUT pcTitle,
                           OUTPUT cFilename,
                           OUTPUT lOk).
 IF lOK THEN
 DO:
    hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
    /* Retrieve the objects and instances for the current existing object opened in the appBuilder */
    RUN retrieveDesignObject IN hRepDesManager ( INPUT  cFilename,
                                                 INPUT  "",  /* Get default result Code */
                                                 OUTPUT TABLE ttObject ,
                                                 OUTPUT TABLE ttPage,
                                                 OUTPUT TABLE ttLink,
                                                 OUTPUT TABLE ttUiEvent,
                                                 OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
    FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = cFilename 
                          AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
    IF AVAIL ttObject THEN
    DO:
       /* Get relative directory of specified object */ 
       RUN calculateObjectPaths IN gshRepositoryManager
                          (cFilename,  /* ObjectName */          0.0, /* Object Obj */      
                           "",  /* Object Type */         "",  /* Product Module Code */
                           "", /* Param */                "",
                           OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                           OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                           OUTPUT cCalcObject,            OUTPUT cCalcFile,
                           OUTPUT cCalcError).
       IF cCalcRelPathSCM > "" THEN
          cCalcRelativePath = cCalcRelPathSCM.
       ASSIGN pcPathedFilename = cCalcRelativePath + (IF cCalcRelativePath = "" then "" ELSE "/":U )
                                                    + cCalcFile .
       /*
       IF DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassname, "Procedure":U) THEN

          ASSIGN    h_CUSTOM-SUPER-PROC:SCREEN-VALUE = cPathedFilename
                    h_CUSTOM-SUPER-PROC:MODIFIED     = YES.
       */             
    END.
 END.

