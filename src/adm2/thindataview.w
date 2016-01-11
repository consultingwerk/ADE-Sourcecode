/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*--------------------------------------------------------------------
  File: thindataview.w

  Description:  Thin Dynamic SmartDataObject

  Purpose:      This is the thin dynamic SDO rendering procedure.
                It contains preprocessor definitions that exclude
                adm prototypes and code only required for static
                objects from src/adm2/dyndataview.w.

  Parameters:   <none>

----------------------------------------------------------------------*/
&scop adm-prepare-static-object YES
&scop adm-prepare-class-name dyndataview
&scop adm-exclude-static
&scop adm-exclude-prototypes
 
&SCOPED-DEFINE exclude-start-super-proc

{src/adm2/dyndataview.w}

FUNCTION adm-assignObjectProperties RETURNS LOGICAL ( ):
  &SCOPED-DEFINE xp-assign
  {set ObjectType 'SmartDataObject':U}
  {set QueryObject TRUE}
  {set ObjectName 'thindataview':U}.
  &UNDEFINE xp-assign

END.
