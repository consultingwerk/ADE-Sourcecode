&if false &then
/************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : dsxref.i
    Purpose     : Dataset definition for COMPILE XML-XREF output. Based on 
                  the schema in $DLC/properties/schemas/xrefd0005.xsd 
    Author(s)   : pjudge
    Created     : 2018-11-08
    Arguments   : ACCESS-LEVEL - PUBLIC/PROTECTED/PRIVATE for class-based use
                  REFERENCE-ONLY - "REFERENCE-ONLY" or blank
                  TABLE-TYPE - "temp" or "entity". Defaults to "temp". Only if 
                  "temp" then the dataset is created
  ----------------------------------------------------------------------*/
&endif
&if defined(TABLE-TYPE) eq 0 &then 
    &scoped-define TABLE-TYPE temp
&endif
&if "{&TABLE-TYPE}" eq "temp" &then
    &scoped-define DEFINE define
    &scoped-define NO-UNDO no-undo
&else
    &scoped-define DEFINE
    &if defined(NO-UNDO) ne 0 &then
        &undefine NO-UNDO
    &endif
    &scoped-define NO-UNDO  
&endif 

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Source {&NO-UNDO} {&REFERENCE-ONLY}
    field File-name   as character xml-node-type 'attribute':u 
    field Source-guid as character 
    field File-num    as integer
    
    index idx1 as primary unique Source-guid File-num
    index idx2                   File-name
    .

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table String-ref {&NO-UNDO} {&REFERENCE-ONLY}
    field Source-guid   as character
    field Ref-seq       as integer 
    field Max-length    as integer
    field Justification as character
    field Translatable  as logical
    
    index idx1 as unique Source-guid Ref-seq.

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Parameter-ref {&NO-UNDO} {&REFERENCE-ONLY}
    field Source-guid    as character
    field Ref-seq        as integer
    field Order          as integer   xml-node-type 'attribute':u 
    field Parameter-mode as character xml-node-type 'attribute':u 
    field Parameter-name as character xml-node-type 'attribute':u 
    field Parameter-type as character xml-node-type 'attribute':u 
    field Dimension      as integer
    field Is-append      as logical
    field Dataset-guid   as character
    
    index idx1 as unique Source-guid Ref-seq Order.

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Class-ref {&NO-UNDO} {&REFERENCE-ONLY}
    field Source-guid     as character
    field Ref-seq         as integer
    field Inherited-list  as character
    field Implements-list as character
    field Has-use-pool    as logical
    field Is-final        as logical
    field Is-serializable as logical
    field Dataset-guid    as character
    
    index idx1 as unique Source-guid Ref-seq.

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Reference {&NO-UNDO} {&REFERENCE-ONLY}
    field Object-identifier as character xml-node-type 'attribute':u 
    field Reference-type    as character xml-node-type 'attribute':u 
    field Source-guid       as character
    field File-num          as integer 
    field Ref-seq           as integer 
    field Line-num          as integer 
    field Object-context    as character 
    field Access-mode       as character 
    field Data-member-ref   as character 
    field Temp-ref          as character 
    field Detail            as character 
    field Is-static         as logical
    field Is-abstract       as logical
    
    index idx1 as primary unique Source-guid Ref-seq Line-num
    .

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Interface-ref {&NO-UNDO} {&REFERENCE-ONLY}
    field Source-guid    as character
    field Ref-seq        as integer
    field Inherited-list as character
    
    index idx1 is unique primary Source-guid Ref-seq.

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Dataset-ref {&NO-UNDO} {&REFERENCE-ONLY}
    field Source-guid  as character
    field Dataset-guid as character
    field Ref-seq      as integer
    field N-uri        as character
    field N-prefix     as character
    field Is-reference as logical
    field Buffer-list  as character
    field Data-links   as integer
    
    index idx1 is unique primary Source-guid Dataset-guid Ref-seq.

{&DEFINE} {&ACCESS-LEVEL} {&TABLE-TYPE}-table Relation {&NO-UNDO} {&REFERENCE-ONLY}
    field Source-guid        as character
    field Dataset-guid       as character
    field Relation-name      as character xml-node-type 'attribute':u
    field Parent-buffer-name as character
    field Child-buffer-name  as character
    field Relation-list      as character
    
    index idx1 is primary Source-guid Dataset-guid.

&if "{&TABLE-TYPE}" eq "temp" &then
define {&ACCESS-LEVEL} dataset dsXref {&REFERENCE-ONLY}
    namespace-uri 'uri:schemas-progress-com:XREFD:0005':u 
    serialize-name 'Cross-reference':u 
    for Source, Reference, Class-ref, Interface-ref, String-ref, Parameter-ref, Dataset-ref, Relation
    data-relation for Source, Reference
        relation-fields (Source-guid, Source-guid,File-num, File-num) 
        nested
    data-relation for Reference, Class-ref
        relation-fields (Source-guid, Source-guid,Ref-seq, Ref-seq)
        nested
    data-relation for Reference, Interface-ref
        relation-fields (Source-guid, Source-guid,Ref-seq, Ref-seq)
        nested
    data-relation for Reference, String-ref
        relation-fields (Source-guid, Source-guid,Ref-seq, Ref-seq)
        nested
    data-relation for Reference, Parameter-ref
        relation-fields (Source-guid, Source-guid,Ref-seq, Ref-seq) 
        nested
    data-relation for Reference, Dataset-ref
        relation-fields (Source-guid, Source-guid,Ref-seq, Ref-seq)
        nested
    data-relation for Dataset-ref, Relation
        relation-fields (Source-guid, Source-guid,Dataset-guid, Dataset-guid)
        nested
    .
&endif
/*eof*/
