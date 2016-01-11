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
/* 
 * Filename: undsmar.i
 * Description:  include file with code originally in undsmar.p
 *   this file is shared by undsmar.p as well as _setpntr.p and uibmproa.i
 *   _setpntr.p determines what the pointer should look like when the user
 *        attempts to drop an object unto a window
 *   uibmproe.i uses to determine if you can drop an object onto a window
 *
 * There are some errors in a run that we want to trap.  For example,
 * running code that requires database connections when there are
 * none connected or when not all required databases are connected
 * will raise a STOP condition. Assume that is the most likely case
 * and give the user the chance to connect to a database. Do this
 * regardless of whether the object is rcode or soure code. Part of the
 * fix for 98-12-28-020.
 *
 * Included by: _undsmar.p
 *              sookver.i (which in turn is included in uibmproa.i and _setpntr.p
 *
 * Created: 02/98 SLK
 * Updated: 01/99 JEP 98-12-28-020
 * Parameters {1} - File to run - Character 
              {2} - Handle to set when started 
              {3} - Message to display when not found - character 
              {4} - Variable to set to true when remote 
                    Currently also used to conditionally compile, 
                    because _setpntr.p don't need to support remote 
                    and does not have the _h_func vasriable defined    
 */

  /* Run and initialize the SmartObject. */ 
  RUN-BLOCK:
  DO ON STOP  UNDO RUN-BLOCK, RETRY RUN-BLOCK 
     ON ERROR UNDO RUN-BLOCK, RETRY RUN-BLOCK:
    IF RETRY THEN DO:

      /* Reset the wait cursor. */ 
      RUN adecomm/_setcurs.p ("").          
      MESSAGE "Would you like to connect to a database and try instantiating " +  {1} + " again?"
          VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOK.
      IF lOK THEN DO:
        /* If the second element of the error message is "Database" then the
           third element is the name. Assume a PROGRESS database. */
        ASSIGN Db_Pname = ""
               Db_Lname = ?
               Db_Type  = "PROGRESS".
        RUN adecomm/_dbconn.p
           (INPUT-OUTPUT  Db_Pname,
            INPUT-OUTPUT  Db_Lname,
            INPUT-OUTPUT  Db_Type).
        /* Was a new database connected? Check the Logical name. */
        IF Db_Lname eq ? THEN DO:
          lOK = no.
          MESSAGE "No database was connected. The SmartObject cannot be instantiated. " {&SKP} "{3}"
                  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        END. 
      END.  
      /* Is it OK to continue? */
      IF NOT lOK THEN LEAVE RUN-BLOCK.    
    END. /* IF RETRY... */

    /* Run now. This might take awhile. */ 
    RUN adecomm/_setcurs.p ("WAIT").
          
             
         &IF '{4}' <> '' &THEN
       
    /* If this is the dataSource in a object (ie HTML mapping)
       we must start the SDO with the special sdo function */   
    IF  VALID-HANDLE(_P._tv-proc) 
    AND (_P._data-object = {1} OR
         _P._data-object = ""      ) THEN
    DO:
      {2} = DYNAMIC-FUNCTION("get-sdo-hdl":U IN _h_func_lib,
                             {1},
                             _P._tv-proc).    
    
      /* remote "pretender" must be initialized */
      IF VALID-HANDLE({2}) AND {2}:FILE-NAME = "web2/support/_rmtsdo.p" THEN
      DO:
         RUN initializeObject IN {2}. 
         {4} = TRUE.
      END.
    END.
    
    ELSE    
       &ENDIF
    
      RUN VALUE({1}) PERSISTENT SET {2}.
    
    RUN adecomm/_setcurs.p ("").          
  END. /* RUN-BLOCK: DO... */

