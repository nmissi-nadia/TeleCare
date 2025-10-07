-- PostgreSQL setup (run as postgres superuser)
CREATE DATABASE teleexpertise;
CREATE USER teleuser WITH PASSWORD 'telepass';
GRANT ALL PRIVILEGES ON DATABASE teleexpertise TO teleuser;

-- Seed actes
\c teleexpertise
CREATE TABLE actes (
  id serial PRIMARY KEY,
  nom varchar(255) NOT NULL,
  cout double precision
);

INSERT INTO actes (nom, cout) VALUES ('Radiographie', 120.0), ('ECG', 80.0), ('Analyse sang', 50.0);

-- Note: JPA will create other tables automatically with hbm2ddl.auto=update
