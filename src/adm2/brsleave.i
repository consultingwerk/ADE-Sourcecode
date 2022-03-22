/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* All code moved from here to rowLeave() in adm2/browser.p
 */
run rowLeave in target-procedure.
if return-value eq 'adm-error' then
    return no-apply.
