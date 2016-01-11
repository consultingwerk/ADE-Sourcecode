/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* rmseqrvdata.p
   Removes the sequence record versioning data from the repository */

DISABLE TRIGGERS FOR LOAD OF gst_record_version.
DISABLE TRIGGERS FOR LOAD OF gst_release_version.
FOR EACH gst_record_version 
    WHERE gst_record_version.entity_mnemonic = "GSCSQ":
    FOR EACH gst_release_version
        WHERE gst_release_version.record_version_obj = gst_record_version.record_version_obj:
        DELETE gst_release_version.
    END.
    DELETE gst_record_version.
END.

