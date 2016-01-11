/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : dialoginit.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Fri Feb 03 22:23:09 EST 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
&if DEFINED(IDE-IS-RUNNING) <> 0 &then
      &if DEFINED(IDE-DIALOG-INIT) = 0 &THEN
         define variable dialogService as adeuib.idialogservice no-undo.           
         &GLOBAL-DEFINE IDE-DIALOG-INIT  
      &ENDIF
     Run CreateDialogService in hOEIDEService ({1},output dialogService).
 &endif