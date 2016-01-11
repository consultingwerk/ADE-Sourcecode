/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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


