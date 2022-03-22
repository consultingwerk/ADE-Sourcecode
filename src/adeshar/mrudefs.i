/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
        

