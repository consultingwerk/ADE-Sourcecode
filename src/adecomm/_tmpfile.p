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
/*----------------------------------------------------------------------------

File: _tmpfile.p

Description:
	 Creates an available temp file name. The name is a complete
	 name that includes the path.

Input Parameters: 
	 
	 user_chars:   Characters that can be used to distinguish a temp
				 file from another temp file in the same application.
				 
	 extension:    The file extension that is to be added to the file,
						including the "."
	 
Output Parameters:
	
	 name:         The name of the file

Author: D. Lee

Date Created: 1993

----------------------------------------------------------------------------*/

define input  parameter user_chars as character no-undo.
define input  parameter extension  as character no-undo.
define output parameter name       as character no-undo.

define var base           as integer.
define var check_name     as character.

/*
 * Loop until we find a name that hasn't been used. In theory, if the
 * temp directory gets filled, this could be an infinite loop. But, the
 * likelihood of that is low.
 */
check_name = "something".
 
do while check_name <> ?:
  /* Take the lowest 5 digits (change the format so that everything works out to have exactly 5
     characters. */
  ASSIGN
    base = ( TIME * 1000 + ETIME ) MODULO 100000
    name = STRING(base,"99999":U).
  
  /* Add in the extension and directory into the name. */
  name = SESSION:TEMP-DIR + "p" + name + user_chars + extension.

  check_name = SEARCH(name).
END.

/* _tmpfile.p - end of file */

