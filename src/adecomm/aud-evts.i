/*************************************************************/
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/aud-evts.i

  Description: Defines lists of numbers that pertain to specific types
               of recorded audit data.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: June 9,2005
  
  History:
     fernando  12/23/08  Support for encryption events
     
------------------------------------------------------------------------*/

&GLOBAL-DEFINE AUD_POL_MNT  300-302,10010,10303-10304
&GLOBAL-DEFINE SCH_CHGS     5000-5041
&GLOBAL-DEFINE AUD_ARCHV    10300-10302
&GLOBAL-DEFINE DATA_ADMIN   10213-10214
&GLOBAL-DEFINE USER_MAINT   100-102
&GLOBAL-DEFINE SEC_PERM_MNT 510-517,10305
&GLOBAL-DEFINE DBA_MAINT    210-212,400-422
&GLOBAL-DEFINE AUTH_SYS     500-507
&GLOBAL-DEFINE DB_ADMIN     10100-10212,10000-10001
&GLOBAL-DEFINE DB_ACCESS    10500-10611
&GLOBAL-DEFINE ENC_POL_MNT  11400-11402,11500-11502,11600-11602
&GLOBAL-DEFINE ENC_KEY_MNT  11100-11114,11200-11207
&GLOBAL-DEFINE ENC_ADMIN    11000,11001,11300,11301
