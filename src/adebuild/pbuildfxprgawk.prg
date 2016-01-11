/<MinimumVersion>/ {
  ver=020001
  minVer=0+substr($1,17,6)
  while (ver<minVer) {
    if(length(ver)==5)ver="0" ver
    print ver " delta"
    ver++
  }
}
/<Patch PatchLevel=/ {delta=0; moveToEnd=0}
/<PatchStage Stage="PreADOLoad">/ {moveToEnd=1}
/<PatchStage Stage="ADOLoad">/ {moveToEnd=1}
/<PatchStage Stage="PostADOLoad">/ {moveToEnd=1}
/<FileType>/ {
  t=$1
  sub("<FileType>","",t)
  sub("</FileType>","",t)
}
/<FileName>/ {
  if(t=="p"){
    ver=substr(FILENAME,index(FILENAME,"icfdb")+5)
    sub("patch.xml","",ver)
    if(0+ver<minVer)next
    if(!delta){--ver}
    if(length(ver)==8)ver=substr(ver,1,6)
    if(length(ver)==5)ver="0" ver
    fxprg=substr($1,11,length($1)-21)
    if(moveToEnd){end[++i]=fxprg} else print ver " " fxprg
  }
  if(t=="df"){
    ver=substr(FILENAME,index(FILENAME,"icfdb")+5)
    sub("patch.xml","",ver)
    if(0+ver<minVer)next
    if(length(ver)==8)ver=substr(ver,1,6)
    print ver " delta"
  }
}
/delta.df/ {delta=1}
END {for(i in end)print ver " " end[i]}
