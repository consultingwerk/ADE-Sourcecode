/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

