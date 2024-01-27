CLASS lhc_items DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validDescReceta FOR VALIDATE ON SAVE
      IMPORTING keys FOR Items~validDescReceta.
    METHODS setartorgdest FOR DETERMINE ON MODIFY
      IMPORTING keys FOR items~setartorgdest.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR items RESULT result.
    METHODS customcreateitem FOR MODIFY
      IMPORTING keys FOR ACTION items~customcreateitem.
*    METHODS customcreateitem FOR MODIFY
*      IMPORTING keys FOR ACTION items~customcreateitem.

ENDCLASS.

CLASS lhc_items IMPLEMENTATION.

  METHOD validDescReceta.
    READ ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
        ENTITY Items
        FIELDS ( RecetaDesc ) WITH CORRESPONDING #( keys )
        RESULT DATA(items).

    LOOP AT items INTO DATA(ls_item).
      IF ls_item-RecetaDesc IS INITIAL.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-Items.
        APPEND VALUE #( %tky = ls_item-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Descripción de receta no informada' )
                       ) TO reported-Items.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.



  METHOD setArtOrgDest.

    DATA: lv_change   TYPE abap_boolean,
          lv_cnt_item TYPE i.

    READ ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
        ENTITY Items
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(items).


    SELECT trans, artor, receta, receta_desc
    FROM zso_t_escandal_t
    WHERE spras = @sy-langu
    GROUP BY trans, artor, receta, receta_desc
    INTO TABLE @DATA(lt_receta_text).

    LOOP AT items ASSIGNING FIELD-SYMBOL(<fs_item>).
      lv_cnt_item = lv_cnt_item + 1.
      "Determinación de articulo origen y destino
      IF
         (  <fs_item>-ArtorCode IS  INITIAL AND <fs_item>-ArtdestCode IS INITIAL ).
        lv_change = abap_true.
        <fs_item>-ArtorCodeEdit    =  COND #( WHEN <fs_item>-Artor    <> '*' THEN <fs_item>-Artor   ELSE '' ).
        <fs_item>-ArtdestCodeEdit  =  COND #( WHEN <fs_item>-Artdest  <> '*' THEN <fs_item>-Artdest ELSE '' ).
        IF <fs_item>-ArtorCodeEdit IS INITIAL.
          <fs_item>-ArtorCode = lv_cnt_item.
          CONDENSE <fs_item>-ArtorCode NO-GAPS.
        ELSE.
          <fs_item>-ArtorCode = <fs_item>-ArtorCodeEdit.
        ENDIF.
        IF <fs_item>-ArtdestCodeEdit IS INITIAL.
          <fs_item>-ArtdestCode = lv_cnt_item.
          CONDENSE <fs_item>-ArtdestCode NO-GAPS.
        ELSE.
          <fs_item>-ArtdestCode = <fs_item>-ArtdestCodeEdit.
        ENDIF.
      ENDIF.

      "Determinación de receta si el id existe
      READ TABLE lt_receta_text WITH KEY trans = <fs_item>-Trans artor = <fs_item>-Artor receta = <fs_item>-Receta
        INTO DATA(ls_receta_text).
      IF  sy-subrc EQ 0 AND <fs_item>-RecetaDesc IS INITIAL .
        lv_change = abap_true.
        <fs_item>-RecetaDesc = ls_receta_text-receta_desc.
      ENDIF.

    ENDLOOP.


    IF lv_change EQ abap_true.
      "Si no ha pasado por esta determinación
      MODIFY ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
       ENTITY Items
         UPDATE FIELDS ( ArtorCode ArtdestCode ArtorCodeEdit ArtdestCodeEdit RecetaDesc )
         WITH VALUE #( FOR item IN items  (
                            %tky        = item-%tky
                        ArtorCode       = item-ArtorCode
                        ArtdestCode     = item-ArtdestCode
                        ArtorCodeEdit   = item-ArtorCodeEdit
                        ArtdestCodeEdit = item-ArtorCodeEdit
                        RecetaDesc      = item-RecetaDesc
                        ) )

         FAILED DATA(faileds)
         REPORTED DATA(reporteds)
         MAPPED DATA(mappeds).
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
       ENTITY Items
       ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(items).

    READ TABLE items ASSIGNING FIELD-SYMBOL(<fs_item>) INDEX 1.

    result =  VALUE #( FOR <fs_key> IN keys (  %tky = <fs_key>-%tky

                                            %field-ArtorCodeEdit   = COND #( WHEN  <fs_key>-Trans = '01'  AND <fs_key>-%is_draft = '01'  THEN if_abap_behv=>fc-f-read_only
                                                                                                          ELSE if_abap_behv=>fc-f-mandatory )
                                            %field-ArtdestCodeEdit = COND #( WHEN  <fs_key>-Trans = '02'  AND <fs_key>-%is_draft = '01'  THEN if_abap_behv=>fc-f-read_only
                                                                                                          ELSE if_abap_behv=>fc-f-mandatory )
                                            %field-RecetaDesc      = COND #( WHEN  <fs_item>-RecetaDesc <> '' THEN if_abap_behv=>fc-f-read_only
                                                                                                          ELSE if_abap_behv=>fc-f-mandatory )
                                                             ) ).
  ENDMETHOD.

