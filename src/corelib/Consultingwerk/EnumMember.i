&IF 1=0 &THEN
/** ****************************************************************************
  Copyright 2013 Consultingwerk Ltd.
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
    http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
**************************************************************************** **/ 
/*------------------------------------------------------------------------
    File        : EnumMember.i
    Purpose     : Defines an Enum Member property in an Enum class

    Syntax      : {Consultingwerk/EnumMember.i Label Value TypeName}

    Description : 

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Aug 25 12:24:36 CEST 2010
    Notes       :
  ----------------------------------------------------------------------*/
&ENDIF

    DEFINE PUBLIC STATIC PROPERTY {1} AS {3} NO-UNDO 
    GET:
        IF NOT VALID-OBJECT ({3}:{1}) THEN 
            {3}:{1} = NEW {3} ({2}, "{1}":U) .
            
        RETURN {3}:{1} .           
    END GET . 
    PRIVATE SET. 
    
&IF "{&EnumMembers}":U NE "":U &THEN
&GLOBAL-DEFINE EnumMembers {&EnumMembers},{1}
&ELSE
&GLOBAL-DEFINE EnumMembers {1}
&ENDIF

&IF "{&EnumValues}":U NE "":U &THEN
&GLOBAL-DEFINE EnumValues {&EnumValues},{2}
&ELSE
&GLOBAL-DEFINE EnumValues {2}
&ENDIF
