CREATE SEQUENCE cz_mi.sqmitc
MINVALUE 1
MAXVALUE 99999
INCREMENT BY 1
START WITH 1;

CREATE TABLE cz_mi.armitc (
  tecnico                 NUMBER          NOT NULL,
  no_prove                VARCHAR2(18)          NOT NULL,
  identificacion          VARCHAR2(75)    NOT NULL,
  tipo_identificacion     VARCHAR2(1)     NOT NULL,
  nombre                  VARCHAR2(150)   NOT NULL,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

ALTER TABLE cz_mi.armitc
  ADD CONSTRAINT armitc_pk PRIMARY KEY (tecnico) USING INDEX;

ALTER TABLE cz_mi.armitc
  ADD CONSTRAINT armitc_pk2 UNIQUE (no_prove, identificacion, tipo_identificacion) USING INDEX;

ALTER TABLE cz_mi.armitc
  ADD CONSTRAINT armitc_arinmp FOREIGN KEY (no_prove)
  REFERENCES cz_in.arinmp (no_prove);

CREATE INDEX cz_mi.armitc_arinmp_fk ON cz_mi.armitc (no_prove);

CREATE OR REPLACE
TRIGGER cz_mi.armitc_br
BEFORE INSERT OR UPDATE
ON cz_mi.armitc
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.tecnico          := cz_mi.sqmitc.NEXTVAL;
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
