/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _mupdatt.p
 *  
 *    Reconcile the state of the toolbar. Walk through each record
 *    in the toolbar temp table and see if any of the records are dirty.
 *    Then do what is required to make the toolbar in synch with the 
 *    temp table
 *
 *  Input Parameters
 *
 *    appId            THe application client this item belongs to.
 *
 * Stuff to know:
 *
 * There can only be one feature attached to a button. This is an
 * explicit design decision. Much of the code assumes this fact!
 *
 * The toolbar button state is maintained in the various calls that
 * deal with records. The current state indicates what we should do
 * with the record.
 *
 */
{ adecomm/_mtemp.i   }
{ {&mdir}/_mnudefs.i }

&if defined(ADEICONDIR) = 0 &then
    {adecomm/icondir.i}
&endif

define input  parameter appId        as character no-undo.

define variable tbItem     as widget    no-undo.
define variable lookAhead  as character no-undo initial "".
define variable state      as character no-undo.
define variable lastTbItem as widget    no-undo.
define variable s          as logical   no-undo.

/*
 * This procedure creates the comma seperated list of features
 * currently available in the menus. This list is created for performance
 * reasons. This list is sent everytime _machk.p is called. The is built
 * only when needed.
 */

find first mnuApp where mnuApp.appId = appId.

    /*
     * Just in case, if there's no menu bar then let the client know and
     * go away
     */

    if mnuApp.toolbar = ? or (not valid-handle(mnuApp.toolbar)) then do:

        if mnuApp.displayMessages then
            message "Attempting to attach a button to an" skip
                    "invalid toolbar widget." skip
            view-as alert-box.
        return.
    end.

assign
    mnuApp.tFeatureList = ""
    mnuApp.tSensList = ""
    mnuApp.tToggList = ""
.

/*
 * Work only with the records that belong to the named application
 */

for each tbItem where tbItem.appId = appId:

    /*
     * Make a copy of the state. The local var is needed in case the
     * record gets deleted.
     */
 

    state = tbItem.state.
    case state:

        when "create" or
        when "modify-new" then do:

            run createButton.
            tbItem.state = "".

        end.

        when "delete-existing" or
        when "delete-new" then do:

            if valid-handle(tbItem.handle) then delete widget tbItem.handle.

            delete tbItem.

        end.

        when "modify-existing" then do:

            if valid-handle(tbItem.handle) then do:
                delete widget tbItem.handle.
                tbItem.handle = ?.
            end.

            run createButton.

            assign
                tbItem.state = ""
            .

        end.
    end case.

    /*
     * Add this record to the list of features in the toolbar. The
     * list exists for performance.
     */

    if state <> "delete-existing" and state <> "delete-new" then do:

        assign
            mnuApp.tFeatureList = mnuApp.tFeatureList
                                + lookAhead
                                + tbItem.featureId 

            mnuApp.tSensList    = mnuApp.tSensList
                                + lookAhead
                                + "true" 

            mnuApp.tToggList    = mnuApp.tToggList
                                + lookAhead
                                + "true" 

            lookAhead = ","
       .

    end.
    

end.

procedure createButton.

define variable iName as character no-undo.

    /*
     * We need the micro help for the button. The micro help is part of
     * the feature.
     */

    find first mnuFeatures where mnuFeatures.appId     = tbItem.appId
                             and mnuFeatures.featureId = tbItem.featureId.
    create button tbItem
        assign  
            frame         = mnuApp.toolbar
            x             = tbItem.x
            y             = tbItem.y
            width-pixels  = tbItem.w
            height-pixels = tbItem.h
            auto-resize   = false
            sensitive     = true
            private-data  = tbItem.prvData
            no-focus      = true
        triggers:
            on choose 
                persistent run {&mdir}/_mfire.p(tbItem.appId,
                                                tbItem.featureId,
                                                tbItem).

            /*
             * Work around a bug. The has to do with mouse-select-up
             * "eating" the choose event.
             */

            on mouse-menu-down
                persistent run adecomm/_statdsp.p(mnuApp.statusArea,
                                                  1,
                                                  mnuFeatures.microHelp). 
            on mouse-menu-up
                persistent run adecomm/_statdsp.p(mnuApp.statusArea, 1, "").
        end triggers.
    .

    assign
        tbItem.handle = tbItem
    .
            
    /*
     * Now give the button its images. Qualify with a full path name, if
     * it isn't already. This gives a big performance boost.
     */

    if (tbItem.upImage <> ?) and (tbItem.upImage <> "") then do:

        iName = tbItem.upImage.
        RUN figureImageName (tbItem.upImage, OUTPUT iName).

        if (not tbItem:LOAD-IMAGE-UP(iName)) then
            message tbItem.upImage "(up) was not found by _mupdatt."
                 view-as alert-box error buttons ok.

    end.

    if (tbItem.downImage <> ?) and (tbItem.downImage <> "") then do:

        iName = tbItem.downImage.
        RUN figureImageName (tbItem.downImage, OUTPUT iName).

         if (not tbItem:LOAD-IMAGE-DOWN(iName)) then
                 message tbItem.downImage "(down) was not found by _mupdatt."
                 view-as alert-box error buttons ok.

    end.

    if (tbItem.insImage <> ?) and (tbItem.insImage <> "") then do:

        iName = tbItem.insImage.
        RUN figureImageName (tbItem.insImage, OUTPUT iName).

         if (not tbItem:LOAD-IMAGE-INSENSITIVE(iName)) then
                 message tbItem.insImage "(ins) was not found by _mupdatt."
                 view-as alert-box error buttons ok.
    end.

    /* Assign tooltips to the toolbar buttons */
    CASE tbItem.FeatureId:
      /* 
       * The default labels on some of these features do not make good
       * tooltips. Since they are hard coded into the user's startup file,
       * we will change them on-the-fly here.
       */
      WHEN "BrowseView":U        THEN tbItem:TOOLTIP = "View as Browse".
      WHEN "ReportView":U        THEN tbItem:TOOLTIP = "View as Report".
      WHEN "ExportView":U        THEN tbItem:TOOLTIP = "View as Export".
      WHEN "FormView":U          THEN tbItem:TOOLTIP = "View as Form".
      WHEN "LabelView":U         THEN tbItem:TOOLTIP = "View as Label".
      WHEN "NewDuplicateView":U  THEN tbItem:TOOLTIP = "New".
      WHEN "PrintPrinterNoBox":U THEN tbItem:TOOLTIP = "Print".
      OTHERWISE DO:
        /* 
         * Except for the features special-cased above, we will use the
         * feature label for the tooltip. If the feature does not have 
         * a label, we will use the feature name for the tooltip.
         */
        IF mnuFeatures.defaultLabel NE "" AND mnuFeatures.defaultLabel NE ? THEN 
          /* Remove unwanted "&" and "..." characters from the label */
          ASSIGN tbItem:TOOLTIP = REPLACE(mnuFeatures.defaultLabel,"&":U,"")
                 tbItem:TOOLTIP = REPLACE(tbItem:TOOLTIP,"...":U,"").
        ELSE 
          tbItem:TOOLTIP = tbItem.FeatureId. /* Use the featureId instead */
      END.
    END CASE.
end.

procedure figureImageName:
  define input  parameter realName as character no-undo.
  define output parameter iName    as character no-undo.
  define variable         slash    as character no-undo.

  iName = realName.
  if iName BEGINS "adeicon":u then 
    assign
      slash = if index(realName,"/":u) > 0 then "/":u else "~\":u
      iName = {&ADEICON-DIR} + entry(2, realName, slash).
end procedure.
