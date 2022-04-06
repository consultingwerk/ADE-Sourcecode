%If(%Or(%==(%DiagramProp("DBlogical"),"ASDB"),%==(%DiagramProp("DBlogical"),"AFDB"))) {
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
}
%If(%Or(%==(%DiagramProp("DBlogical"),"RYDB"),%==(%DiagramProp("DBlogical"),"GSDB"))) {
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
}
%If(%Or(%==(%DiagramProp("DBlogical"),"ICFDB"),%==(%DiagramProp("DBlogical"),"RVDB"))) {
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
}

TRIGGER PROCEDURE FOR DELETE OF %TableName.

{af/sup/aftrigtopd.i}

/* Trigger filename = %TriggerName.p */

/* Cannot delete at all ! */
ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 105 lv-include = "%TableName":U.
RUN error-message (lv-errgrp, lv-errnum, lv-include).

{af/sup/aftrigendd.i}
