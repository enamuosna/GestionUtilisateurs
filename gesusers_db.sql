
DROP TABLE IF EXISTS utilisateurs;
DROP TYPE  IF EXISTS role_type;

CREATE TYPE role_type AS ENUM ('ADMIN', 'USER');

CREATE TABLE utilisateurs (
    id       SERIAL       PRIMARY KEY,
    nom      VARCHAR(100) NOT NULL,
    prenom   VARCHAR(100) NOT NULL,
    email    VARCHAR(150) NOT NULL DEFAULT '',
    login    VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role     role_type    NOT NULL DEFAULT 'USER',
    actif    BOOLEAN      NOT NULL DEFAULT TRUE
);


INSERT INTO utilisateurs (nom, prenom, email, login, password, role, actif) VALUES
    ('Admin',   'Super',   'admin@gesusers.sn',   'admin',   'admin',   'ADMIN', TRUE),
    ('Camara',  'Lamine',  'lamine@gesusers.sn',   'lamine',  'pass123', 'USER',  TRUE),
    ('Faye',    'Toumane', 'toumane@gesusers.sn',  'toumane', 'pass456', 'ADMIN', TRUE),
    ('Diedhiou','Paby',    'paby@gesusers.sn',     'paby',    'pass789', 'USER',  TRUE);

SELECT id, nom, prenom, email, login, role, actif FROM utilisateurs;
