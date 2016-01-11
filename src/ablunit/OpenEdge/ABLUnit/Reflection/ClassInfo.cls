 
 /*------------------------------------------------------------------------
    File        : ClassInfo
    Purpose     : Stores the information of the class and annotation preceding the class
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Fri Jul 13 14:51:10 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.



class OpenEdge.ABLUnit.Reflection.ClassInfo: 

	define variable className as character no-undo.
	define variable annotationInfo as OpenEdge.ABLUnit.Reflection.AnnotationInfo no-undo.
	
	constructor public ClassInfo (input classN as character, input annot as OpenEdge.ABLUnit.Reflection.AnnotationInfo):
        	className = classN.
        	annotationInfo = annot.	
	end constructor.

	method public character getClassName(  ):
		return className.
	end method.    


    method public character getAnnotationName(  ):
        return annotationInfo:getAnnotationName().
    end method.    

end class.