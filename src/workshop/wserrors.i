/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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

