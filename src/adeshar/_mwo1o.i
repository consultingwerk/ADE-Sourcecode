/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
