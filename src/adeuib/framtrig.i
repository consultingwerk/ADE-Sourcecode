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
      /* UIB triggers for frame widgets - used in _drwfram and _rdfram */
      ON SELECTION          PERSISTENT RUN setselect            IN _h_uib.
      ON DESELECTION        PERSISTENT RUN setdeselection       IN _h_uib.
      ON END-MOVE           PERSISTENT RUN endmove              IN _h_uib.
      ON END-RESIZE         PERSISTENT RUN endresize            IN _h_uib.
      ON MOUSE-SELECT-DOWN, MOUSE-EXTEND-DOWN
                            PERSISTENT RUN setxy                 IN _h_uib.
      ON MOUSE-SELECT-UP, MOUSE-EXTEND-UP
                             PERSISTENT RUN frame-select-up      IN _h_uib.
      ON EMPTY-SELECTION     PERSISTENT RUN drawobj-or-select    IN _h_uib.
      ON END-BOX-SELECTION   PERSISTENT RUN frame-select-up      IN _h_uib.
      ON START-BOX-SELECTION PERSISTENT RUN frame-startboxselect IN _h_uib.
      ON HELP                PERSISTENT RUN disp_help            IN _h_uib.
      ON CURSOR-LEFT, CURSOR-RIGHT, CURSOR-UP, CURSOR-DOWN
                             PERSISTENT RUN tapit                IN _h_uib.
