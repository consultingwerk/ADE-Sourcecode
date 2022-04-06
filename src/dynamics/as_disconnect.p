/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* as_disconnect.p */

/* pull in Astra global variables as new global */
{af/sup2/afglobals.i NEW GLOBAL}

/* get rid of session profile records */
RUN deleteSessionProfile IN gshProfileManager.

/* get rid of session context records */
RUN deleteActiveSession IN gshSessionManager.





