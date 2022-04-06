/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
{src/adm2/schemai.i}    

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttSchema.

    DEFINE VARIABLE iDatabase AS INTEGER.                   
    DO iDatabase = 1 TO NUM-DBS:
        CREATE ALIAS DB_MetaSchema FOR DATABASE VALUE(LDBNAME(iDatabase)).
        RUN af/app/afschemagp.p (
            INPUT LDBNAME(iDatabase),
            INPUT-OUTPUT TABLE ttSchema
            ).            
    END.

    FOR EACH ttSchema WHERE INDEX_position = "":
        ttSchema.INDEX_position = "None".
    END.

