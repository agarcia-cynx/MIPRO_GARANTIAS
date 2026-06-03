CREATE SEQUENCE cz_mi.sqmiiso
MINVALUE 1
MAXVALUE 9999999999
INCREMENT BY 1
START WITH 1;

CREATE TABLE cz_mi.armiso (
  solicitud               VARCHAR2(14)    NOT NULL,
  cliente                 VARCHAR2(36)    NOT NULL,
  direccion               VARCHAR2(36)    NOT NULL,
  tipo                    VARCHAR2(1)     NOT NULL,
  estado                  VARCHAR2(1)     NOT NULL,
  descripcion             VARCHAR2(4000)  NOT NULL,
  factura                 VARCHAR2(100),
  empresa                 VARCHAR2(200),
  subtotal                NUMBER(20,2)    NOT NULL,
  descuento               NUMBER(20,2)    NOT NULL,
  impuesto                NUMBER(20,2)    NOT NULL,
  total                   NUMBER(20,2)    NOT NULL,
  tecnico                 NUMBER,
  inicio                  DATE,
  fin                     DATE,
  fecha_crea              DATE            NOT NULL,
  fecha_modifica          DATE,
  usuario_crea            VARCHAR2(30)    NOT NULL,
  usuario_modifica        VARCHAR2(30)
);

ALTER TABLE cz_mi.armiso
  ADD CONSTRAINT armiso_pk PRIMARY KEY (solicitud) USING INDEX;

ALTER TABLE cz_mi.armiso
  ADD CONSTRAINT armiso_armisot FOREIGN KEY (tipo)
  REFERENCES cz_mi.armisot (tipo);

ALTER TABLE cz_mi.armiso
  ADD CONSTRAINT armiso_armisoe FOREIGN KEY (estado)
  REFERENCES cz_mi.armisoe (estado);

ALTER TABLE cz_mi.armiso
  ADD CONSTRAINT armiso_armitc FOREIGN KEY (tecnico)
  REFERENCES cz_mi.armitc (tecnico);

CREATE INDEX cz_mi.armiso_armisot_fk ON cz_mi.armiso (tipo);
CREATE INDEX cz_mi.armiso_armisoe_fk ON cz_mi.armiso (estado);
CREATE INDEX cz_mi.armiso_armitc_fk ON cz_mi.armiso (tecnico);

CREATE OR REPLACE
TRIGGER cz_mi.armiso_br
BEFORE INSERT OR UPDATE
ON cz_mi.armiso
REFERENCING NEW AS NEW
            OLD AS OLD
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.solicitud        := 'SOL-' || TO_CHAR(cz_mi.sqmiiso.NEXTVAL);
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
