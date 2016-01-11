/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
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

  Author: Kenneth S. McIntosh

  Created: February 11, 2005
------------------------------------------------------------------------*/

DEFINE TEMP-TABLE ttPolicy NO-UNDO RCODE-INFORMATION
    FIELD tcPolName  AS CHARACTER FORMAT "x(25)"
    FIELD tcPolDesc  AS CHARACTER FORMAT "x(80)"
    FIELD tlSelected AS LOGICAL
    INDEX idxPolName  IS PRIMARY UNIQUE tcPolName
    INDEX idxSelected tlSelected.

DEFINE TEMP-TABLE ttDetail NO-UNDO RCODE-INFORMATION
    FIELD tcDBGuid       AS CHARACTER LABEL "DB Identifier" FORMAT "x(48)"
    FIELD tcDescription  AS CHARACTER LABEL "Description" FORMAT "x(45)"
    FIELD tcCustomDetail AS CHARACTER LABEL "Private-Data" FORMAT "x(45)"
    FIELD tlHasMacKey    AS LOGICAL
    FIELD tlModified     AS LOGICAL
    INDEX tcDBGuid AS PRIMARY UNIQUE tcDBGuid.

