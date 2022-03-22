/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/ora/_beauty.p

Description:
    wrapper to ora/_ora_fix.p, which fixes-up an SI to match an original
    PROGRESS-DB

Input-Parameters:
    none

Output-Parameters:
    none
    
History:
    96/06   hutegger    created

                            
--------------------------------------------------------------------*/
/*h-*/

/*------------------------  INITIALIZATIONS  -----------------------*/

{ prodict/gate/beauty.i
    &edb-type = "ORACLE"
    }.

/*--------------------------------------------------------------------*/
