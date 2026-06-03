CREATE TABLE cz_mi.armisos (
  solicitud               VARCHAR2(14)    NOT NULL,
  linea                   NUMBER(3)       NOT NULL,
  no_arti                 VARCHAR2(15)    NOT NULL,
  precio                  NUMBER(20,2)    NOT NULL,
  cantidad                NUMBER(4)       DEFAULT 1 NOT NULL,
  subtotal                NUMBER(20,2)    NOT NULL,
  descuento               NUMBER(20,2)    NOT NULL,
  impuesto                NUMBER(20,2)    NOT NULL,
  total                   NUMBER(20,2)    NOT NULL,
  tecnico                 NUMBER,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

ALTER TABLE cz_mi.armisos
  ADD CONSTRAINT armisos_pk PRIMARY KEY (solicitud,linea,no_arti) USING INDEX;

ALTER TABLE cz_mi.armisos
  ADD CONSTRAINT armisos_armiso FOREIGN KEY (solicitud)
  REFERENCES cz_mi.armiso (solicitud);

ALTER TABLE cz_mi.armisos
  ADD CONSTRAINT armisos_arinda FOREIGN KEY (no_arti)
  REFERENCES cz_in.arinda (no_arti);

CREATE INDEX cz_mi.armisos_armiso_fk ON cz_mi.armisos (solicitud);
CREATE INDEX cz_mi.armisos_arinda_fk ON cz_mi.armisos (no_arti);

CREATE OR REPLACE
TRIGGER cz_mi.armisos_br
BEFORE INSERT OR UPDATE
ON cz_mi.armisos
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
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
