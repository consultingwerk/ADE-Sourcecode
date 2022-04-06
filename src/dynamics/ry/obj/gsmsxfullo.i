  FIELD scm_xref_obj LIKE gsm_scm_xref.scm_xref_obj~
  FIELD scm_tool_obj LIKE gsm_scm_xref.scm_tool_obj~
  FIELD scm_tool_code LIKE gsc_scm_tool.scm_tool_code~
  FIELD scm_tool_description LIKE gsc_scm_tool.scm_tool_description~
  FIELD scm_foreign_key LIKE gsm_scm_xref.scm_foreign_key~
  FIELD owning_entity_mnemonic LIKE gsm_scm_xref.owning_entity_mnemonic FORMAT "x(8)"~
  FIELD owning_obj LIKE gsm_scm_xref.owning_obj~
  FIELD scmXrefOwningCode AS CHARACTER FORMAT "x(35)" LABEL "Owning code"~
  FIELD owning_reference LIKE gsm_scm_xref.owning_reference
