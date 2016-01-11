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

File: adeshar/mrudefs.i

Description:
    Include file that contains the temp table definition for maintaining the 
    most recently used file lists in the AppBuilder and Procedure Editor
    
Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Tammy Marshall

Date Created: May 5, 1999

Modified: 
    05/10/99  tsm  Made _mru_files new global shared so that it could be 
                   accessed from procedure window when saving new
                   unstructured web objects created from the AppBuilder
----------------------------------------------------------------------------*/

/*    Temp-table used to store the internally maintained list of 
      most recently used files */
DEFINE NEW GLOBAL SHARED TEMP-TABLE _mru_files                             NO-UNDO
    FIELD _file                 AS CHARACTER
    FIELD _broker               AS CHARACTER
    FIELD _position             AS INTEGER
    INDEX _idx_position 
        IS UNIQUE PRIMARY
        _position ASCENDING
    INDEX  _idx_pos_desc
        IS UNIQUE
        _position DESCENDING
    INDEX _idx_filebroker
        IS UNIQUE
        _file ASCENDING
        _broker ASCENDING.
        

