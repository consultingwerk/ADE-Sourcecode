/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
