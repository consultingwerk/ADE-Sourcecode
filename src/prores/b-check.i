/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-check.i - write out checkpoint file */

/*Writing checkpoint file...*/
STATUS DEFAULT qbf-lang[18].
OUTPUT TO VALUE(qbf-qcfile + ".qc") NO-ECHO.
PUT UNFORMATTED
  '/*' SKIP
  '# PROGRESS RESULTS checkpoint file' SKIP
  'config= checkpoint' SKIP
  'version= ' qbf-vers SKIP.
FOR EACH qbf-form:
  PUT CONTROL 'file' qbf-form.iIndex '= '.
  EXPORT qbf-form.cValue qbf-form.cDesc qbf-form.xValue.
END.
PUT UNFORMATTED
  'mode= ' ENTRY(qbf-a,"manual,semi,auto") SKIP
  '*/' SKIP.
OUTPUT CLOSE.
