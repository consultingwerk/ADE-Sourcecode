%ForEachTable()
{
%If(%==(%entityprop("Deploy"),"yes")){
  %File(%DiagramProp(TriggerDump)%EntityProp(TableFLA)fixop.p) {%Include("%DiagramProp("RootDir")db/af/erw/aftemfixop.i")}
  }
}
