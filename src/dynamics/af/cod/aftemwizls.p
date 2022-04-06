/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:        af/cod/aftemwizls.p

  Description: Writes the logic procedure. Called from the XFTR in the SDO
               template when the SDO is saved.

  Purpose:     This file has been depricated, but this stub needs to be here
               to support old SDOs that still reffer to it.  It does nothing. 
  Input Parameters:
      piContextID (integer)  - ContextID of internal XFTR block (_TRG)

  Input-Output Parameters:
      pcCode  (character) - code block of XFTR (body of XFTR)

  History:
  
------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER piContextID AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcCode      AS CHARACTER NO-UNDO.


