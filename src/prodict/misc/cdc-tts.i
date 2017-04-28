/*************************************************************/  
/* Copyright (c) 1984-2016 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
  File: prodict/aud/aud-tts.i

  Description: Include with definitions of common temp-tables used
               in the audit utilities.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kunal Berlia

  Created: October 26, 2016
------------------------------------------------------------------------*/

DEFINE TEMP-TABLE ttPolicy NO-UNDO RCODE-INFORMATION
    FIELD tcPolName  AS CHARACTER FORMAT "x(20)"
    FIELD tcTableName  AS CHARACTER FORMAT "x(20)"
    FIELD tcSchemaName  AS CHARACTER FORMAT "x(20)"
    FIELD tcChangeTblName AS CHARACTER FORMAT "x(25)"
    FIELD tlSelected AS LOGICAL
    FIELD tcPolInstance AS CHARACTER FORMAT "x(15)"
    INDEX idxPolName  IS PRIMARY UNIQUE tcPolName
    INDEX idxSelected tlSelected.

