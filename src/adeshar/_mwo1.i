/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
