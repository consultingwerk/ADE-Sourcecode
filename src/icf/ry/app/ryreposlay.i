/* ry/app/ryreposlay.i --
   temp-table used to communicate layout information from client to
   repository when building dynamic Containers */
DEFINE TEMP-TABLE ttLayoutObject NO-UNDO
    FIELD LayoutPosition         AS CHARACTER
    FIELD LayoutObjectType       AS CHARACTER
    FIELD LayoutTemplateObj      AS LOGICAL
    FIELD LayoutAttributeLabels  AS CHARACTER
    FIELD LayoutAttributeValues  AS CHARACTER
    FIELD LayoutInstance         AS CHARACTER.