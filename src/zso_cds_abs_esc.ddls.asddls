@EndUserText.label: 'Entidad abstracta accion create'
define abstract entity zso_cds_abs_esc
{
    @EndUserText.label: 'Tipo transformación'
    @Consumption.valueHelpDefinition: [{ entity:{ name: 'zso_cds_transf_type_vh', element: 'Trans' } }]
    trans   : abap.char(2);
    @EndUserText.label: 'Articulo unico Origen/Dest'
    art : abap.char(40);
    
}
