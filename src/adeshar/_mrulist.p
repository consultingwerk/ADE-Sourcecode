/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _mrulist.p

Description:
   Updates Most Recently Used File List.  This is called when a file is opened,
   saved or saved as from the AppBuilder  It is also called to adjust the list
   after the preference for the number of entries has changed
      
Input Parameters:
   pcFileName - File name for the file just opened or saved
   pcBrokerURL - Broker URL for remote files
   
   If this is being called to adjust the number of entries, these two parameters
   are blank.
   
Output Parameters:
   <None>

Author:  Tammy Marshall

Date Created: May 4, 1999

Last modified: 
    05/10/99  tsm  Added call to mru_menu so that the AppBuilder menu will 
                   always be updated whenever this procedure is called.
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFileName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcBrokerURL AS CHARACTER NO-UNDO.

{adeuib/sharvars.i}
{adeshar/mrudefs.i}   /* Defines MRU Filelist temp table and shared vars   */

DEFINE TEMP-TABLE mruWork LIKE _mru_files.

DEFINE VARIABLE cTmpFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCount   AS INTEGER   NO-UNDO.

FOR EACH _mru_files USE-INDEX _idx_pos_desc:
  CREATE mruWork.
  BUFFER-COPY _mru_files EXCEPT _position TO mruWork.
  ASSIGN mruWork._position = _mru_files._position + 10.
  DELETE _mru_files.
END.  /* for each _mru_files */

IF pcFileName NE "":U THEN DO:
  /* Local file, so make sure we have the full pathname.  This is important
     if user is editting a SmartObject master, which is stored in the 
     SmartWindow with a relative path. */     
  IF pcBrokerURL = "" THEN DO:
    ASSIGN
      FILE-INFO:FILE-NAME = pcFileName
      cTmpFile            = FILE-INFO:FULL-PATHNAME.
    IF cTmpFile NE ? THEN pcFileName = cTmpFile.
  END.
  
  FIND mruWork WHERE mruWork._file = pcFileName AND
    mruWork._broker = pcBrokerURL NO-ERROR.
  IF AVAILABLE mruWork THEN ASSIGN mruWork._position = 1. 
  ELSE DO:
    CREATE mruWork.
    ASSIGN mruWork._file     = pcFileName
           mruWork._broker   = pcBrokerURL
           mruWork._position = 1.
  END.  /* else do - not avail mruWork */
END.  /* if filename NE "" */

FOR EACH mruWork:
  iCount = iCount + 1.
  IF iCount <= _mru_entries THEN DO:
    CREATE _mru_files.
    ASSIGN _mru_files._position = iCount
           _mru_files._file     = mruWork._file
           _mru_files._broker   = mruWork._broker.
  END.  /* if iCound less than or equal to file list */
  DELETE mruWork.
END.  /* for each mruWork */
    
RUN mru_menu IN _h_UIB.    
    

