/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* row-end.i */
IF VALID-HANDLE (adm-object-hdl) THEN  /* If there's a Frame, etc. then */
    RUN dispatch IN THIS-PROCEDURE ('display-fields':U). /* display the fields*/
&IF DEFINED(adm-open-query) NE 0 &THEN      
  /* If there were external tables, then we check for different rows.
     If there is a KEY-NAME defined then always open the query. */
  IF key-name ne ? OR different-row
  THEN RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  ELSE RUN notify IN THIS-PROCEDURE('row-available':U).
&ELSE              /* Note: open-query does its own notify of row-available */
RUN notify IN THIS-PROCEDURE ('row-available':U).
&ENDIF
