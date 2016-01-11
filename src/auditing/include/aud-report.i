/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* temp-table used to return the information on conflicts or
   effective policy settings. Used by _aud-conflict.p
*/

DEFINE TEMP-TABLE ttAudReport NO-UNDO
    FIELD cType            AS CHARACTER /* type of entry: EVENT,FILE,FIELD */
    FIELD cId              AS CHARACTER /* name or id of event,table,field,policy */
    FIELD cPolicies        AS CHARACTER /* list of policy names where settings were found*/
    FIELD level-1          AS INTEGER
    FIELD level-2          AS INTEGER
    FIELD level-3          AS INTEGER
    FIELD cFieldList       AS CHARACTER /* comma-delimited list of fields with conflict */
    FIELD cData            AS CHARACTER /* comma-delimited list of other pieces of information */
    .
