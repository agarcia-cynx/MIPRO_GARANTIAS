CREATE TABLE cz_mi.armiga (
  garantia                VARCHAR2(14)    NOT NULL,
  cliente                 VARCHAR2(36)    NOT NULL,
  factura                 VARCHAR2(100),
  key_docu                VARCHAR2(100),
  no_arti                 VARCHAR2(15),
  categoria               VARCHAR2(1)     NOT NULL,
  marca                   VARCHAR2(1),
  lugar_compra            VARCHAR2(1)     NOT NULL,
  modelo                  VARCHAR2(100),
  numero_serie            VARCHAR2(100),
  fecha_compra            DATE,
  descipcion              VARCHAR2(4000)  NOT NULL,
  direccion               VARCHAR2(36)    NOT NULL,
  estado                  VARCHAR2(1)     NOT NULL,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

COMMENT ON TABLE cz_mi.armiga IS 'Tabla principal de registro de garantias de MIPRO. Almacena las garantias registradas por el cliente.';
COMMENT ON COLUMN cz_mi.armiga.garantia IS 'Identificador de la garantia: prefijo GAR- y numero secuencial de sqmiga.';
COMMENT ON COLUMN cz_mi.armiga.cliente IS 'Cliente que registra la garantia.';
COMMENT ON COLUMN cz_mi.armiga.factura IS 'Numero de factura asociado al producto.';
COMMENT ON COLUMN cz_mi.armiga.key_docu IS 'Llave del documento fiscal asociado.';
COMMENT ON COLUMN cz_mi.armiga.no_arti IS 'SKU o codigo del articulo.';
COMMENT ON COLUMN cz_mi.armiga.categoria IS 'Categoria del producto (Codigo de 1 caracter).';
COMMENT ON COLUMN cz_mi.armiga.marca IS 'Marca del equipo (Codigo de 1 caracter).';
COMMENT ON COLUMN cz_mi.armiga.lugar_compra IS 'Lugar o sucursal de compra (Codigo de 1 caracter).';
COMMENT ON COLUMN cz_mi.armiga.modelo IS 'Modelo especifico del equipo.';
COMMENT ON COLUMN cz_mi.armiga.numero_serie IS 'Numero de serie fisico del equipo.';
COMMENT ON COLUMN cz_mi.armiga.fecha_compra IS 'Fecha de adquisicion declarada.';
COMMENT ON COLUMN cz_mi.armiga.descipcion IS 'Explicacion detallada del fallo reportado.';
COMMENT ON COLUMN cz_mi.armiga.direccion IS 'Identificador de la direccion asociada (cz_mi.armccld).';
COMMENT ON COLUMN cz_mi.armiga.estado IS 'Codigo del estado del ticket de garantia (VARCHAR2(1)).';
COMMENT ON COLUMN cz_mi.armiga.fecha_crea IS 'Fecha y hora de creacion del registro.';
COMMENT ON COLUMN cz_mi.armiga.fecha_modifica IS 'Fecha y hora de la ultima modificacion.';
COMMENT ON COLUMN cz_mi.armiga.usuario_crea IS 'Usuario que creo el registro (auditoria).';
COMMENT ON COLUMN cz_mi.armiga.usuario_modifica IS 'Usuario de la ultima modificacion (auditoria).';

ALTER TABLE cz_mi.armiga
  ADD CONSTRAINT armiga_pk PRIMARY KEY (garantia) USING INDEX;

CREATE INDEX cz_mi.armiga_cliente_fk ON cz_mi.armiga (cliente);
CREATE INDEX cz_mi.armiga_direccion_fk ON cz_mi.armiga (direccion);

CREATE OR REPLACE
TRIGGER cz_mi.armiga_br
BEFORE INSERT OR UPDATE
ON cz_mi.armiga
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.garantia         := 'GAR-' || TO_CHAR(cz_mi.sqmiga.NEXTVAL);
    :NEW.usuario_crea     := USER;
    :NEW.fecha_crea       := SYSDATE;
    :NEW.usuario_modifica := USER;
    :NEW.fecha_modifica   := SYSDATE;
  ELSIF UPDATING THEN
    :NEW.usuario_modifica := USER;
    :NEW.usuario_crea     := :OLD.usuario_crea;
    :NEW.fecha_modifica   := SYSDATE;
    :NEW.fecha_crea       := :OLD.fecha_crea;
  END IF;
END;
/
