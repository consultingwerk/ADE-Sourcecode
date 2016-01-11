/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* used by _aud-utils.p */
&GLOBAL-DEFINE APPSRV-MODE  "APPSERVER":U

/* DB PROPERTIES RETURNED BY THE AUDIT UTILS PROCEDURE */
&GLOBAL-DEFINE DB-APPSERVER {&APPSRV-MODE}
&GLOBAL-DEFINE DB-READ-ONLY "READ-ONLY":U
&GLOBAL-DEFINE AUDIT-ADMIN  "_sys.audit.admin":U

&GLOBAL-DEFINE NOT-WEBCLIENT SESSION:CLIENT-TYPE <> "WEBCLIENT":U


/* used for the conflict management stuff */

/* will use this value when event is OFF */
&GLOBAL-DEFINE EVENT-OFF               -99

/* will use this value when event id is different accross different policies */
&GLOBAL-DEFINE MULTIPLE-VALUES         -98

/* use this value when field setting is ignored because event at table level is off */
&GLOBAL-DEFINE FIELD-SETTING-IGNORED   -97

/* use this value when multiple identifying fields have the same identifying value after we
   aggregated the active policies
*/
&GLOBAL-DEFINE IDENTIFYING-CONFLICT   -96
