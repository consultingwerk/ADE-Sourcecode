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
/*-----------------------------------------------------------------------------
  File: _admpset.p
    
  Description: Sets the _P record "correctly" according to its type.  That is
               there are a number of settings that are in the stock ADM 
               SmartObject types.  Set the _P record based on the type.

  Input Parameters:
      p_Precid - The recid of the procedure object to access.

  Output Parameters:
    <none>

  Author: Wm. T. Wood

  Created: Feb. 1995
           May 9 - jrs - added Query,DB-Fields,Browse to SmartFrame
-----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  p_Precid AS RECID  NO-UNDO.

/* Include Files. */
{adeuib/uniwidg.i}   /* Definition of Universal Widget  */

FIND _P WHERE RECID(_P) eq p_Precid.

/* Define SmartContainer common link settings. */
IF _P._adm-version < "ADM2" AND 
   CAN-DO ("SmartDialog,SmartFrame,SmartWindow":U, _P._TYPE) THEN
  _P._links = "Record-Source,Record-Target,Navigation-Source,Navigation-Target," +
              "TableIO-Source,TableIO-Target,Page-Target".

/* Look at the type */
CASE _P._TYPE:

  /* Smart Containers: Note that the default LINKS are defined above.  */
  WHEN "SmartWindow":U THEN
    ASSIGN
      _P._add-fields       = "FRAME-QUERY"
      _P._allow            = "Basic,Browse,DB-Fields,Query,Smart,Window"
      _P._max-frame-count  = ?
      _P._persistent-only  = no
      _P._file-type        = "w"
      .  
  WHEN "SmartDialog":U THEN
    ASSIGN
      _P._add-fields       = "FRAME-QUERY"
      _P._allow            = "Basic,Browse,DB-Fields,Query,Smart"
      _P._max-frame-count  = ?
      _P._persistent-only  = no
      .   
  WHEN "SmartFrame":U THEN
    ASSIGN
      _P._add-fields       = "FRAME-QUERY"
      _P._allow            = "Basic,Browse,DB-Fields,Query,Smart"
      _P._max-frame-count  = ?
      _P._persistent-only  = yes
      _P._file-type        = "w"
      .  
  
  /* Smart Objects */ 
  WHEN "SmartBrowser":U THEN 
    ASSIGN
      _P._add-fields       = "EXTERNAL-TABLES"
      _P._allow            = "Basic,Browse"
      _P._links            = "Record-Source,Record-Target,TableIO-Target"
      _P._max-frame-count  = 1
      _P._persistent-only  = yes
      _P._file-type        = "w"
      .    
  WHEN "SmartFolder":U THEN 
    ASSIGN
      _P._add-fields       = "NEITHER"
      _P._allow            = "Basic"
      _P._links            = "Page-Source"
      _P._max-frame-count  = 1
      _P._persistent-only  = yes
      _P._file-type        = "w"
      .    
  WHEN "SmartPanel":U THEN 
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       Note that we do NOT reset the links supported (because some panels
       want JUST a TableIO-Target and some want a Navigation-Target, and
       some want both. 
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    ASSIGN
      _P._add-fields       = "NEITHER"
      _P._allow            = "Basic"
      _P._max-frame-count  = 1
      _P._persistent-only  = yes
      _P._file-type        = "w"
      .    
  WHEN "SmartQuery":U THEN 
    ASSIGN
      _P._add-fields       = "NEITHER"
      _P._allow            = "Basic,Query"
      _P._links            = "Record-Source,Record-Target,Navigation-Target"
      _P._max-frame-count  = 1
      _P._persistent-only  = yes
      _P._file-type        = "w"
      .    
  WHEN "SmartViewer":U THEN 
    ASSIGN
      _P._add-fields       = "EXTERNAL-TABLES"
      _P._allow            = "Basic,DB-Fields"
      _P._links            = "Record-Source,Record-Target,TableIO-Target"
      _P._max-frame-count  = 1
      _P._persistent-only  = yes
      _P._file-type        = "w"
      .
      
  OTHERWISE /* Do nothing...leave settings unknown */
     RETURN.
END CASE.

