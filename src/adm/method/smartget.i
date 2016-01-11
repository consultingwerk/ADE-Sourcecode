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
/* smartget.i - placeholder for developer-specific CASEs for 
   the method get-attribute-list. For example:
    WHEN "BGCOLOR":U THEN DO:
        DEFINE VARIABLE adm-object-hdl AS HANDLE NO-UNDO.
        /* Since smartget.i is now included in the ADM Broker
           you need to reference other attributes relative to
           the object's procedure handle, in local variable p-caller. */
        RUN get-attribute IN p-caller ('ADM-Object-Handle':U).
        adm-object-hdl = WIDGET-HANDLE(RETURN-VALUE).
        ASSIGN attr-value = IF VALID-HANDLE(adm-object-hdl)
                            THEN  STRING(adm-object-hdl:BGCOLOR)
                            ELSE ?.
    END.
*/
    
