/*------------------------------------------------------------------------
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

  File: prodict/misc/misc-funcs.i

  Description: Miscellaneous functions for use with database admin 
               tools

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 19, 2005

  History: kmcintos May 26, 2005 Changed feature codes in featureEnabled
                                 bug # 20050525-025.
------------------------------------------------------------------------*/

FUNCTION generateGuid RETURNS CHARACTER ():
/*------------------------------------------------------------------------------
  Purpose:  Returns a new GUID value using the GENERATE-UUID function.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cGuid      AS CHARACTER   NO-UNDO.

  cGuid = SUBSTRING(BASE64-ENCODE(GENERATE-UUID),1,22).
  
  RETURN cGuid.
END FUNCTION.

FUNCTION featureEnabled RETURNS LOGICAL
    ( INPUT pcFeature AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Returns whether a particular feature is installed or enabled.
Parameters: INPUT pcFeature - Name, or number of the feature 
    Notes:  This function has a predefined set of rules to determine if 
            a feature is installed or enabled.
            
            Features:   "1"     =    Check to see if any auditing tables exist
                                     in the database.
                        "2"     =    Check to see if any security tables exist
                                     in the database.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hFile  AS HANDLE      NO-UNDO.

  DEFINE VARIABLE lFound AS LOGICAL     NO-UNDO.

  CREATE BUFFER hFile FOR TABLE "DICTDB._file".

  CASE pcFeature:
    WHEN "1" THEN
      lFound = hFile:FIND-FIRST("WHERE _file._file-name BEGINS ~'_aud~'",NO-LOCK) NO-ERROR.
    WHEN "2" THEN
      lFound = hFile:FIND-FIRST("WHERE _file._file-name BEGINS ~'_sec~'",NO-LOCK) NO-ERROR.
    OTHERWISE
      lFound = hFile:FIND-FIRST("WHERE _file._file-name BEGINS ~'" + 
                                pcFeature + "~'",NO-LOCK) NO-ERROR.
  END CASE.
  RETURN lFound.
END FUNCTION.

FUNCTION canRun RETURNS LOGICAL
    ( INPUT pcFeature AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Returns whether the user can access a feature.
Parameters: INPUT pcFeature - Name, or number of the feature 
    Notes:  This function has a predefined set of rules to determine if 
            the connected user has permission to access a perticular feature.
            
            Features:   "No features implemented yet"
------------------------------------------------------------------------------*/
  RETURN TRUE.
END FUNCTION.

FUNCTION dbAdmin RETURNS LOGICAL
    ( INPUT pcUser AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  Returns whether the user (pcUser) is a database administrator or not.
Parameters: INPUT pcUser - Userid of the user to check
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOk AS LOGICAL     NO-UNDO.

  RUN prodict/_dctadmn.p ( INPUT USERID("DICTDB"),
                           OUTPUT lOk ).

  RETURN lOk.
END FUNCTION.
