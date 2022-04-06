/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mwo1o.i
 *
 *   This file works around a problem with mulitple spaces at the end
 *   of a string that differentiate the string.
 *
 *   This does the opposite of _mwo1.i
 *
 *   This file must be included after {_mnudefs.i}
 */

IF INDEX({&labl},{&mnuSepFeature}) > 0 THEN DO:

    define variable baseName as character no-undo.
    define variable extName  as character no-undo.
	/* ksu 94/02/24 SUBSTRING use default mode */
    ASSIGN
      baseName = SUBSTRING({&labl},INDEX({&labl},{&mnuSepFeature}),-1,
                           "CHARACTER":u)
      extName  = SUBSTRING({&labl},1,INDEX({&labl},{&mnuSepFeature}) - 1,
                           "CHARACTER":u)
      {&labl}  = baseName + extName.
END.

/* _mwo1o.i - end of file */
