@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Transformación'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zso_cds_transf_type_vh
  as select from zso_trans_vh
{
      @ObjectModel.text.element: ['TransDesc']
      @UI.lineItem: [{ position: 10, importance: #HIGH}]
  key trans      as Trans,
      @Semantics.text: true
      @UI.lineItem: [{ position: 20, importance: #HIGH}]
      trans_desc as TransDesc
}
