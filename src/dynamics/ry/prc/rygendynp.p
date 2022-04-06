/* Copyright (C) 1984-2007 by Progress Software Corporation. All rights
   reserved. Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: ry/prc/rygendynp.p

  Description:  Guts of code moved to adeuib/_gendyn.p
    
  NOTE:         This file should always be called so that customers can
                continue to use their customisations. They'd need to replace
                this file with their customised version of rygendyn.p.

  Parameters:   INPUT  gprPrecid  - the Recid of the _P record to write
                OUTPUT gpcError   - Error message if object can't be written
                OUTPUT gpcAssocError - Error message if associated object does
                                       not compile
---------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER gprPrecid           AS RECID      NO-UNDO.
 DEFINE OUTPUT PARAMETER gpcError            AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER gpcAssocError       AS CHARACTER  NO-UNDO.

/* Entire code moved to adeuib/_gendyn.p , which is where it belongs. */
run adeuib/_gendyn.p (gprPrecid, output gpcError, output gpcAssocError).

/** EOF **/
