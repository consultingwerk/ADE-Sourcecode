
/*--------------------------------------------------------------------------------
    File        : _widgaps.p
    Purpose     : Returns the default widget-id gap for the specified object type.	

    Syntax      :

    Description : 

    Author(s)   : Marcelo Ferrante
    Created     : Thu May 24 17:53:33 EDT 2007
    Notes       : This file is used by the 'Runtime Widget-id assgnment tool'
                  to leave enough space between the SmartObject widget-ids, in
                  order to avoid duplicates.
                  These values are separated from the tool itself to allow
                  developers or QA engineers to customize these values.

                  In order to modify these values it is required to change the
                  value of piWidgetID for the required object type.
  -------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */

FUNCTION getWidgetIDGap RETURNS INTEGER 
	(INPUT pcObjectType AS CHARACTER) FORWARD.

/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */

FUNCTION getWidgetIDGap RETURNS INTEGER 
    (INPUT pcObjectType AS CHARACTER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
CASE pcObjectType:
    WHEN "FRAME":U               THEN RETURN 200.
    WHEN "SmartDataBrowser":U    THEN RETURN 250.
    WHEN "DynBrow":U             THEN RETURN 250.
    WHEN "SmartViewer":U         THEN RETURN 1000.
    WHEN "SmartDataViewer":U     THEN RETURN 1000.
    WHEN "DynView":U             THEN RETURN 1000.
    WHEN "DataField":U           THEN RETURN 4.
    WHEN "SmartDataField":U      THEN RETURN 20.
    WHEN "DynCombo":U            THEN RETURN 10.
    WHEN "DynLookup":U           THEN RETURN 10.
    WHEN "SmartFilter":U         THEN RETURN 100.
    WHEN "FilterField":U         THEN RETURN 6.
    WHEN "SmartToolbar":U        THEN RETURN 200.
    WHEN "Toolbar":U             THEN RETURN 200.
    WHEN "SmartToolbarActions":U THEN RETURN 2.
    WHEN "SmartSelect":U         THEN RETURN 10.
    WHEN "SmartFolder":U         THEN RETURN 1000.
    WHEN "SmartFrame":U          THEN RETURN 2000.
    WHEN "SmartFolderPage":U     THEN RETURN 20.
    WHEN "SmartLOBField":U       THEN RETURN 10.
    WHEN "SmartPanel":U          THEN RETURN 50.
    WHEN "TreeNode":U            THEN RETURN 2000.
    OTHERWISE RETURN 500.
END. /* case */
END FUNCTION.