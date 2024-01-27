@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interfaz Escandalllo'
define view entity zso_cds_i_escandallo
  as select from zso_t_escanda_i  as _Items
    inner join   zso_t_escandal_t as _textReceta on  _textReceta.trans  = _Items.trans
                                                 and _textReceta.artor  = _Items.artor
                                                 and _textReceta.receta = _Items.receta
                                                 and _textReceta.spras  = $session.system_language
  association to parent zso_cds_i_escandallo_head as _Escandallo on  $projection.Trans   = _Escandallo.Trans
                                                                 and $projection.Artor   = _Escandallo.Artor
                                                                 and $projection.Artdest = _Escandallo.Artdest
{
  key       _Items.trans            as Trans,
  key       _Items.artor            as Artor,
  key       _Items.artdest          as Artdest,
  key       _Items.receta           as Receta,
  key       _Items.artor_code       as ArtorCode,
  key       _Items.artdest_code     as ArtdestCode,
            _Items.artor_code       as ArtorCodeEdit,
            _Items.artdest_code     as ArtdestCodeEdit,
            _Items.relpeso          as Relpeso,
            _Items.cantorg          as Cantorg,
            _Items.uomort           as Uomort,
            _Items.cantdest         as Cantdest,
            _Items.uomdest          as Uomdest,
            _textReceta.receta_desc as RecetaDesc,
            //Association
            _Escandallo
}