*  METHOD customCreateItem.
*    DATA:
*      items    TYPE TABLE FOR CREATE zso_cds_i_escandallo,
*      lv_error TYPE abap_boolean.
*
*
*
*    IF lines( keys ) > 1.
*      LOOP AT keys INTO DATA(ls_key).
*        INSERT VALUE #( %cid = ls_key-%cid %action-customCreate = if_abap_behv=>mk-on  ) INTO TABLE failed-head.
*        RETURN.
*      ENDLOOP.
*    ENDIF.
*
*    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
*
*    IF <fs_key>-%param-receta IS INITIAL.
*      INSERT VALUE #( %cid = ls_key-%cid %action-customCreate = if_abap_behv=>mk-on  ) INTO TABLE failed-head.
*      reported-head = VALUE #(
*          (
*                %msg = new_message_with_text(
*                            severity = if_abap_behv_message=>severity-success
*                            text = 'Debe indicar ID de receta' )
*                       )
*          ).
*      RETURN.
*    ENDIF.
*
*
*    READ ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
*      ENTITY Head
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(heads).
*    READ TABLE   heads INTO DATA(ls_head) INDEX 1.
*
*
*    " fill in travel container for creating new travel instance
*    APPEND VALUE #(
*                     %cid      = <fs_key>-%cid
*                     %is_draft = <fs_key>-%param-%is_draft
*                     %data     = CORRESPONDING #( <fs_key>-%param )
*                )
*    TO items ASSIGNING FIELD-SYMBOL(<new_item>).
*
*    <new_item>-Artor  = COND #(  WHEN  <new_head>-Trans = '01' THEN <fs_key>-%param-art
*                                 WHEN  <new_head>-Trans = '02' THEN '*'
*                                 ELSE <fs_key>-%param-art )
*                                .
*
*    <new_item>-Artdest = COND #( WHEN  <new_head>-Trans = '01' THEN '*'
*                                 WHEN  <new_head>-Trans = '02' THEN <fs_key>-%param-art
*                                 ELSE  <fs_key>-%param-art ).
*
*    <new_item>-ArtorCode = COND #(  WHEN  <new_head>-Trans = '01' THEN <new_item>-Artor
*                                 ELSE '' ).
*    .
*    <new_item>-ArtdestCode =  COND #(  WHEN  <new_head>-Trans = '02' THEN <new_item>-Artdest
*                                 ELSE '' )
*                                .
*
*    MODIFY ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
*      ENTITY Items
*      CREATE FIELDS ( Trans Artor Artdest )
*         WITH items
*      MAPPED DATA(mapped_create).
*
*    " set the new BO instances
*    mapped-head   =  mapped_create-head .
*
*
*
*
*
*  ENDMETHOD.

  METHOD customCreateItem.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Head RESULT result.
    METHODS customcreate FOR MODIFY
      IMPORTING keys FOR ACTION head~customcreate.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.


ENDCLASS.

