/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
