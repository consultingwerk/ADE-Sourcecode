/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/*------------------------------------------------------------------------
    File        : authenticationsystem.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Wed Feb 16 19:41:41 EST 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define  temp-table ttAuthenticationSystem no-undo       serialize-name "authenticationSystems" {1} before-table ttAuthenticationSystemCopy
         field Name            as char        serialize-name "name"        format "x(25)"
         field Description     as character   serialize-name "description" format "x(25)"
         field Comments        as character   serialize-name "comments"    format "x(40)"
         field IsBuiltIn       as logical     serialize-name "isBuiltIn"   label "Built in"
         field URL             as character   serialize-name "url" format "x(30)" label "Url"
         {daschema/entity.i}
         index idxName as primary unique Name.
        
