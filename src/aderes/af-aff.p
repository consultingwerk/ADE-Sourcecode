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
* af-aff.p
*
*    Wrapper to hide the internal variable string vars starting
*    with '_'
*
*    This file will be compiled, but its source will NOT be available
*    to the customer. This file can NOT start with an '_' because
*    it is included as part of the fastload file. The fastload has
*    to be able to be compiled in customers environment. That means
*    no undersocres in any code compiled, directly or indirectly, by the
*    customer.
*/

{ aderes/s-system.i }
{ aderes/y-define.i }
{ aderes/_fdefs.i }

DEFINE INPUT PARAMETER varName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER varValue AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-s AS LOGICAL   NO-UNDO.
  
CASE varName:
  WHEN "adminFeature":u THEN DO:
    _adminFeatureFile = varValue.


    /* Run the feature file code now! */
    IF _adminFeatureFile <> ? AND _adminFeatureFile <> "" THEN DO:

      runFeature:
      DO ON STOP UNDO runFeature, RETRY runFeature:

        IF RETRY OR SEARCH(_adminFeatureFile) = ? THEN DO:
          RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-s,"information":u,"ok":u,
            SUBSTITUTE("There is a problem with &1.  &2 will continue with its default feature set.",_adminFeatureFile,qbf-product)).

          RUN aderes/af-init.p.
          RUN aderes/_afwrite.p (2).
          LEAVE runFeature.
        END.

        RUN VALUE(_adminFeatureFile)({&resId}).
      END.
    END.
  END.

  WHEN "adminMenu":u THEN 
    _adminMenuFile = varValue.
  
  WHEN "minLogo":u THEN 
    ASSIGN
      _minLogo = varValue
      qbf-s    = qbf-win:LOAD-ICON(_minLogo)
      .
END.

/* af-aff.p -  end of file */

