/**************************************************************/
/* Copyright (c) 2011-2014 by progress Software Corporation.  */
/*                                                            */
/* all rights reserved.  no part of this program or document  */
/* may be  reproduced in  any form  or by  any means without  */
/* permission in writing from progress Software Corporation.  */
/**************************************************************/
/*------------------------------------------------------------------------------
    File        : UtilityFactory
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Apr 29  
    Notes       : 
  ----------------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAdmin.Error.NotFoundError from propath.
using OpenEdge.DataAdmin.Util.IDataAdminUtility from propath.
using OpenEdge.DataAdmin.Util.IUtilityFactory from propath.

class OpenEdge.DataAdmin.Util.UtilityFactory implements IUtilityFactory: 
    
    method public IDataAdminUtility GetUtility(pcUtil as char):
        define variable util as IDataAdminUtility no-undo.
        define variable cmsg as character no-undo.
        define variable cPath as character no-undo.
        define variable cPubPath as character no-undo init "OpenEdge.DataAdmin.Util.".
        define variable cInternalPath as character no-undo init "OpenEdge.DataAdmin.Internal.Util.".
        define variable cClassName as character no-undo.
        /* supported as public  (consider search instead? )  */
        define variable PublicUtilityNames as character no-undo init "DeallocateUtility,PartitionSplitUtility,PartitionMergeUtility".
        define variable cUtil as character no-undo.
        cUtil = pcUtil.
        case cUtil:
            /* allow use of interface name (without I) and without *Utility for the Reader and Writer classes */
            when "TableImportUtility" or when "TableImport" then 
                cUtil = "TableDataReader".
            when "TableExportUtility" or when "TableExport" then 
                cUtil = "TableDataWriter".
            when "SequenceExportUtility" or when "SequenceExport" then 
                cUtil = "SequenceValueWriter".    
            when "SequenceImportUtility" or when "SequenceImport" then 
                cUtil = "SequenceValueReader".        
            otherwise  do:
                /* Allow name without *Utility   */ 
                if not cUtil matches "*Utility" then
                do:
                    if lookup(cUtil + "Utility",PublicUtilityNames) > 0 then
                        cClassName = cPubPath + cUtil + "Utility".
                    else 
                    if  search(replace(cInternalPath,".","/") + cUtil + ".r" ) = ?  
                    and search(replace(cInternalPath,".","/") + cUtil + ".cls") = ? then
                        cUtil = cUtil + "Utility".
                end. 
                else do:
                    if lookup(pcUtil,PublicUtilityNames) > 0  then
                        cClassName = cPubPath + cUtil.
                end.
            end.   
        end case.  
         
        if cClassName = "" then
            cClassName = cInternalPath + cUtil .
         
        util = dynamic-new cClassName ( ).
        
        return util.
        catch e as Progress.Lang.Error :
/*            if e:GetMessageNum(1) = 14758 then                                    */
/*                cmsg = " does not have a public constructor with name parameter.".*/
/*            else                                                                  */
/*                cmsg = " not found." .                                            */
        	 
            if e:GetMessageNum(1) = 14284  then
        	   undo, throw new NotFoundError("Utility " + quoter(pcUtil) + " not found.").
        	else
        	   undo, throw e. 
        end catch.
    end method.     
     
     
     
     
end class.