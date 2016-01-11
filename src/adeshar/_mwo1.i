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
 * _mwo1.i
 *
 *   This file works around a "feature" with mulitple spaces at the end
 *   of a string that differentiate the string.
 *
 *   With this feature if you have a char field with the value "xxx " then
 *
 *   local_char = "xxx  " /* The extra space is intentional */
 *   find first t where char_field = "xxx  ".
 *
 *   returns the row with "xxx " in it.
 *
 *   For menus, we use the separators this way. So internally, replace
 *   spaces with Xs.
 *
 *   This file must be included after {_mnudefs.i}
 */

if index({&labl}, {&mnuSepFeature}) > 0 then do:

    define variable baseName as character no-undo.
    define variable extName  as character no-undo.
	/* ksu 94/02/24 SUBSTRING use default mode */
    baseName = SUBSTRING({&labl},1,LENGTH({&mnuSepFeature},"CHARACTER":u),
                         "CHARACTER":u).

    extName  = SUBSTRING({&labl},LENGTH({&mnuSepFeature},"CHARACTER":u) + 1,
                 LENGTH({&labl},"CHARACTER":u) 
               - LENGTH({&mnuSepFeature},"CHARACTER":u),"CHARACTER":u).

    {&labl} = extName + baseName.
end.

/* _mw01.i - end of file */
