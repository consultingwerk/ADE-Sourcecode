/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
  File: thinsdo.w

  Description:  Thin Dynamic SmartDataObject

  Purpose:      This is the thin dynamic SDO rendering procedure.
                It contains preprocessor defintions that exclude
                adm prototypes and code for static objects from 
                adm2/dynsdo.w.

  Parameters:   <none>

----------------------------------------------------------------------*/
&scop adm-prepare-static-object YES
&scop adm-prepare-class-name dynsdo
&scop adm-exclude-static
&scop adm-exclude-prototypes
 
&SCOPED-DEFINE exclude-start-super-proc

{src/adm2/dynsdo.w}

FUNCTION adm-assignObjectProperties RETURNS LOGICAL ( ):
  &SCOPED-DEFINE xp-assign
  {set ObjectType 'SmartDataObject'}
  {set ObjectName 'thindata'}.
  {set ServerFileName 'adm2/thinsdo.w'}.
  &UNDEFINE xp-assign

END.
