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
DEFINE STREAM sMain.
DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.

ASSIGN
  cFile = "c:\temp\LoadProfileData.p":U.

OUTPUT STREAM sMain TO VALUE(cFile).

  PUT STREAM sMain UNFORMATTED 
  "DEFINE VARIABLE dProfileTypeObj AS DECIMAL    NO-UNDO." SKIP.

  FOR EACH gsc_profile_type NO-LOCK:

    PUT STREAM sMain UNFORMATTED 
      "CREATE gsc_profile_type.":U SKIP
      "ASSIGN":U SKIP
      "  gsc_profile_type.profile_type_code        = '" gsc_profile_type.profile_type_code "'":U SKIP
      "  gsc_profile_type.profile_type_description = '" gsc_profile_type.profile_type_description "'":U SKIP
      "  gsc_profile_type.client_profile_type      = " gsc_profile_type.client_profile_type SKIP
      "  gsc_profile_type.server_profile_type      = " gsc_profile_type.server_profile_type SKIP
      "  gsc_profile_type.profile_type_active      = " gsc_profile_type.profile_type_active SKIP
      "  dProfileTypeObj                           = gsc_profile_type.profile_type_obj."  SKIP(2).

    FOR EACH gsc_profile_code NO-LOCK
      WHERE gsc_profile_code.profile_type_obj = gsc_profile_type.profile_type_obj:

      PUT STREAM sMain UNFORMATTED 
        "CREATE gsc_profile_code.":U SKIP
        "ASSIGN":U SKIP
        " gsc_profile_code.profile_type_obj    = dProfileTypeObj" SKIP
        " gsc_profile_code.profile_code        = '" gsc_profile_code.profile_code "'":U SKIP
        " gsc_profile_code.profile_description = '" gsc_profile_code.profile_description "'":U SKIP
        " gsc_profile_code.profile_narrative   = '" gsc_profile_code.profile_narrative "'.":U SKIP(1).

    END.
  END.

OUTPUT STREAM sMain CLOSE.
