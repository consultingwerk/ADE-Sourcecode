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
 *  _mwritep.p
 *
 *    Write out the current state of the menu subsystem using the 4GL or
 *    plain text as desired. Write over any existing file without
 *    asking anyone.
 *
 *  This function can create 3 versions of the state of the menu subsystem.
 *  The first is an ascii version. THe second is a function based
 *  .p. The third is a temp-table based .p. The third version provides
 *  the best start up performance. The second provides a .p that can be
 *  given to the user. The file can be compiled if there are .r code changes.
 * 
 *  The algorithm exists because the original method ofstructuring the
 *  .p overshot the action segment. Basically, the old way was to write
 *  out "run adecom ..." for each entry.
 *
 *  For .p generation the new algorithm uses a whole bunch or sub
 *  procedures. Each subprocedure  has its own allocation of action segment.
 *
 *  This algorithm makes a new subprocedure for every N items
 *
 *  Input Parameter
 *
 *     appId      The application Id
 *     fileName   THe file to be written into.
 *     writeWhat  "f" for feature "mt" for the menus and toolbar
 *     fileformat "m" for ascii text, "fp" for fast .p, "p" for function
 *                based .p.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input parameter appId        as character no-undo.
define input parameter fileName     as character no-undo.
define input parameter writeWhat    as character no-undo.
define input parameter fileFormat   as character no-undo.

define stream mStream.

define variable blockSize as integer no-undo initial 100.
define variable i         as integer no-undo initial 0.
define variable pCount    as integer no-undo initial 0.


output stream mStream to value(fileName) no-echo.

