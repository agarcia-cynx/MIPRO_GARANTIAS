CREATE SEQUENCE cz_mi.sqmisosm
MINVALUE 1
MAXVALUE 9999999999
INCREMENT BY 1
START WITH 1;

CREATE TABLE cz_mi.armisosm (
  solicitud               VARCHAR2(14)    NOT NULL,
  linea                   NUMBER(3)       NOT NULL,
  no_arti                 VARCHAR2(15)    NOT NULL,
  media                   NUMBER(10)      NOT NULL,
  descripcion             VARCHAR2(4000),
  url                     VARCHAR2(500)   NOT NULL,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

ALTER TABLE cz_mi.armisosm
  ADD CONSTRAINT armisosm_pk PRIMARY KEY (solicitud,linea,no_arti,media) USING INDEX;

ALTER TABLE cz_mi.armisosm
  ADD CONSTRAINT armisosm_armisos FOREIGN KEY (solicitud,linea,no_arti)
  REFERENCES cz_mi.armisos (solicitud,linea,no_arti);

CREATE INDEX cz_mi.armisosm_armisos_fk ON cz_mi.armisosm (solicitud, linea, no_arti);

CREATE OR REPLACE
TRIGGER cz_mi.armisosm_br
BEFORE INSERT OR UPDATE
ON cz_mi.armisosm
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.media            := cz_mi.sqmisosm.NEXTVAL;
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