CLASS lhc_Head IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD customCreate.
    DATA:
      heads    TYPE TABLE FOR CREATE zso_cds_i_escandallo_head,
      lv_error TYPE abap_boolean.



    IF lines( keys ) > 1.
      LOOP AT keys INTO DATA(ls_key).
        INSERT VALUE #( %cid = ls_key-%cid %action-customCreate = if_abap_behv=>mk-on  ) INTO TABLE failed-head.
        RETURN.
      ENDLOOP.
    ENDIF.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.

    IF <fs_key>-%param-trans IS INITIAL OR <fs_key>-%param-art IS INITIAL.
      INSERT VALUE #( %cid = ls_key-%cid %action-customCreate = if_abap_behv=>mk-on  ) INTO TABLE failed-head.
      reported-head = VALUE #(
          (
                %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-success
                            text = 'Debe indicar tipo de transformación y articulo único' )
                       )
          ).
      RETURN.
    ENDIF.



    " fill in travel container for creating new travel instance
    APPEND VALUE #(
                     %cid      = <fs_key>-%cid
                     %is_draft = <fs_key>-%param-%is_draft
                     %data     = CORRESPONDING #( <fs_key>-%param )
                )
    TO heads ASSIGNING FIELD-SYMBOL(<new_head>).

    <new_head>-Artor = <new_head>-ArtorEdit    = COND #(  WHEN  <new_head>-Trans = '01' THEN <fs_key>-%param-art
                                                          WHEN  <new_head>-Trans = '03' THEN '*'
                                                          ELSE <fs_key>-%param-art )
                                .

    <new_head>-Artdest = <new_head>-ArtdestEdit = COND #( WHEN  <new_head>-Trans = '01' THEN '*'
                                                          WHEN  <new_head>-Trans = '03' THEN <fs_key>-%param-art
                                                          ELSE  '*' )
                                .


    MODIFY ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
      ENTITY Head
      CREATE FIELDS ( Trans Artor Artdest ArtorEdit ArtdestEdit  )
         WITH heads
      MAPPED DATA(mapped_create)
      FAILED DATA(failed_create)
      REPORTED DATA(reported_create).

    " set the new BO instances
    mapped-head   =  mapped_create-head .
    failed-head   = failed_create-head.
    reported-head = reported_create-head.

  ENDMETHOD.



  METHOD get_instance_features.

    READ ENTITIES OF zso_cds_i_escandallo_head IN LOCAL MODE
    ENTITY Head
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(heads).

    READ TABLE heads INTO DATA(ls_head) INDEX 1.

    result =  VALUE #( FOR <fs_key> IN keys (  %tky = <fs_key>-%tky

                                            %field-ArtorEdit   = COND #(
                                                                         WHEN  ls_head-ArtorEdit   <> '*'   AND <fs_key>-%is_draft EQ '01' THEN if_abap_behv=>fc-f-mandatory
                                                                         WHEN  ls_head-ArtorEdit   <> '*'   AND <fs_key>-%is_draft EQ '00' THEN if_abap_behv=>fc-f-read_only
                                                                         WHEN  ls_head-ArtorEdit    = '*'   THEN if_abap_behv=>fc-f-read_only )
                                            %field-ArtdestEdit = COND #( WHEN  ls_head-ArtdestEdit <> '*'   AND <fs_key>-%is_draft EQ '01' THEN if_abap_behv=>fc-f-mandatory
                                                                         WHEN  ls_head-ArtdestEdit <> '*'   AND <fs_key>-%is_draft EQ '00' THEN if_abap_behv=>fc-f-read_only
                                                                         WHEN  ls_head-ArtdestEdit  = '*'   THEN if_abap_behv=>fc-f-read_only )
                                                             ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZSO_CDS_I_ESCANDALLO_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZSO_CDS_I_ESCANDALLO_HEAD IMPLEMENTATION.

  METHOD save_modified.

    DATA: head     TYPE STANDARD TABLE OF zso_t_escanda_h,
          items    TYPE STANDARD TABLE OF zso_t_escanda_i,
          itemst   TYPE STANDARD TABLE OF zso_t_escandal_t,
          controls TYPE STANDARD TABLE OF zso_x_escanda_h,
          lv_field TYPE i
          .

    IF create IS NOT INITIAL.
      head  = CORRESPONDING #( create-head MAPPING FROM ENTITY ).

      SELECT _t~*
      FROM zso_t_escandal_t AS _t
      INNER JOIN @create-items AS _i ON _i~trans = _t~trans
                                   AND _i~artor = _t~artor
                                   AND _i~receta = _t~receta
      INTO TABLE @DATA(lt_receta).


      LOOP AT create-items ASSIGNING FIELD-SYMBOL(<fs_item>).
        READ TABLE lt_receta WITH KEY trans = <fs_item>-Trans
                                      artor = <fs_item>-Artor
                                      receta = <fs_item>-Receta INTO DATA(ls_receta).
        APPEND INITIAL LINE TO items ASSIGNING FIELD-SYMBOL(<fs_i>).
        MOVE-CORRESPONDING <fs_item> TO <fs_i>.
        <fs_i>-artor_code   = <fs_item>-ArtorCode.
        <fs_i>-artdest_code = <fs_item>-ArtdestCode.
        IF ls_receta IS INITIAL.
          APPEND INITIAL LINE TO itemst ASSIGNING FIELD-SYMBOL(<fs_it>).
          MOVE-CORRESPONDING <fs_item> TO <fs_it>.
          <fs_it>-receta_desc = <fs_item>-RecetaDesc.
          <fs_it>-spras       = sy-langu.
        ENDIF.
      ENDLOOP.
      INSERT zso_t_escanda_h  FROM TABLE @head.
      INSERT zso_t_escanda_i  FROM TABLE @items.
      INSERT zso_t_escandal_t FROM TABLE @itemst.
    ENDIF.
    IF update IS NOT INITIAL.
      head = CORRESPONDING #( update-head MAPPING FROM ENTITY ).
