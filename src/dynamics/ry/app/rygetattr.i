/* ry/app/getAttrValue.i - used by UI Manager (ry/app/ryuimsrvrp.p) 
   Requires following two lines in definitions section of program:
      DEF BUFFER bttAttributeValue FOR ttAttributeValue.
      DEF VAR gcAttributeValue            AS CHAR NO-UNDO.
*/
FIND FIRST bttAttributeValue WHERE
    bttAttributeValue.ObjectInstanceObj = {1} AND
    bttAttributeValue.AttributeLabel = {2}
    NO-ERROR.
IF AVAILABLE bttAttributeValue THEN
  gcAttributeValue = IF bttAttributeValue.AttributeValue = ? THEN "" 
                     ELSE bttAttributeValue.AttributeValue.
ELSE
  gcAttributeValue = "".
