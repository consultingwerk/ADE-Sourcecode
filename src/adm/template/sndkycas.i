/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* sndkycas.i - CASE statement for KEY link support */

    WHEN "{1}" THEN 
      pc_key-value = IF AVAILABLE {2} THEN STRING({2}.{3}) ELSE ?.
            
            