*      Obtener ITEMS OLD
      SELECT _t~*
             FROM zso_t_escanda_i AS _t
             INNER JOIN @create-items AS _i ON _i~trans = _t~trans
                                          AND _i~artor = _t~artor
                                          AND _i~Artdest = _t~artdest
                                  AND _i~receta = _t~receta
                                  AND _i~ArtorCode = _t~artor_code
                                  AND _i~ArtdestCode = _t~artdest_code
        INTO TABLE @DATA(lt_items).
*       Obtener receta OLD
      SELECT _t~*
           FROM zso_t_escandal_t AS _t
           INNER JOIN @create-items AS _i ON _i~trans = _t~trans
                                         AND _i~artor = _t~artor
                                         AND _i~receta = _t~receta
           INTO TABLE @lt_receta.

      LOOP AT update-items ASSIGNING <fs_item>.
        DATA(ls_control) = <fs_item>-%control.
        lv_field = 8.
        APPEND INITIAL LINE TO items ASSIGNING <fs_i>.
        APPEND INITIAL LINE TO itemst ASSIGNING <fs_it>.
*       Obtener datos ITEMS OLD
        READ TABLE lt_items WITH KEY  trans = <fs_item>-Trans
                                      artor = <fs_item>-Artor
                                      Artdest = <fs_item>-Artdest
                                      receta = <fs_item>-Receta
                                      artor_code = <fs_item>-ArtorCode
                                      artdest_code = <fs_item>-ArtdestCode
                                      INTO DATA(ls_item).
*        Obtener datos receta OLD
        READ TABLE lt_receta WITH KEY trans = <fs_item>-Trans
                                      artor = <fs_item>-Artor
                                      receta = <fs_item>-Receta INTO ls_receta.

        MOVE-CORRESPONDING <fs_item> TO <fs_i>.
        MOVE-CORRESPONDING <fs_item> TO <fs_it>.
        DO.
          ASSIGN COMPONENT lv_field OF STRUCTURE ls_control TO FIELD-SYMBOL(<v_flag>).
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          IF <v_flag> = abap_true.
            ASSIGN COMPONENT lv_field OF STRUCTURE <fs_item> TO FIELD-SYMBOL(<v_field_new>).
            ASSERT sy-subrc = 0.
            ASSIGN COMPONENT lv_field OF STRUCTURE ls_item TO FIELD-SYMBOL(<v_field_old>).
            ASSERT sy-subrc = 0.
            <v_field_old> = <v_field_new>.
          ENDIF.
          lv_field = lv_field + 1.
        ENDDO.

        IF <fs_item>-RecetaDesc IS NOT INITIAL.
          <fs_it>-receta_desc = <fs_item>-RecetaDesc.
          <fs_it>-spras = sy-langu.
        ELSE.
          DELETE itemst INDEX lines( itemst ).
        ENDIF.

      ENDLOOP.
      UPDATE zso_t_escanda_h  FROM TABLE @head.
      UPDATE zso_t_escanda_i  FROM TABLE @items.
      UPDATE zso_t_escandal_t FROM TABLE @itemst.
    ENDIF.
    IF delete IS NOT INITIAL.
      head = CORRESPONDING #( delete-head MAPPING FROM ENTITY ).
      IF lines(  head ) > 0.
        READ TABLE head INTO DATA(ls_head) INDEX 1.
        DELETE FROM zso_t_escanda_h  WHERE trans = @ls_head-trans AND artor = @ls_head-artor AND artdest = @ls_head-artdest.
      ENDIF.
      LOOP AT delete-items ASSIGNING FIELD-SYMBOL(<fs_itemd>).
        DELETE FROM zso_t_escanda_i  WHERE trans = @<fs_itemd>-trans AND artor = @<fs_itemd>-artor AND artdest = @<fs_itemd>-artdest.
        DELETE FROM zso_t_escandal_t WHERE trans = @<fs_itemd>-trans AND artor = @<fs_itemd>-artor.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
