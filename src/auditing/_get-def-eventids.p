/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : _get-def-eventids.p
    Purpose     : Return the default event ids depending on the table name
                  

    Syntax      : 

    Description : This follows the list of pre-defined events for the different
                  types of tables you can turn on auditing on.
    
    Parameters:  INPUT  pcTableName - the table name
                 OUTPUT pcIds       - a comma-separated list of event-ids
                                      in the following order: create,update,delete.


    Author(s)   : Fernando de Souza
    Created     : Mar 09,2005
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* paremeter definitions */
DEFINE INPUT  PARAMETER pcTableName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcIds       AS CHARACTER NO-UNDO.


/* Main Block */
  
CASE pcTableName:
      WHEN "_User":U THEN
          pcIds = "100,101,102":U.

      /* audit-admin ??
         WHEN "":U THEN
          pcIds = "200,201,202":U.
          */

      WHEN "_sysdbauth":U THEN
          pcIds = "210,211,212":U.

      WHEN "_aud-audit-policy":U OR WHEN "_aud-file-policy":U OR 
          WHEN "_aud-field-policy":U OR WHEN "_aud-event-policy":U
          THEN
          pcIds = "300,301,302":U.

      WHEN "_systabauth":U THEN
          pcIds = "400,401,402":U.

      WHEN "_syscolauth":U THEN
          pcIds = "410,411,412":U.

      WHEN "_sysseqauth":U THEN
          pcIds = "420,421,422":U.

      WHEN "_sec-authentication-system":U THEN
          pcIds = "500,501,502":U.
 
      WHEN "_sec-authentication-domain":U THEN
          pcIds = "505,506,507":U.

      WHEN "_sec-role":U THEN
          pcIds = "510,511,512":U.

      WHEN "_sec-granted-role":U THEN
          pcIds = "515,516,517":U.

     /*WHEN "_sec-granted-role-condition":U THEN
        pcIds = "":U.
        */

      WHEN "_File":U THEN
          pcIds = "5000,5010,5020":U.

      WHEN "_File-trig":U THEN
          pcIds = "5001,5011,5021":U.

      WHEN "_Field":U THEN
          pcIds = "5002,5012,5022":U.

      WHEN "_Field-trig":U THEN
          pcIds = "5003,5013,5023":U.

      WHEN "_Index":U THEN
          pcIds = "5004,5014,5024":U.

      WHEN "_Index-Field":U THEN
          pcIds = "5005,5015,5025":U.

      WHEN "_sequence":U THEN
          pcIds = "5030,5031,5032":U.

      WHEN "_db-detail":U THEN
          pcIds = "5040,5041,0":U.

      WHEN "_db":U OR WHEN "_db-option":U THEN
          pcIds = "0,5041,0":U.

      OTHERWISE
          pcIds = "5100,5101,5102":U.

  END CASE.

RETURN.
