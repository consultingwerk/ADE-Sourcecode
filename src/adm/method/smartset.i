/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* smartset.i - placeholder for developer-specific CASEs for 
   the method set-attribute-list. For example:
    WHEN "BGCOLOR":U THEN DO:
        DEFINE VARIABLE adm-object-hdl AS HANDLE NO-UNDO.
        /* Since smartset.i is now included in the ADM Broker
           you need to reference other attributes relative to
           the object's procedure handle, in local variable p-caller. */
        RUN get-attribute IN p-caller ('ADM-Object-Handle':U).
        adm-object-hdl = WIDGET-HANDLE(RETURN-VALUE).
        IF VALID-HANDLE(adm-object-hdl) THEN
            ASSIGN adm-object-hdl:BGCOLOR = INT(attr-value).
    END.
*/
      
