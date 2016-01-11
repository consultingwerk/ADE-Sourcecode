/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : _rycustom.p
    Purpose     : create _ryobject for currently selected row from datasoruce
    Syntax      :
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Jul 15 22:31:22 EDT 2012
    Notes       : Separated from _opendialog.w to be called without browser UI

  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
routine-level on error undo, throw.
using Progress.Lang.AppError from propath.

define variable ghDataSource as handle no-undo.
define variable glInternalSource as logical no-undo.

/*   gshRepositoryManager */
{src/adm2/globals.i}
 /* Shared _RyObject and _custom temp-tables. */
{adeuib/ttobject.i}
{adeuib/custwidg.i}

/* set external dataobject - used by standard _opendialog */
procedure setDataSource :
    define input parameter hSDO as handle no-undo.
    ghDataSource = hSdo.
    glInternalSource = false.
end procedure.

/* create internal data source */
procedure createDataSource :
    run startDataObject in gshRepositoryManager("dopendialog.w":U, output ghDataSource).

    if valid-handle(ghDataSource) then
    do:
        run setPropertyList in ghDataSource 
            ('AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch10CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessyesDisconnectAppServernoObjectNamedopendialogUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U).
   
        run initializeObject in ghDataSource. 
    end.
    glInternalSource = true.
end procedure.
 
procedure createRYObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable cQueryPosition as character  no-undo.
    define variable cColumns       as character  no-undo.
    
    define buffer local_custom for _custom.

    do on error undo, leave:
        /* IZ 2342 MRU List doesn't work with dynamics objects. Returns non null when 
            object can't be found. */
        {get QueryPosition cQueryPosition ghDataSource}. /* any data? */
        if cQueryPosition = 'NoRecordAvailable':U then 
            undo, throw new AppError("Object was not found."). 
/*            return "NOT_FOUND":U.*/

    /*  jep-icf: Copy the repository related field values to _RyObject. The 
        AppBuilder will use _RyObject in processing the OPEN request. */
        cColumns = dynamic-func("colValues" in ghDataSource,"object_filename,smartobject_obj,object_type_obj,~
object_type_code,product_module_obj,product_module_code,object_description,object_path,object_extension,~
runnable_from_menu,disabled,run_persistent,run_when,security_smartobject_obj,container_object,~
static_object,generic_object,required_db_list,layout_obj,relative_path,deployment_type,design_only").

        find _RyObject where _RyObject.object_filename = ENTRY(2,cColumns,chr(1)) no-error.
        if not available _RyObject then
            create _RyObject.

        assign 
            _RyObject.Object_type_obj           = decimal(entry(4,cColumns,chr(1)))
            _RyObject.Object_type_code          = entry(5,cColumns,chr(1))
            _RyObject.parent_classes            = dynamic-function("getClassParentsFromDB":U in gshRepositoryManager, input _RyObject.Object_type_code)
            _RyObject.Object_filename           = entry(2,cColumns,chr(1))
            _RyObject.smartobject_obj           = decimal(entry(3,cColumns,chr(1)))
            _RyObject.product_module_obj        = decimal(entry(6,cColumns,chr(1)))
            _RyObject.product_module_code       = entry(7,cColumns,chr(1))
            _RyObject.Object_description        = entry(8,cColumns,chr(1))
            _RyObject.Object_path               = entry(9,cColumns,chr(1))
            _RyObject.Object_path               = if _RyObject.Object_path = "":U then entry(21,cColumns,chr(1)) else _RyObject.Object_path
            _RyObject.Object_extension          = entry(10,cColumns,chr(1))
            _RyObject.runnable_from_menu        = (entry(11,cColumns,chr(1)) = "Yes":U or ENTRY(11,cColumns,chr(1)) = "true":U)
            _RyObject.disabled                  = (entry(12,cColumns,chr(1)) = "Yes":U or ENTRY(12,cColumns,chr(1)) = "true":U)
            _RyObject.Run_persistent            = (entry(13,cColumns,chr(1)) = "Yes":U or ENTRY(13,cColumns,chr(1)) = "true":U)
            _RyObject.Run_when                  = entry(14,cColumns,chr(1))
            _RyObject.security_smartObject_obj  = decimal(entry(15,cColumns,chr(1)))
            _RyObject.container_object          = (entry(16,cColumns,chr(1)) = "Yes":U or ENTRY(16,cColumns,chr(1)) = "true":U)
            _RyObject.static_object             = (entry(17,cColumns,chr(1)) = "Yes":U or ENTRY(17,cColumns,chr(1)) = "true":U)
            _RyObject.generic_object            = (entry(18,cColumns,chr(1)) = "Yes":U or ENTRY(18,cColumns,chr(1)) = "true":U)
            _RyObject.Required_db_list          = entry(19,cColumns,chr(1))
            _RyObject.Layout_obj                = decimal(entry(20,cColumns,chr(1)))
            _RyObject.design_action             = "OPEN":u
            _RyObject.design_ryobject           = yes 
            _RyObject.deployment_type           = entry(22,cColumns,chr(1))
            _RyObject.design_only               = (entry(23,cColumns,chr(1)) = "Yes":U or ENTRY(23,cColumns,chr(1)) = "true":U)
            NO-ERROR.
                                                                       /* Object_type_code */
        find first local_custom where local_custom._object_type_code = ENTRY(5,cColumns,chr(1)) no-error.

        /* If we can't find the local_custom, check if we've got a user defined class */

        if not available local_custom then 
        do:
            if lookup(_RyObject.object_type_code, dynamic-function("getClassChildrenFromDB" in gshRepositoryManager, input "DynView":U)) > 0 then
                find first local_custom where local_custom._object_type_code = "SmartDataViewer":U no-error.
            else
                if lookup(_RyObject.object_type_code, dynamic-function("getClassChildrenFromDB" in gshRepositoryManager, input "DynSDO":U)) > 0 then
                    find first local_custom where local_custom._object_type_code = "DynSDO":U no-error.
                else
                    if lookup(_RyObject.object_type_code, dynamic-function("getClassChildrenFromDB" in gshRepositoryManager, input "DynBrow":U)) > 0 then
                        find first local_custom where local_custom._object_type_code = "DynBrow":U no-error.
        end.

        if available local_custom then
            assign
                _RyObject.design_template_file   = local_custom._design_template_file
                _RyObject.design_propsheet_file  = local_custom._design_propsheet_file
                _RyObject.design_image_file      = local_custom._design_image_file.

        return.
    end.  /* DO ON ERROR */
end procedure.

procedure findObject:
    define input  parameter pcObjectName as character no-undo.
    define output parameter plOk as logical no-undo.
  
    define variable cQueryPosition as character no-undo.
 
    dynamic-function('assignQuerySelection':U in ghDataSource,'object_filename':U,pcObjectName,'EQ':U).
    
    /* open the new query  */
    dynamic-function('openQuery':U in ghDataSource).
    
    {get QueryPosition cQueryPosition ghDataSource}. /* any data? */
    if cQueryPosition = 'NoRecordAvailable':U then 
        plOk = false.
    else 
        plOk = true.   
end procedure.

procedure destroyObject:
    if glInternalSource then 
        run destroyObject in ghDataSource no-error.
     
    delete procedure this-procedure.
    
end procedure.
        