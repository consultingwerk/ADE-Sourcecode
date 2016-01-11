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
    Procedure:  _osfext.p
    
    Purpose:    Returns the file name extension of an operating system
                file including the dot (.). If the file does not have
                an extension, returns Null ("").
                
    Syntax :
    
        RUN adecomm/_osfext.p
                (INPUT  p_File_Name  /* OS File Name.   */ ,
                 OUTPUT p_File_Ext   /* File Extension. */ ).

    Parameters:
    
    p_File_Name 
        Name of OS file whose extension you want.
    
    p_File_Ext 
        File name extension including the dot (.). Null is returned
        if the file has no extension.

    Description:
    
    Notes  :
    Authors: John Palazzo
    Date   : April, 1995
    Updated: 
**************************************************************************/

DEFINE INPUT  PARAMETER p_File_Name AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_File_Ext  AS CHARACTER NO-UNDO.

/*
DEFINE VARIABLE p_File_Name AS CHARACTER NO-UNDO.
DEFINE VARIABLE p_File_Ext  AS CHARACTER NO-UNDO.

ASSIGN p_File_Name = "../dir.win/file.w":U.
*/

IF INDEX(p_File_Name,".") EQ 0 THEN RETURN. /* no extension */

ASSIGN p_File_Ext =
       IF ( LENGTH( p_File_Name , "CHARACTER" ) > 1 )
       THEN "." + ENTRY( NUM-ENTRIES( p_File_Name , "." ) ,
                         p_File_Name , "." )
       ELSE "" .

/*
MESSAGE "File     : " p_File_Name SKIP
        "Extension: " p_File_Ext
        VIEW-AS ALERT-BOX IN WINDOW ACTIVE-WINDOW.
*/





