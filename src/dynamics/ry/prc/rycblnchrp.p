/* Copyright (C) 2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: rycblnchrp.p

  Description:  Wrapper: Launch new Container Builder

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/29/2002  Author:     Chris Koster

  Update Notes: Created from Template rytemprocp.p
                Created from Template rycblnchrp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pPrecid AS RECID      NO-UNDO.

{src/adm2/globals.i}

def var hPropSht as handle no-undo.
def var cButtonPressed as character no-undo.

run showMessages in gshSessionManager ({aferrortxt.i 'AF' '40' '?' '?' '"This procedure (ry/prc/rycblnchrp.p) has been deprecated. Please report any occurrences of this message to Tech Support"'},
                                       'INF',
                                       '&Ok',
                                       '&Ok',
                                       '&Ok',
                                       'Deprecated procedure',
                                       Yes,
                                       ?,
                                       output cButtonPressed) no-error.

/* Run this persistent and then die. This is just a stub used to launch the adeuib file. */
run adeuib/_contbldrprop.p persistent set hPropSht (input pPrecid).

/* Pass through the call from adeuib/_proprty.p, so that 
   _contbldrprop.p can register itself as the property sheet,
   instead of this procedure, which is just a wrapper. 
   
   Note that the initializeObject call in _contbldrprop.p
   kills off this procedure, since it is started persistently
   and has not raison d'etre after launching _contbldrprop.p,
   and so must die. Bwahahahaha. */
procedure initializeObject:
    run initializeObject in hPropSht no-error.
end procedure.
