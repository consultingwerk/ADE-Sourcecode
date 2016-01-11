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
/* t-q-eng.p - English language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'ГЬд ЩитЯЮбЬ ЬЪЪиШну г''Шмлс лШ биалуиаШ ШдШЭулЮйЮк.'
    qbf-lang[ 2] = 'Счджвж ДЪЪиШнщд,ДдрйЮ,Узжйчджвж ДЪЪиШнщд'
    qbf-lang[ 3] = 'ДгнШдхЭждлШа цвШ,СлЮд Шиоу,Слж лтвжк'
    qbf-lang[ 4] = 'ГЬд тоЬлЬ жихйЬа бвЬаЫх Ъа''Шмлц лж ШиоЬхж.'
    qbf-lang[ 5] = 'ДзаЩЬЩШхрйЮ ЫаШЪиШнук лЮк ЬЪЪиШнук'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'ГаШбжзу гтлиЮйЮк.'
    qbf-lang[ 8] = 'О ШиаЯгцк ЫаШЯтйагрд тЪЪиШнщд ЬхдШа '
    qbf-lang[ 9] = 'ЛтлиЮйЮ ЬЪЪиШнщд...   ПШлуйлЬ [' + KBLABEL("END-ERROR")
                 + '] ЪаШ ЫаШбжзу.'
    qbf-lang[10] = 'ИйжчлШа гЬ,ЬхдШа ЛабицлЬиж Шзц,ЬхдШа ЛабицлЬиж Шзц у хйж гЬ,'
                 + 'ЬхдШа ЛЬЪШвчлЬиж Шзц,ЬхдШа ЛЬЪШвчлЬиж Шзц у хйж гЬ,'
                 + 'ЫЬд ИйжчлШа гЬ,АдлайлжаоЬх гЬ,АиохЭЬа Шзц'
    qbf-lang[11] = 'ГЬд мзсиожмд ЫаШЯтйагЬк ЬЪЪиШнтк.'
    qbf-lang[13] = 'ДоЬлЬ нлсйЬа уЫЮ йлЮд зищлЮ ЬЪЪиШну лжм ШиоЬхжм.'
    qbf-lang[14] = 'ДоЬлЬ нлсйЬа уЫЮ йлЮд лЬвЬмлШхШ ЬЪЪиШну лжм ШиоЬхжм.'
    qbf-lang[15] = 'ГЬд тоЬлЬ жихйЬа ФцигШ ПижЩжвук.'
    qbf-lang[16] = 'ПижЩжвтк'
    qbf-lang[17] = 'ДзавтелЬ лЮд жджгШйхШ лЮк ФцигШк ПижЩжвук.'
    qbf-lang[18] = 'ПШлуйлЬ [' + KBLABEL("GO")
                 + '] у [' + KBLABEL("RETURN")
                 + '] ЪаШ ЬзавжЪу нцигШк, у [' + KBLABEL("END-ERROR")
                 + '] ЪаШ лтвжк.'
    qbf-lang[19] = 'ФцилрйЮ лЮк ФцигШк ПижЩжвук...'
    qbf-lang[20] = 'Ж ФцигШ ПижЩжвук (гжину "compiled") вЬхзЬа Ъа''Шмлц лж зицЪиШггШ. '
                 + 'ЛзжиЬх дШ жнЬхвЬлШа йлШ Ьеук :^1) всЯжк PROPATH,^2) вЬхзЬа '
                 + 'лж ШиоЬхж ПижЩжвук .r , у^3) лж ШиоЬхж  ЬхдШа "uncompiled" ЫЮвШЫу .p.^(ГЬхлЬ лж '
                 + 'ШиоЬхж <dbname>.ql ЪаШ гЮдчгШлШ всЯжмк лжм "compiler").^^ЛзжиЬхлЬ '
                 + 'дШ ймдЬохйЬлЬ, Шввс гзжиЬх дШ зижбШвтйЬа гудмгШ всЯжмк йШд ймдтзЬаШ. '
                 + 'ЗтвЬлЬ дШ ймдЬохйЬлЬ; '
    qbf-lang[21] = 'УзсиоЬа тдШ нхвлиж "WHERE" йлЮд литожмйШ ФцигШ ПижЩжвук '
                 + 'зжм ЭЮлс лагтк йлЮд щиШ ЬблтвЬйЮк (RUN-TIME). ЙШлс лЮд '
                 + 'ймЪбЬбиагтдЮ ЬиЪШйхШ цгрк, ЫЬд мзжйлЮихЭЬлШа. ЗтвЬлЬ дШ '
                 + 'ймдЬохйЬлЬ ШЪджщдлШк лж нхвлиж WHERE; '
    qbf-lang[22] = 'ПШлуйлЬ [' + KBLABEL("GET")
                 + '] ЪаШ дШ жихйЬлЬ ЫаШнжиЬлабс зЬЫхШ ШдЬчиЬйЮк.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Дзцг.,ДгнШдхЭЬа лЮд ЬзцгЬдЮ ЬЪЪиШну.'
    qbf-lang[ 2] = 'ПижЮЪ.,ДгнШдхЭЬа лЮд зижЮЪжчгЬдЮ ЬЪЪиШну.'
    qbf-lang[ 3] = 'ПищлЮ,ДгнШдхЭЬа лЮд ПищлЮ ЬЪЪиШну.'
    qbf-lang[ 4] = 'ТЬвЬмл.,ДгнШдхЭЬа лЮд лЬвЬмлШхШ ЬЪЪиШну.'
    qbf-lang[ 5] = 'МтШ,ПижйЯубЮ дтШк ЬЪЪиШнук.'
    qbf-lang[ 6] = 'ЛЬлШЩ.,ЛЬлШЩжву лЮк литожмйШк ЬЪЪиШнук.'
    qbf-lang[ 7] = 'АдлаЪи.,АдлаЪиШну лЮк литожмйШк ЬЪЪиШнук йЬ дтШ ЬЪЪиШну.'
    qbf-lang[ 8] = 'ГаШЪиШну,ГаШЪиШну лЮк литожмйШк ЬЪЪиШнук.'
    qbf-lang[ 9] = 'ДзавжЪу,ДзавжЪу сввЮк ФцигШк ПижЩжвук.'
    qbf-lang[10] = 'АдЬчи.,ДабцдШ лрд ЬЪЪиШнщд гЬ лШ биалуиаШ зжм жихйЬлЬ'
    qbf-lang[11] = 'ДдрйЮ,ДдщйЮ гЬ ЬЪЪиШнтк Шзц сввж ШиоЬхж зжм тожмд йотйЮ.'
    qbf-lang[12] = 'АдШЭул.,АдШЭулЮйЮ гЬ биалуиаШ ЬзавжЪук.'
    qbf-lang[13] = 'Озжм,ДзавжЪу ЬЪЪиШнщд бШа жиайгцк ймдЯЮбщд гЬ лж нхвлиж WHERE.'
    qbf-lang[14] = 'ЛтлиЮйЮ,АиаЯгцк ЬЪЪиШнщд йлж литожд йчджвж у мзжйчджвж.'
    qbf-lang[15] = 'ТШеадцг.,ДзхвжЪЮ ЫаШнжиЬлабжч бвЬаЫажч.'
    qbf-lang[16] = 'ДиЪШй.,ДзавжЪу сввЮк ЬиЪШйхШк.'
    qbf-lang[17] = 'ПвЮижн.,ПвЮижнжихЬк ЪаШ лШ литождлШ биалуиаШ ЬзавжЪук.'
    qbf-lang[18] = 'Хиуйл.,ЙвуйЮ зижЪисггШлжк лжм оиуйлЮ.'
    qbf-lang[19] = 'Ттвжк,Ттвжк.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
