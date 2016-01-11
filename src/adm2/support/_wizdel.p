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

/**************************************************************************
    Procedure:  _wizdel.p


    Purpose:    Deletes the wizard for this object upon .W write (XFTR)

    Parameters: recid-trg (INT) - RECID(_TRG)
                trg-Code (CHAR) - code block

    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 3/16/95
**************************************************************************/

DEFINE INPUT        PARAMETER recid-trg AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-Code  AS CHARACTER NO-UNDO.

DEFINE VARIABLE  firstline AS CHARACTER NO-UNDO.
DEFINE VARIABLE  tcode     AS CHARACTER NO-UNDO.
DEFINE VARIABLE  cInfo     AS CHARACTER NO-UNDO.

/* Ask the UIB if the procedure for the current trigger record is in a TEMPLATE */
RUN adeuib/_uibinfo.p (INPUT recid-trg,   /* pi_context: of the code  */
                       INPUT ?,           /* p_name: not needed        */
                       INPUT "TEMPLATE":U,  /* p_request: all proc. id's */
                       OUTPUT cInfo).
/* Is this a TEMPLATE? If so return. */
IF cInfo eq "yes":U THEN RETURN.

ASSIGN
   tcode     = TRIM(trg-code)
   firstline = ENTRY(1,tcode,CHR(10)).

/* If this .W is not the template, change the code block to:
"/* <Wizard Title>
Destroy on next read */":U
 * so that the next time the .W is read in, _wizard.w will delete it
 */
ASSIGN trg-Code = firstline + CHR(10) + "Destroy on next read */":U.

RETURN. 
