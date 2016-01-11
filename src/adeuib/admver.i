/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * File: admver.i
 * Description: returns the ADM version of the handle 
 *  {1} smartobect handle
 *  {2} variable to hold the version valu
 * Created: 02/98 SLK
 */
ASSIGN {2} = dynamic-function("getObjectVersion" IN {1}) NO-ERROR.
IF (ERROR-STATUS:ERROR OR {2} = ? OR {2} = "":U) THEN
  {2} = "ADM1":U.
