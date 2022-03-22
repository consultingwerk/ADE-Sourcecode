/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbconnx.p

Description:
   Dispatch call for tty and gui version of Connect Database dialog box.
   See adecomm/_dbconnc.p and adecomm/_dbconng.w for details.
   
Input Parameters:
   p_Connect - whether the CONNECT should be executed
   
Input/Output Parameters:

   On input:  A value is supplied if known, otherwise, the value is ?
   On output: If connect succeeded, all values are set.  If more than one
              database is connected (via -db parms), the information is
              set for the first one that was connected successfully.
              If connect failed or if the user cancelled, PName and LName 
              are set to ?.
   
   p_PName        - the physical name of the database
   p_LName        - the logical name of the database
   p_Type         - the database type (e.g., PROGRESS, ORACLE) (internal name)
   p_Multi_User   - connect in single user (no) or multi-user (yes) mode
   p_Network      - network type - initial selection only.
   p_Host_Name    - host name
   p_Service_Name - service name
   p_UserId       - user id
   p_Password     - password
   p_Unix_Parms   - any other parms 

Output Parameters:
   p_args   - this is the argument string built for the connect
   
 
Author: Laura Stern and John Palazzo

Date Created: 03/24/92
Modified:
  98/07/16 Mario B. - Added -N -H -S parameters.  Bug# 98-04-19-027.
  
----------------------------------------------------------------------------*/


Define INPUT        parameter p_Connect      as logical   NO-UNDO.
Define INPUT-OUTPUT parameter p_PName        as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_LName        as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Type         as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Multi_User   as logical   NO-UNDO.
Define INPUT-OUTPUT parameter p_Network      as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Host_Name    as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Service_Name as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_UserId       as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Password     as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Trig_Loc     as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Parm_File    as char      NO-UNDO.
Define INPUT-OUTPUT parameter p_Unix_Parms   as char      NO-UNDO.
Define OUTPUT       parameter p_args         as char      NO-UNDO.


/*----------------------------Mainline code----------------------------------*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
RUN adecomm/_dbconnc.p (INPUT p_Connect,   /* whether to connect the database spec'd */
                        INPUT-OUTPUT p_PName,
                        INPUT-OUTPUT p_LName,
                        INPUT-OUTPUT p_Type,
                        INPUT-OUTPUT p_Multi_User,
                        INPUT-OUTPUT p_Network,
                        INPUT-OUTPUT p_Host_Name,
                        INPUT-OUTPUT p_Service_Name,
                        INPUT-OUTPUT p_UserId,
                        INPUT-OUTPUT p_Password,
                        INPUT-OUTPUT p_Trig_Loc,
                        INPUT-OUTPUT p_Parm_File,
                        INPUT-OUTPUT p_Unix_Parms,
                        OUTPUT        p_args  ).
&ELSE
IF SESSION:V6DISPLAY THEN
  RUN adecomm/_dbconnc.p (INPUT p_Connect,   /* whether to connect the database spec'd */
                          INPUT-OUTPUT p_PName,
                          INPUT-OUTPUT p_LName,
                          INPUT-OUTPUT p_Type,
                          INPUT-OUTPUT p_Multi_User,
                          INPUT-OUTPUT p_Network,
                          INPUT-OUTPUT p_Host_Name,
                          INPUT-OUTPUT p_Service_Name,
                          INPUT-OUTPUT p_UserId,
                          INPUT-OUTPUT p_Password,
                          INPUT-OUTPUT p_Trig_Loc,
                          INPUT-OUTPUT p_Parm_File,
                          INPUT-OUTPUT p_Unix_Parms,
                          OUTPUT        p_args  ).
ELSE
  RUN adecomm/_dbconng.w (INPUT p_Connect,   /* whether to connect the database spec'd */
                          INPUT-OUTPUT p_PName,
                          INPUT-OUTPUT p_LName,
                          INPUT-OUTPUT p_Type,
                          INPUT-OUTPUT p_Multi_User,
                          INPUT-OUTPUT p_Network,
                          INPUT-OUTPUT p_Host_Name,
                          INPUT-OUTPUT p_Service_Name,
                          INPUT-OUTPUT p_UserId,
                          INPUT-OUTPUT p_Password,
                          INPUT-OUTPUT p_Trig_Loc,
                          INPUT-OUTPUT p_Parm_File,
                          INPUT-OUTPUT p_Unix_Parms,
                          OUTPUT        p_args  ).

&ENDIF

RETURN.



