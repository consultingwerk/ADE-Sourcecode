/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* workshop/wserrors.i */
&IF FALSE &THEN
/*
*****************************************************
* This include file defines the error messages that 
* workshop/_main.w sends back to the section editor
* and other functions that use the ?command interface.
* These are internal errors and have a negative value.
* They are internal only, and not defined in PROMSGS
*****************************************************
*/
&ENDIF

/* Section Editor requests information about a closed file */
&GLOBAL-DEFINE  File_Closed_Error '-10~~nFile is not open.~~n'

/*-- End of wserrors.i -- */

