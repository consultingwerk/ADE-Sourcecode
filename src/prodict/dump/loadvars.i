/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* loadvars.i

Author: Kenneth S. McIntosh

Created: May 10, 2005

Purpose:
    Defines common streams/variables for load routines

Preconditions:    

Text Parameters:
    
Included in:
  prodict/dump/_lodsec.p    
  
History:
  fernando    11/10/2005    Adding streams for _db-detail and _client-session 20051110-020
*/

DEFINE {1} STREAM loadPol.
DEFINE {1} STREAM loadEvtPol.
DEFINE {1} STREAM loadFldPol.
DEFINE {1} STREAM loadFilPol.
DEFINE {1} STREAM loadAudD.
DEFINE {1} STREAM loadAudDVal.
DEFINE {1} STREAM loadCliSess.
DEFINE {1} STREAM loadDbDet.

