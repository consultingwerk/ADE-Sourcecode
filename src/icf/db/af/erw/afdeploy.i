%ForEachEntity()
{
%If(%==(%entityprop("Deploy"),"yes")){
  %File(%SubjectAreaProp(TriggerDump)%EntityProp(TableFLA)fixop.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemfixop.i")}
  }
}
