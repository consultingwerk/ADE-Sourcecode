/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------
  File: thinlookup.w

  Description:  Thin Dynamic Lookup

  Purpose:      This is the thin dynamic lookup rendering procedure.
                It contains preprocessor defintions that exclude
                adm prototypes and code only required for static
                objects from adm2/dynlookup.w.

  Parameters:   <none>

----------------------------------------------------------------------*/

&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC
&SCOPED-DEFINE exclude-start-super-proc

{src/adm2/dynlookup.w}
