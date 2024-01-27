@EndUserText.label: 'Composition escantallo items'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity zso_cds_c_escandallo_items
  as projection on zso_cds_i_escandallo
{
        @UI.facet: [
                   {
                    label: 'Información General',
                    id: 'GenralInfo',
                    type: #COLLECTION,
                    position: 10,
                    importance: #HIGH
                   },
                   {
                     id: 'DataItem',
                     type: #FIELDGROUP_REFERENCE,
                     purpose: #STANDARD,
                     parentId: 'GenralInfo',
                     position: 10,
                     targetQualifier: 'DataItem'
                  }
               ]
        @UI.lineItem: [{ position: 10, importance: #HIGH }]
        @EndUserText.label: 'Tipo de transformación'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 10, importance: #HIGH }]
  key   Trans,
        @UI.lineItem: [{ position: 20, importance: #HIGH }]
        @EndUserText.label: 'Art.Orga'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 20, importance: #HIGH }]
  key   Artor,
        @UI.lineItem: [{ position: 30, importance: #HIGH }]
        @EndUserText.label: 'Art.Dest'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 40, importance: #HIGH }]
  key   Artdest,
        @UI.lineItem: [{ position: 100, importance: #HIGH }]
        @EndUserText.label: 'Receta'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 50, importance: #HIGH }]
  key   Receta,
        @UI.lineItem: [{ hidden: true }]
        @EndUserText.label: 'Articulo origen receta'
  key   ArtorCode,
        @UI.lineItem: [{ hidden: true }]
        @EndUserText.label: 'Articulo destino receta'
  key   ArtdestCode,
        @UI.lineItem: [{ position: 40, importance: #HIGH }]
        @EndUserText.label: 'Articulo origen receta edit'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 80, importance: #HIGH }]
        ArtorCodeEdit,
        @UI.lineItem: [{ position: 70, importance: #HIGH }]
        @EndUserText.label: 'Articulo destino receta edit'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 110, importance: #HIGH }]
        ArtdestCodeEdit,
        @UI.lineItem: [{ position: 80, importance: #HIGH }]
        @EndUserText.label: 'Relación peso'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 70, importance: #HIGH }]
        Relpeso,
        @UI.lineItem: [{ position: 50, importance: #HIGH }]
        @EndUserText.label: 'Cantidad origen receta'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 90, importance: #HIGH }]
        Cantorg,
        @UI.lineItem: [{ position: 60, importance: #HIGH }]
        @EndUserText.label: 'UOM Origen receta'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 100, importance: #HIGH }]
        @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' } }]
        Uomort,

        @UI.lineItem: [{ position: 80, importance: #HIGH }]
        @EndUserText.label: 'Cantidad destino receta'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 120, importance: #HIGH }]
        Cantdest,
        @UI.lineItem: [{ position: 90, importance: #HIGH }]
        @EndUserText.label: 'UOM Destino receta'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 130, importance: #HIGH }]
        @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' } }]
        Uomdest,
        @UI.lineItem: [{ position: 110, importance: #HIGH }]
        @EndUserText.label: 'Descripción receta'
        @UI.fieldGroup: [{ qualifier: 'DataItem', position: 140, importance: #HIGH }]
        RecetaDesc,
        /* Associations */
        _Escandallo : redirected to parent zso_cds_c_escandallo_head
}
