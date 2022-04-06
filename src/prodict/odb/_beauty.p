/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/odb/_beauty.p

Description:
    wrapper to odb/_odb_fix.p, which fix-up a SI to match an original
    PROGRESS-DB
    

Input-Parameters:
    none

Output-Parameters:
    none
    
History:
    96/06   hutegger    created

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/odb/odbvar.i NEW }
{ prodict/gate/beauty.i
  &edb-type = "ODBC"
  }

/*--------------------------------------------------------------------*/
