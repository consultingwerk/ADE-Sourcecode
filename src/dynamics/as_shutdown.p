/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* as_shutdown.p */

/* pull in Astra global variables as new global */
{src/adm2/globals.i}

RUN sessionShutdown IN THIS-PROCEDURE. /* runs in the config file manager. */
