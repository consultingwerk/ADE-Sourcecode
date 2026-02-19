/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : ClassInfo
   Purpose     : Stores the information of the class and annotation preceding the class
   Syntax      :
   Description :
   Author(s)   : hgarapat
   Created     : Fri Jul 13 14:51:10 IST 2012
   Notes       :
 ----------------------------------------------------------------------*/

using OpenEdge.Core.Collections.Array.

class OpenEdge.ABLUnit.Reflection.ClassInfo:

    define private variable className as character no-undo.
    define public property annotationsInfo as Array no-undo get. set.

    constructor public ClassInfo (input pcClassName as character, input poAnnotationsInfo as Array):
        className = pcClassName.
        this-object:annotationsInfo = poAnnotationsInfo.
    end constructor.

    method public character getClassName(  ):
        return className.
    end method.


    method public Array getAnnotations(  ):
        return annotationsInfo.
    end method.

end class.