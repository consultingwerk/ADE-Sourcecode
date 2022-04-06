/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

