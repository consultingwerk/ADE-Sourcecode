/********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
  File: rythinviewv.w

  Description:  Thin Dynamic Viewer

  Purpose:      This is the thin dynamic viewer rendering procedure.
                It contains preprocessor defintions that exclude
                adm prototypes and code only required for static
                objects from adm2/rydynviewv.w.

  Parameters:   <none>

----------------------------------------------------------------------*/

&GLOBAL-DEFINE ADM-EXCLUDE-PROTOTYPES
&GLOBAL-DEFINE ADM-EXCLUDE-STATIC
&SCOPED-DEFINE exclude-start-super-proc

{ry/obj/rydynviewv.w}
