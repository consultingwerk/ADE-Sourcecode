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

/**************************************************************************
    Procedure:  _oscpath.p
    
    Purpose:   Creates a path (i.e. it's careful to create all the dir 
	down a path) THIS IS ONLY FOR MS WINDOWS!!!!
                
    Syntax :
        RUN adecomm/_oscpath.p
                (INPUT  p_path  /* OS Path File Name.   */ ,
                 OUTPUT p_errcode   /* Success */ ).

    Parameters:
    
    p_path 
        Name of OS file whose full path you want to create 
    p_errcode 

    Description:
    
    Notes  :
    Authors: 
    Date   : 
    Updated: 
**************************************************************************/

DEFINE INPUT  PARAMETER p_path AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_errcode  AS INTEGER INITIAL 0 NO-UNDO.

DEFINE VARIABLE i AS INTEGER                        NO-UNDO.
DEFINE VARIABLE pos AS INTEGER                        NO-UNDO.
DEFINE VARIABLE tmp AS CHARACTER                      NO-UNDO.

ASSIGN p_path = REPLACE(p_path,"/","~\").
IF SUBSTRING(p_path,LENGTH(p_path),1,"CHARACTER":U) NE "~\":U THEN
    ASSIGN p_path = p_path + "~\":U.
    
/* WIN95-UNC - Check for UNC \\SERVER\SHARE and treat it like a 
   drive specification. In which case, there is no basename and the prefix
   is the UNC and drive spec. -*/
IF CAN-DO("OS2,WIN32,MSDOS,UNIX":U,OPSYS) THEN DO:
      IF p_path BEGINS "~\~\" 
	AND NUM-ENTRIES(p_path,"~\") > 4 THEN
	/* start creating the dir at the 5 slashes down */
      DO: 
	ASSIGN pos = index(p_path,"~\":U).
	DO i = 1 to 3:
	   ASSIGN pos = index(p_path,"~\":U,pos + 1).
        END.
      END.
      ELSE
	ASSIGN pos = index(p_path,"~\":U).
END.

DO WHILE pos <> 0:  
    ASSIGN tmp = SUBSTRING(p_path,1,pos).
    OS-CREATE-DIR VALUE(tmp).
    IF OS-ERROR <> 0 THEN DO:
      ASSIGN p_errcode = OS-ERROR.
      RETURN.
    END.
    ASSIGN pos = index(p_path,"~\":U,pos + 1).
END.