problemo:
do on error undo problemo, retry problemo:
    if retry then do:
        message "There is a problem writing " fileName + "." skip
                "the file will not be created."
        view-as alert-box error.

        return.
    end.

    /*
     * Put out some header stuff
     */
    
    if fileFormat = "m" then
        put stream mStream unformatted
            '# PROGRESS Ade Menu Subsystem Configuration File':u skip
            'version= ':u {&mnuVersion} skip
        .
    else do:
        put stream mStream unformatted
            'define input parameter appId   as character no-undo.' skip
        .
    
        if fileFormat = "fp" then
            put stream mStream unformatted '~{ adeshar/_mnudefs.i}' skip.
        if writeWhat = "mt" then
            put stream mStream unformatted
                'define input parameter setToolbar as logical no-undo.'
                skip
            .
    
        put stream mStream unformatted
            'define variable answer as logical no-undo.'
            skip
            'define variable handle as widget no-undo.'
            skip(2)
    
            &if defined(timestartup) &then
                'define variable asdf as character no-undo.' skip
                '~{ adeshar/mpdecl.i timer foo }' skip
                '~{ adeshar/mp.i stotal ""+MNU"" for foo}' skip(2)
            &endif
        .
    
        run startProc(input-output pCount).
    end.                
    
    /*
     * Write out the menu feature list, if desired
     */
    
    if writeWhat = "f" then do:
    
        for each mnuFeatures where mnuFeatures.appId = appId:
    
            if (mnuFeatures.featureId <> {&mnuSepFeature}) then
     
                if fileFormat = "m" then do:
                    PUT STREAM mStream CONTROL
                        {&mnuFeatureType}:u
                        '.'
                        mnuFeatures.featureId
                        ' = ':u
                    .
    
                    EXPORT STREAM mStream
                        mnuFeatures.functionId
                        mnuFeatures.args
                        mnuFeatures.defaultLabel
                        if mnuFeatures.userDefined then 'T':u else 'F':u 
                        mnuFeatures.type
                        mnuFeatures.defaultUpIcon
                        mnuFeatures.defaultDownIcon
                        mnuFeatures.defaultInsIcon
                        mnuFeatures.microHelp
                        mnuFeatures.prvData
                        mnuFeatures.securityList
                     .      
                end.
                else do:
                     if fileFormat = "p" then
                        /*
                         * Function based
                         */
                        put stream mStream unformatted
                            'run {&mdir}/_maddf.p("'
                            mnuFeatures.appId  '", "'
                            mnuFeatures.featureId '", "'
                            mnuFeatures.type '", "'
                            mnuFeatures.functionId '", "'
                            mnuFeatures.args '", "'
                            mnuFeatures.defaultLabel '", "'
                            mnuFeatures.defaultUpIcon '","'
                            mnuFeatures.defaultDownIcon '"," '
                            mnuFeatures.defaultInsIcon '","'
                            mnuFeatures.microHelp '", '
                            mnuFeatures.userDefined ', "'
                            mnuFeatures.prvData '", "'
                            mnuFeatures.securityList '", output answer).'
                            skip(2)
                        .
                    else
    
                        /*
                         * Fastload
                         */
                         put stream mStream unformatted
                            'create mnuFeatures.' skip
                            'assign' skip
                            '  mnuFeatures.appId = "' mnuFeatures.appId '"' skip
                            '  featureId = "' mnuFeatures.featureId '"' skip
                            '  function = "' mnuFeatures.functionId '"' skip
                            '  args = "' mnuFeatures.args '"' skip
                            '  prvData = "' mnuFeatures.prvData '"' skip
                            '  defaultLabel = "' mnuFeatures.defaultLabel '"' skip
                            '  defaultUpIcon = "' mnuFeatures.defaultUpIcon '"'
                                                                              skip
                            '  defaultDownIcon = "' mnuFeatures.defaultDownIcon '"'
                                                                              skip
                            '  defaultInsIcon = "' mnuFeatures.defaultInsIcon '"'
                                                                              skip
                            '  microHelp = "' mnuFeatures.microHelp '"' skip
                            '  userDefined = ' mnuFeatures.userDefined  skip
                            '  type = "' mnuFeatures.type '"' skip
                            '  state = ""' skip
                            '  secure = false' skip
                            '  securityList = "' mnuFeatures.securityList '"' skip
                            '.' skip(2)
                        .
    
                    /*
                     * Now see if we've hit our blocksize. If we have then 
                     * make a new procedure!
                     */
                    i = i + 1.
                    if i = blockSize then do:
                        run endProc(input-output i).
                        &if defined(timestartup) &then
                            put stream mStream unformatted
                               '~{ adeshar/mp.i stotal ""-100"" for foo}' skip
                            .
                        &endif
                        run startProc(input-output pCount).
                    end.
                end.
        end.
    end.
    
    /*
     * Write out the menus. We have to write out all parents before writing out
     * the children. This is needed when the file is read in. The parents must
     * be available for any children
     */
    
    if writeWhat = "mt" then do:
    
        for each mnuMenu where mnuMenu.appId = appId:
    
            /*
             * If we doing ascii or the "procedure version" then don't write
             * out "sub menus". In these cases the submenus are handled
             * properly by the _madd* functions.
             */
    
            if fileFormat <> "fp" then do:
                find first mnuItems where mnuItems.labl = mnuMenu.labl
                                    and   mnuItems.appId = appId no-error.
    
                if available mnuItems then next.
            end.
    
            if fileFormat = "m" then do:
                PUT STREAM mStream CONTROL
                    {&mnuMenuType}:u
                    '.':u
                     mnuMenu.labl
                     ' = ':u
                .
        
                EXPORT STREAM mStream    
                    mnuMenu.prvData
                    mnuMenu.sensFunction
                 .
            end.
            else do:
    
                if fileFormat = "p" then
                    put stream mStream unformatted
                        'run {&mdir}/_maddm.p("'
                        mnuMenu.appId  '", "'
                        mnuMenu.labl '", "'
                        mnuMenu.prvData '", "'
                        mnuMenu.sensFunction '", '
                        'output answer).'
                        skip(2)
                    .      
                else
                    /*
                     * Fastload
                     */
                    put stream mStream unformatted
                        'create mnuMenu.' skip
                        'assign' skip
                        '  mnuMenu.appId = "' mnuMenu.appId '"' skip
                        '  mnuMenu.menuId = "' mnuMenu.menuId '"' skip
                        '  mnuMenu.labl = "' mnuMenu.labl '"' skip
                        '  mnuMenu.prvData = "' mnuMenu.prvData '"' skip
                        '  mnuMenu.sensFunction = "' mnuMenu.sensFunction '"' skip
                        '  mnuMenu.type = "' mnuMenu.type '"' skip
                        '  mnuMenu.state = "create"' skip
                        '.' skip(2)
                    .
                /*
                 * Now see if we've hit our blocksize. If we have then 
                 * make a new procedure!
                 */
                i = i + 1.
                if i = blockSize then do:
                    run endProc(input-output i).
                    &if defined(timestartup) &then
                        put stream mStream unformatted
                           '~{ adeshar/mp.i stotal ""-100"" for foo}' skip
                        .
                    &endif
    
                    run startProc(input-output pCount).
                end.
            end.
        end.
    
        /*
         * Write out all the menu items. The sub menus have to go first, since
         * stuff can be attached to them.
         */
    
        for each mnuItems where mnuItems.appId = appId:
    
            if fileFormat = "m" then do:
                PUT STREAM mStream CONTROL
                    mnuItems.type
                    '.':u
                    mnuItems.featureId
                    ' = ':u
                .
    
                EXPORT STREAM mStream    
                    mnuItems.parentId
                    mnuItems.labl
                    if mnuItems.userDefined then 'T':u else 'F':u 
                    mnuItems.prvData
                .
            end.
            else do:
                if fileFormat = "p" then
                    put stream mStream unformatted
                        'run {&mdir}/_maddi.p("'
                        mnuItems.appId  '", "'
                        mnuItems.featureId '", "'
                        mnuItems.parentId '", "'
                        mnuItems.labl '", "'
                        mnuItems.type '", '
                        mnuItems.userDefined ', "'
                        mnuItems.prvData '", '
                        'output answer).'
                        skip(2)
                    .      
                else
                    /*
                     * Fastload
                     */
                    put stream mStream unformatted
                        'find first mnuFeatures where' skip
                        '    mnuFeatures.appId = "' mnuItems.appId '"' skip
                        'and mnuFeatures.featureId = "'mnuItems.featureId '"' skip
                        'and mnuFeatures.secure = false no-error.' skip
                        'if available mnuFeatures then do:' skip
                        '  create mnuItems.' skip
                        '  assign' skip
                        '    mnuItems.appId = "' mnuItems.appId '"' skip
                        '    mnuItems.featureId = "' mnuItems.featureId '"' skip
                        '    mnuItems.parentId = "' mnuItems.parentId '"' skip
                        '    mnuItems.labl = "' mnuItems.labl '"' skip
                        '    mnuItems.type = "' mnuItems.type '"' skip
                        '    mnuItems.userDefined = ' mnuItems.userDefined skip
                        '    mnuItems.prvData = "' mnuItems.prvData '"' skip
                        '    mnuItems.state = "create"' skip
                        '    mnuItems.origParent = ?' skip
                        '    mnuItems.sNum = ' mnuItems.sNum skip

                        '  .' skip
                        'end.' skip(2)
                    .
                /*
                 * Now see if we've hit our blocksize. If we have then 
                 * make a new procedure!
                 */
                i = i + 1.
                if i = blockSize then do:
                    run endProc(input-output i).
    
                    &if defined(timestartup) &then
                        put stream mStream unformatted
                            '~{ adeshar/mp.i stotal ""-100"" for foo}' skip
                                .
                    &endif
    
                    run startProc(input-output pCount).
               end.
            end.
        end.
    
        /*
         * Write out all the toolbar stuff
         */
        for each tbItem where tbItem.appId = appId:
    
            if fileFormat = "m" then do:
                PUT STREAM mStream unformatted
                    tbItem.type
                    '.':u
                    tbItem.featureId
                    ' = ':u
                .
    
                EXPORT STREAM mStream    
                    tbItem.toolbarId
                    tbItem.upImage
                    tbItem.downImage
                    tbItem.insImage
                    if tbItem.userDefined then 'T':u else 'F':u 
                    tbItem.prvData
                    tbItem.x
                    tbItem.y
                    tbItem.w
                    tbItem.h
                .
            end.
            else do:
                if fileFormat = "p" then
                    put stream mStream unformatted
                        'run {&mdir}/_maddt.p("'
                        tbItem.appId  '", "'
                        tbItem.featureId '", "'
                        tbItem.toolbarId '", "'
                        tbItem.upImage '", "'
                        tbItem.downImage '","'
                        tbItem.insImage '", '
                        tbItem.x ', '
                        tbItem.y ', '
                        tbItem.w ', '
                        tbItem.h ', "'
                        tbItem.type '", '
                        tbItem.userDefined ', "'
                        tbItem.prvData '", '
                        'output answer).'
                        skip(2)
                    .      
                else
                    /*
                     * Fastload
                     */
                    put stream mStream unformatted
                        'find first mnuFeatures where' skip
                        '    mnuFeatures.appId = "' tbItem.appId '"' skip
                        'and mnuFeatures.featureId = "'tbItem.featureId '"' skip
                        'and mnuFeatures.secure = false no-error.' skip
                        'if available mnuFeatures then do:' skip
                        '  create tbItem.' skip
                        '  assign' skip
                        '    tbItem.appId = "' tbItem.appId '"' skip
                        '    tbItem.featureId = "' tbItem.featureId '"' skip
                        '    tbItem.toolbarId = "' tbItem.toolbarId '"' skip
                        '    tbItem.upImage = "' tbItem.upImage '"' skip
                        '    tbItem.downImage = "' tbItem.downImage '"' skip
                        '    tbItem.insImage = "' tbItem.insImage '"' skip
                        '    tbItem.type = "' tbItem.type '"' skip
                        '    tbItem.userDefined = ' tbItem.userDefined  skip
                        '    tbItem.x = ' tbItem.x skip
                        '    tbItem.y = ' tbItem.y skip
                        '    tbItem.w = ' tbItem.w skip
                        '    tbItem.h = ' tbItem.h skip
                        '    tbItem.prvData = "' tbItem.prvData '"' skip
                        '    tbItem.state = "create"' skip
                        '  .' skip
                        'end.' skip(2)
                    .
    
                /*
                 * Now see if we've hit our blocksize. If we have then 
                 * make a new procedure!
                 */
                i = i + 1.
                if i = blockSize then do:
                    run endProc(input-output i).
                    &if defined(timestartup) &then
                        put stream mStream unformatted
                            '~{ adeshar/mp.i stotal ""-100"" for foo}' skip
                        .
                    &endif
    
                    run startProc(input-output pCount).
                end.
            end.
        end.
    end.
    
    /*
     * Write out trailer stuff. For programs, call the update functions that
     * synch the toolbar/menus.
     */
    
    if fileFormat <> "m" then do:
      
        /*
         * CLose out the open procedure
         */
    
        run endProc(input-output i).

        find first mnuApp where mnuAPp.appId = appId.
    
        if fileFormat = "fp" then 
            put stream mStream unformatted
                'find first mnuApp where mnuApp.appId = "' appId '".' skip
                'mnuApp.sNum = ' mnuApp.sNum '.' skip
            .
        put stream mStream unformatted
            'run {&mdir}/_mupdatm.p(appId) .' skip
        .
    
        if writeWhat = "mt" then do:
            put stream mStream unformatted
                'if setToolbar then run {&mdir}/_mupdatt.p(appId) .' skip
        .
    
        end.
    end.
end. /* problemo */
output stream mStream close.

procedure endProc.
define input-output parameter i as integer no-undo.

i = 0.

put stream mStream unformatted

    'end procedure.'
    skip
.

end procedure.

procedure startProc.
define input-output parameter pCount as integer no-undo.

put stream mStream unformatted
    skip(3)
    'run ip' pCount '.'
    skip
    '/* ============================================================== */'
    skip
    'procedure ip' pCount '.'
    skip
.

pCount = pCount + 1.
end procedure.




