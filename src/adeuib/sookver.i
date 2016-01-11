/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* 
 * File: sookver.i 
 * Description: Determines if the adm objects are compatible
 *       Container's adm-version is contained in _P._adm-version
 *         instantiated adm-version is retrieved via method getObjectVersion 
 * Input: 
 *   {1} smartobject filename
 *   {2} candraw logical
 *   {3} delete procedure and smartobject after running it
 * Created: 02/98
 * Modified: 01/19/99 JEP improve handling when smo cannot be created (invalid)
 *           03/09/98 SLK use of LT ADM2
 */

/* canRun is used to avoid calling this code repeatedly when the SmartObject
   cannot be instanitated. Its initialized in vsookver.i as TRUE and
   only set to FALSE if the object can't be created (run persistent). If we
   didn't do this and the user had several windows open, the AB would
   try running the file over and over and failing for every window, displaying
   the same messages over and over. Fixes bug 98-12-28-020. -jep */
IF CAN-DO(_P._Allow, "Smart":U) AND ({1} ne ?) THEN DO:
   IF canRun THEN
   DO:
       {adeuib/undsmar.i {1} obj-handle " "}.
   END.
   IF VALID-HANDLE(obj-handle) THEN 
   DO:
      canRun = YES.

      {adeuib/admver.i obj-handle obj-version}.
      IF obj-version = ? OR obj-version = "":U THEN obj-version = "ADM1":U.
      IF (obj-version LT "ADM2":U AND 
           _P._adm-version LT "ADM2":U) THEN
         ASSIGN {2} = YES.
      ELSE IF obj-version >= "ADM2":U AND
              _P._adm-version >= "ADM2":U THEN
         ASSIGN {2} = YES.
      ELSE
         ASSIGN {2} = NO.

      /* This include file is used to determine if smartobjects are compatible
       * It is sometimes necessary for us to instantiate an object to determine its
       * version, but once a version is determined we may need to disallow its use,
       * therefore there is a need for us to delete the smart object
       */
      IF {3} AND VALID-HANDLE(obj-handle) THEN 
      DO:
         /* Get rid of the Persistent Object we just created. */
         /* Explicitly delete it, if we can't destroy it.     */
        IF obj-version LT "ADM2":U THEN
           RUN dispatch IN obj-handle ('destroy') NO-ERROR.
        ELSE
           RUN destroyObject IN obj-handle NO-ERROR.
        IF VALID-HANDLE (obj-handle) THEN DELETE PROCEDURE obj-handle.
      END.
   END.
   ELSE
   DO:
      ASSIGN obj-version = ?
             canRun      = NO  /* canRun  */
             {2}         = NO. /* canDraw */
             
      /* Clear the smartobject filename to draw, since we can't run it. */
      ASSIGN {1} = ?.
   END.
     
END. /* Allow smart and valid file */
