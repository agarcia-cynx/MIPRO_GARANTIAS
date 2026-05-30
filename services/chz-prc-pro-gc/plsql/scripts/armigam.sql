CREATE TABLE cz_mi.armigam (
  media                   NUMBER(7)       NOT NULL,
  garantia                VARCHAR2(14)    NOT NULL,
  url                     VARCHAR2(500)   NOT NULL,
  tipo                    VARCHAR2(50)    NOT NULL,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

COMMENT ON TABLE cz_mi.armigam IS 'Almacena referencias a archivos multimedia (fotos/videos) asociados a un ticket de garantia.';
COMMENT ON COLUMN cz_mi.armigam.media IS 'Identificador unico del recurso multimedia.';
COMMENT ON COLUMN cz_mi.armigam.garantia IS 'FK a armiga: ticket de garantia padre.';
COMMENT ON COLUMN cz_mi.armigam.url IS 'Ruta de acceso o URL del archivo cargado.';
COMMENT ON COLUMN cz_mi.armigam.tipo IS 'Extension o MIME type del archivo (ej. image/jpeg, video/mp4).';
COMMENT ON COLUMN cz_mi.armigam.fecha_crea IS 'Fecha y hora de creacion del registro.';
COMMENT ON COLUMN cz_mi.armigam.fecha_modifica IS 'Fecha y hora de la ultima modificacion.';
COMMENT ON COLUMN cz_mi.armigam.usuario_crea IS 'Usuario que creo el registro (auditoria).';
COMMENT ON COLUMN cz_mi.armigam.usuario_modifica IS 'Usuario de la ultima modificacion (auditoria).';

ALTER TABLE cz_mi.armigam
  ADD CONSTRAINT armigam_pk PRIMARY KEY (garantia, media) USING INDEX;

ALTER TABLE cz_mi.armigam
  ADD CONSTRAINT armigam_armiga FOREIGN KEY (garantia)
  REFERENCES cz_mi.armiga (garantia);

CREATE INDEX cz_mi.armigam_armiga_fk ON cz_mi.armigam (garantia);

CREATE OR REPLACE
TRIGGER cz_mi.armigam_br
BEFORE INSERT OR UPDATE
ON cz_mi.armigam
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.media            := cz_mi.sqmigam.NEXTVAL;
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
