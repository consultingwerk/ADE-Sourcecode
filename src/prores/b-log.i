/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-log.i - display message to log file */

PUT UNFORMATTED {&stream} STRING(TIME,"HH:MM:SS") " " {&text} SKIP.
