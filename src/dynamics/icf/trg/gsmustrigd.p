/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsm_user.

{af/sup/aftrigtopd.i}

/* Trigger filename = gsmustrigd.p */

DEFINE BUFFER o_gsm_user FOR gsm_user.
/* Customisations to DELETE trigger */
{icf/trg/gsmustrigd.i}

{af/sup/aftrigendd.i}
