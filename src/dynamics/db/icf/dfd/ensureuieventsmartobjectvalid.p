/** This utility will ensure that the smartobject the ui event is linked to is the same smartobject
    that the object instance is linked to
   
   ------------------------------------------------------------------------------------------------------ **/

/* Remove all code from this program, since it will be executed by
   dynamics/db/icf/dfd/remove_orphans.p instead. That procedure is included in the DCU via the
   ensureAttributeSmartobjectValid.p, and is deliberately not included here because there is
   no sense in running the procedure twice within the same DCU 'session'.

   To include this, simply uncomment the following:
 */
 
 /* {db/icf/dfd/remove_orphans.p}  */
 
 return.
/*  E  O  F  */