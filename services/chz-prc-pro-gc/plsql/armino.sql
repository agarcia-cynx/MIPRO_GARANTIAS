CREATE SEQUENCE cz_mi.sqmino
MINVALUE 1
MAXVALUE 9999999999
INCREMENT BY 1
START WITH 1;

CREATE TABLE cz_mi.armino (
  notificacion            NUMBER          NOT NULL,
  solicitud               VARCHAR2(14)    NOT NULL,
  titulo                  VARCHAR2(1000)   NOT NULL,
  mensaje                 VARCHAR2(4000)  NOT NULL,
  tipo                    VARCHAR2(1)     NOT NULL,
  fecha_emision           DATE            NOT NULL,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

ALTER TABLE cz_mi.armino
  ADD CONSTRAINT armino_pk PRIMARY KEY (notificacion) USING INDEX;

ALTER TABLE cz_mi.armino
  ADD CONSTRAINT armino_arminot FOREIGN KEY (tipo)
  REFERENCES cz_mi.arminot (tipo);

CREATE INDEX cz_mi.armino_arminot_fk ON cz_mi.armino (tipo);

CREATE OR REPLACE
TRIGGER cz_mi.armino_br
BEFORE INSERT OR UPDATE
ON cz_mi.armino
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.notificacion     := cz_mi.sqmino.NEXTVAL;
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
