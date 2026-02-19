/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : TypeInfo
   Purpose     : Used for Class/Procedure as a container of class annotation info and the methods/procedures info
   Syntax      :
   Description :
   Author(s)   : svutla
   Created     : Tue Nov 12 12:00:10 IST 2013
   Notes       :
 ----------------------------------------------------------------------*/

using OpenEdge.ABLUnit.Reflection.ClassInfo.
using OpenEdge.Core.Collections.Array.

class OpenEdge.ABLUnit.Reflection.TypeInfo:

    define public property classInfo as ClassInfo  no-undo get. set.
    define public property methods as Array no-undo get. set.
    define public property methodsCount as integer init 0 no-undo get. set.

    /* No functional code here. */

end class.