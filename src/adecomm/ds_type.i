/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: adecomm/ds_type.i

Usage:
    <int-type> = {adecomm/ds_type.i
                     &direction = "itoe"
                     &from-type = "ixt-type"
                     }
    <ext-type> = {adecomm/ds_type.i
                     &direction = "etoi"
                     &from-type = "int-type"
                     }

Description:   
    Function to convert internal to external db-type
    the result is the converted db-type         OR
    supply the list of all internal or external db-types
            
call:
    
Text-Parameters:
    &direction      "etoi"  (external to internal)      OR
                    "etype" (list of external types)    OR
                    "itoe"  (internal to external)      OR
                    "itype" (list of internal types)    OR
                    "ODBC"  (list of internal ODBC-types)
    &from-type      db-type to be converted             OR
                    dummy-variable

Included in:
    adecomm/_dbconnx.p
    prodict/user/usermenu.i
        
Author: Tom Hutegger

History:
    mcmann      00/03/20    Added MSS
    mcmann      99/03/25    Changed direction = odbc to contain proper ones and added
                            MSSQLSRV to others
    pittman     96/06/05    added DB2-DRDA as new ODBC-based DS
    hutegger    95/11/16    added MSSQLSRV as new ODBC-based DS
    pittman     95/05/xx    added DB2      as new ODBC-based DS
    hutegger    94/07/25    extented with "itype" and "etype"
    hutegger    94/05/18    creation
    
--------------------------------------------------------------------*/ 
/*h-*/

/*------------------------------------------------------------------*/ 
/* NOTE: all lists have to be in the same order and all sets in sync! */
      
IF      "{&direction}" = "etoi"
 THEN ENTRY(LOOKUP({&from-type},
/* list of all external names */
    "AS/400,MSS,ODBC,ORACLE,PROGRESS"),
/* list of all internal names */
    "AS400,MSS,ODBC,ORACLE,PROGRESS")

ELSE IF "{&direction}" = "itoe"
 THEN ENTRY(LOOKUP({&from-type},
/* list of all internal names */
    "AS400,MSS,ODBC,ORACLE,PROGRESS"),
/* list of all external names */
    "AS/400,MSS,ODBC,ORACLE,PROGRESS")

ELSE IF "{&direction}" = "odbc"
 THEN /* list of all ODBC-DataServers (internal names) */
    "MSS,ODBC"


ELSE IF "{&direction}" = "itype"
 THEN /* list of all internal names */
    "AS400,MSS,ODBC,ORACLE,PROGRESS"

 ELSE /* list of all external names */
    "AS/400,MSS,ODBC,ORACLE,PROGRESS"

/*------------------------------------------------------------------*/
      


