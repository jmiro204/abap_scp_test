@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interfaz Escandalllo'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define root view entity zso_cds_i_escandallo_head
  as select from zso_t_escanda_h
  composition [1..*] of zso_cds_i_escandallo as _Items
{
  key     trans                 as Trans,
  key     artor                 as Artor,
  key     artdest               as Artdest,
          artor                 as ArtorEdit,
          artdest               as ArtdestEdit,
          @Semantics.user.createdBy: true
          local_created_by      as LocalCreatedBy,
          @Semantics.systemDateTime.createdAt: true
          local_created_at      as LocalCreatedAt,
          @Semantics.user.localInstanceLastChangedBy: true
          local_last_changed_by as LocalLastChangedBy,
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
          local_last_changed_at as LocalLastChangedAt,
          @Semantics.systemDateTime.lastChangedAt: true
          last_changed_at       as LastChangedAt,
          //Association
          _Items
}
