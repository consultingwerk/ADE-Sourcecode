/*********************************************************************
* Copyright (C) 2020 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}

find dictdb._File where RECID(dictdb._File) = s_TblRecId.

{adecomm/deltable.i}
