@EndUserText.label: 'Composition escantallo head'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity zso_cds_c_escandallo_head
  provider contract transactional_query
  as projection on zso_cds_i_escandallo_head
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
                   id: 'DataHead',
                   type: #FIELDGROUP_REFERENCE,
                   purpose: #STANDARD,
                   parentId: 'GenralInfo',
                   position: 10,
                   targetQualifier: 'DataHead'
                },
                {
                   id: 'DataItems',
                   purpose: #STANDARD,
                   type: #LINEITEM_REFERENCE,
                   label: 'Items escandallo',
                   position: 20,
                   targetElement: '_Items'
               }
             ]
         @UI.lineItem: [
                { position: 10, importance: #HIGH }
         //                { type: #FOR_ACTION, dataAction: 'customCreate', label: 'Custom Create', position:  11}
         ]
         @UI.selectionField: [{ position: 10 }]
         @Consumption.valueHelpDefinition: [{ entity:{ name: 'zso_cds_transf_type_vh', element: 'Trans' } }]
         @EndUserText.label: 'Tipo de transformación'
         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 10, importance: #HIGH }]
  key    Trans,
         @UI.lineItem: [{ hidden: true }]
  key    Artor,
         @UI.lineItem: [{ hidden: true }]
  key    Artdest,
         @UI.lineItem: [{ position: 20, importance: #HIGH }]
         @UI.selectionField: [{ position: 20 }]
         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 20, importance: #HIGH }]
         @EndUserText.label: 'Art.Org Edit'
         ArtorEdit,
         @UI.lineItem: [{ position: 30, importance: #HIGH }]
         @UI.selectionField: [{ position: 30 }]
         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 30, importance: #HIGH }]
         @EndUserText.label: 'Art.Dest Edit'
         ArtdestEdit,
         //         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 40, importance: #HIGH }]
         LocalCreatedBy,
         //         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 50, importance: #HIGH }]
         LocalCreatedAt,
         //         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 60, importance: #HIGH }]
         LocalLastChangedBy,
         //         @UI.fieldGroup: [{ qualifier: 'DataHead', position: 70, importance: #HIGH }]
         LocalLastChangedAt,
         LastChangedAt,
         /* Associations */
         _Items : redirected to composition child zso_cds_c_escandallo_items
}
