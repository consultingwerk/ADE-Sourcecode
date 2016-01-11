/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _chklblsds.p

Description:
    For the data-source fields to be drawn via DB-FIELDS, this routine adjusts
    _frmx to allow for the longest label if the user has clicked too
    close to the left side of the frame.

Input Paramaters:
    font - font of the frame the fields are being drawn into (_L._FONT)

Output Paramaters:
    none      

Author: Marcelo Ferrante

Date Created: 10/16/2007

Notes: This file was created for the fix of OE00119743 "Cannot create SDV 
       w/ include without db connection".
       This file only handles cases where a data-source is pressent, mostly
       viewers. See the _chklbls.p Notes in order to get more
       information.
----------------------------------------------------------------------------*/
{adeuib/sharvars.i}
{adeuib/uniwidg.i}

DEFINE INPUT PARAMETER ffont AS INTEGER NO-UNDO. /* frame font */

DEFINE VARIABLE iField      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iWidth      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cLblToCheck AS CHARACTER NO-UNDO.
DEFINE VARIABLE iFields     AS INTEGER   NO-UNDO.
DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
DEFINE VARIABLE hSBO        AS HANDLE    NO-UNDO.
DEFINE VARIABLE cTableName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lIsSBO      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lIsSDO      AS LOGICAL   NO-UNDO.

DEFINE BUFFER b_P FOR _P.

FIND b_P WHERE b_P._WINDOW-HANDLE = _h_win NO-LOCK NO-ERROR.

ASSIGN hDataObject = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, INPUT b_P._DATA-OBJECT, THIS-PROCEDURE).
IF NOT VALID-HANDLE(hDataObject) THEN RETURN.

ASSIGN iFields = NUM-ENTRIES(_fld_names)
       lIsSBO  = {fnarg instanceof 'SBO' hDataobject}
       lIsSDO  = {fnarg instanceof 'SDO' hDataobject}.

DO iField = 1 TO iFields:
    /*Removes array references*/
    ASSIGN cField = ENTRY(1, ENTRY(iField,_fld_names), "[":U).

    /*When the SmartDataViewer is build using the wizard. The field name could be: for SBOs "dcust.name",
      for SDOs "name", and for DataView "eCustomer.name". But, when more fields are added to the viewer
      using the 'DB Fields' tool, all the field names are qualified with 'temp-tables' like:
      "temp-tables.dcust.name", "temp-tables.name", or "temp-tables.eCustomer.name".
      That reference to Temp-tables is added for the viewer, and we have to remove it.*/
    IF ENTRY(1, cField, ".") = "Temp-Tables":U THEN
    DO:
        IF NUM-ENTRIES(cField, ".") = 3 THEN 
        cField = ENTRY(2,cField,".":U) + "." + ENTRY(3,cField,".":U).

        /* if two entries and SDO then remove temp-table */
        ELSE IF NUM-ENTRIES(cField, ".") = 2 AND
        lIsSDO THEN 
            ASSIGN cField = ENTRY(2,cField,".":U). 
    END.

    IF lIsSBO THEN
    DO:
        /* SBO: The 1st entry is needed to find the SDO and removed to be passed to it.*/  
        ASSIGN cTableName = ENTRY(1, cField,".":U)
               cFieldName = ENTRY(2, cField,".":U).

        IF NOT VALID-HANDLE(hSBO) THEN
            ASSIGN hSBO = hDataObject.
        /* The sdo name is the first part of the field name which was stripped off above and
           is in cTableName */
        ASSIGN hDataObject = DYNAMIC-FUNCTION("DataObjectHandle" IN hSBO, INPUT cTableName)
               cLblToCheck = DYNAMIC-FUNCTION("columnLabel" IN hDataObject, cFieldName).
        IF NOT VALID-HANDLE(hDataObject) THEN
        DO:
            DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
            NEXT.
        END. /*IF NOT VALID-HANDLE(hDataObject) THEN DO:*/
    END. /*IF DYNAMIC-FUNCTION("getObjectType":U IN hDataObject) = "SmartBusinessObject":U THEN*/
    ELSE
        /*If the data-source is an SDO or DataView the whole field name is passed.*/
        ASSIGN cLblToCheck = DYNAMIC-FUNCTION("columnLabel" IN hDataObject, cField).

  IF (cLblToCheck <> "") AND (cLblToCheck <> ?) THEN
      RUN calcFrmx.
END. /*DO iField = 1 TO iFields:*/

DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
RETURN.

PROCEDURE calcFrmx.

      ASSIGN cLblToCheck = cLblToCheck + ":  ".
      IF ffont <> ? THEN
        ASSIGN iWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLblToCheck,ffont).
      ELSE ASSIGN iWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(cLblToCheck).
      IF _frmx < iWidth THEN
          ASSIGN _frmx = iWidth.

END PROCEDURE.