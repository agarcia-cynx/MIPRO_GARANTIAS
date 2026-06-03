CREATE OR REPLACE PACKAGE cz_mi.SKMI AS

  PROCEDURE SOLICITUD(P_IN    IN     CLOB,
                      P_OUT      OUT CLOB,
                      P_ERROR IN OUT VARCHAR2);

  PROCEDURE CATALOGOS(P_OUT OUT CLOB, P_ERROR IN OUT VARCHAR2);

  PROCEDURE CONSULTA_SOLICITUD(P_IN    IN     CLOB,
                               P_OUT      OUT CLOB,
                               P_ERROR IN OUT VARCHAR2);

END SKMI;
/

CREATE OR REPLACE PACKAGE BODY cz_mi.SKMI AS

  PROCEDURE SOLICITUD( P_IN    IN     CLOB,
                       P_OUT      OUT CLOB,
                       P_ERROR IN OUT VARCHAR2) IS
    v_step             VARCHAR2(200) := 'INICIO';
    ji                 json_object_t;
    ja                 json_array_t;
    jo                 json_object_t;
    r_so               cz_mi.armiso%ROWTYPE;
    r_sos              cz_mi.armisos%ROWTYPE;
  BEGIN
    SAVEPOINT sp_skmi_solicitud;
    P_ERROR              := NULL;
    v_step               := 'PARSE JSON';
    ji                   := json_object_t(P_IN);
    ja                   := ji.get_array('servicios');
    r_so.solicitud       := ji.get_string('solicitud');
    r_so.cliente         := ji.get_string('cliente');
    r_so.direccion       := ji.get_string('direccion');
    r_so.descripcion     := TRIM(ji.get_string('descripcion'));
    r_so.empresa         := ji.get_string('empresa');
    r_so.subtotal        := ji.get_number('subtotal');
    r_so.total           := ji.get_number('total');
    r_so.descuento       := ji.get_number('descuento');
    r_so.impuesto        := ji.get_number('impuesto');
    r_so.factura         := ji.get_string('factura');
    r_so.tipo            := ji.get_string('tipo');
    r_so.estado          := ji.get_string('estado');
    r_so.tecnico         := ji.get_number('tecnico');
    r_so.inicio          := to_date(ji.get_string('inicio'), 'YYYY-MM-DD');
    r_so.fin             := to_date(ji.get_string('fin'), 'YYYY-MM-DD');

    IF r_so.solicitud IS NULL THEN
      v_step := 'INSERT-ARMISO';

      INSERT INTO cz_mi.armiso VALUES r_so
      RETURNING solicitud INTO r_so.solicitud;

      IF SQL%ROWCOUNT = 0 THEN
        RAISE no_data_found;
      END IF;
    ELSE
      v_step := 'UPDATE-ARMISO';

      UPDATE cz_mi.armiso s
         SET s.subtotal  = r_so.subtotal,
             s.total     = r_so.total,
             s.descuento = r_so.descuento,
             s.impuesto  = r_so.impuesto,
             s.factura   = r_so.factura,
             s.estado    = r_so.estado,
             s.tecnico   = r_so.tecnico,
             s.inicio    = r_so.inicio,
             s.fin       = r_so.fin
       WHERE s.solicitud = r_so.solicitud;

      IF SQL%ROWCOUNT = 0 THEN
        RAISE no_data_found;
      END IF;
    END IF;

    v_step := 'INSERT/UPDATE-ARMISOS';
    FOR i IN 0 .. ja.get_size - 1 LOOP
      jo := json_object_t(ja.get(i));

      v_step := 'PARSE-ARMISOS:'||i;
      r_sos.solicitud := r_so.solicitud;
      r_sos.no_arti   := jo.get_string('no_arti');
      r_sos.precio    := jo.get_number('precio');
      r_sos.cantidad  := jo.get_number('cantidad');
      r_sos.subtotal  := jo.get_number('subtotal');
      r_sos.descuento := jo.get_number('descuento');
      r_sos.impuesto  := jo.get_number('impuesto');
      r_sos.total     := jo.get_number('total');
      r_sos.tecnico   := jo.get_number('tecnico');
      r_sos.linea     := jo.get_number('linea');

      v_step := 'UPDATE-ARMISOS:' || r_sos.solicitud || ':' || r_sos.linea || ':' || r_sos.no_arti;

      UPDATE cz_mi.armisos a
         SET a.precio    = r_sos.precio,
             a.cantidad  = r_sos.cantidad,
             a.subtotal  = r_sos.subtotal,
             a.descuento = r_sos.descuento,
             a.impuesto  = r_sos.impuesto,
             a.total     = r_sos.total,
             a.tecnico   = r_sos.tecnico
       WHERE a.solicitud = r_sos.solicitud
         AND a.linea     = r_sos.linea
         AND a.no_arti   = r_sos.no_arti;

      IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO cz_mi.armisos VALUES r_sos;
      END IF;
    END LOOP;

    v_step := 'COMMIT';
    COMMIT;

    v_step := 'OUT';

    SELECT JSON_OBJECT(
             'solicitud' VALUE r_so.solicitud,
             'error'     VALUE ''
             RETURNING CLOB)
      INTO P_OUT
      FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := 'SKMI.SOLICITUD:' || NVL(P_ERROR, v_step || ':' || SQLERRM);
      BEGIN
        ROLLBACK TO sp_skmi_solicitud;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      SELECT JSON_OBJECT(
               'solicitud' VALUE '',
               'error'     VALUE P_ERROR
               RETURNING CLOB)
        INTO P_OUT
        FROM DUAL;
  END SOLICITUD;

  PROCEDURE CONSULTA_SOLICITUD(P_IN    IN     CLOB,
                               P_OUT      OUT CLOB,
                               P_ERROR IN OUT VARCHAR2) IS
    v_step    VARCHAR2(200) := 'INICIO';
    ji        json_object_t;
    v_id_sol  VARCHAR2(40);
    v_err     VARCHAR2(4000);
  BEGIN
    P_ERROR := NULL;
    v_step  := 'JSON';
    ji      := json_object_t(P_IN);

    v_step := 'PARSE-SOLICITUD';
    v_id_sol := ji.get_string('solicitud');
    IF v_id_sol IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'solicitud obligatoria o invalida'); END IF;

    v_step := 'SEL-SOLICITUD';
    SELECT JSON_OBJECT(
             'solicitud' VALUE JSON_OBJECT(
               'solicitud' VALUE s.solicitud,
               'cliente' VALUE s.cliente,
               'direccion' VALUE s.direccion,
               'descripcion' VALUE s.descripcion,
               'empresa' VALUE s.empresa,
               'factura' VALUE s.factura,
               'tipo' VALUE NVL(tt.nombre, s.tipo),
               'impuesto' VALUE s.impuesto,
               'descuento' VALUE s.descuento,
               'subtotal' VALUE s.subtotal,
               'total' VALUE s.total,
               'servicios' VALUE (
                 SELECT COALESCE(
                          JSON_ARRAYAGG(
                            JSON_OBJECT(
                              'linea' VALUE x.linea,
                              'no_arti' VALUE x.no_arti,
                              'precio' VALUE x.precio,
                              'cantidad' VALUE NVL(x.cantidad, 0),
                              'subtotal' VALUE NVL(x.subtotal, 0),
                              'descuento' VALUE NVL(x.descuento, 0),
                              'impuesto' VALUE NVL(x.impuesto, 0),
                              'total' VALUE NVL(x.total, 0))
                            ORDER BY x.linea
                            RETURNING CLOB),
                          TO_CLOB('[]'))
                   FROM cz_mi.armisos x
                  WHERE x.solicitud = s.solicitud
               )
               RETURNING CLOB),
             'error' VALUE ''
             RETURNING CLOB)
      INTO P_OUT
      FROM cz_mi.armiso s
      LEFT JOIN cz_mi.armisot tt ON tt.tipo = s.tipo
     WHERE s.solicitud = v_id_sol;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_ERROR := SUBSTR(v_step || ':Solicitud no existe: ' || v_id_sol,
                        1,
                        4000);
      SELECT JSON_OBJECT(
               'solicitud' VALUE '',
               'error' VALUE P_ERROR
               RETURNING CLOB)
        INTO P_OUT
        FROM DUAL;
    WHEN OTHERS THEN
      v_err := SUBSTR(v_step || ':' || SQLERRM, 1, 4000);
      P_ERROR := v_err;
      SELECT JSON_OBJECT(
               'solicitud' VALUE '',
               'error' VALUE P_ERROR
               RETURNING CLOB)
        INTO P_OUT
        FROM DUAL;
  END CONSULTA_SOLICITUD;

  PROCEDURE CATALOGOS(P_OUT OUT CLOB, P_ERROR IN OUT VARCHAR2) IS
    v_step VARCHAR2(200) := 'INICIO';
  BEGIN
    P_ERROR := NULL;
    v_step  := 'CATALOGOS-JSON';

    SELECT JSON_OBJECT(
             'catalogos' VALUE JSON_OBJECT(
               'tipo_solicitud' VALUE (
                 SELECT COALESCE(
                          JSON_ARRAYAGG(
                            JSON_OBJECT('tipo' VALUE t.tipo, 'nombre' VALUE t.nombre)
                            ORDER BY t.tipo
                            RETURNING CLOB),
                          TO_CLOB('[]'))
                   FROM cz_mi.armisot t
               ),
               'estado_solicitud' VALUE (
                 SELECT COALESCE(
                          JSON_ARRAYAGG(
                            JSON_OBJECT('estado' VALUE e.estado, 'nombre' VALUE e.nombre)
                            ORDER BY e.estado
                            RETURNING CLOB),
                          TO_CLOB('[]'))
                   FROM cz_mi.armisoe e
               ),
                'tecnicos' VALUE (
                  SELECT COALESCE(
                           JSON_ARRAYAGG(
                             JSON_OBJECT(
                               'tecnico'             VALUE tc.tecnico,
                               'no_prove'            VALUE tc.no_prove,
                               'identificacion'      VALUE tc.identificacion,
                               'tipo_identificacion' VALUE tc.tipo_identificacion,
                               'nombre'              VALUE tc.nombre
                             )
                             ORDER BY tc.nombre
                             RETURNING CLOB),
                           TO_CLOB('[]'))
                    FROM cz_mi.armitc tc
                )
             ),
             'error' VALUE ''
             RETURNING CLOB)
      INTO P_OUT
      FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := SUBSTR(v_step || ':' || SQLERRM, 1, 4000);
      SELECT JSON_OBJECT(
               'catalogos' VALUE JSON_OBJECT(
                 'tipo_solicitud' VALUE TO_CLOB('[]'),
                 'estado_solicitud' VALUE TO_CLOB('[]')
               ),
               'error' VALUE P_ERROR
               RETURNING CLOB)
        INTO P_OUT
        FROM DUAL;
  END CATALOGOS;

END SKMI;
/
