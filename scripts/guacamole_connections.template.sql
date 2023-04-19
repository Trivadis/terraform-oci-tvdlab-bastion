-- ----------------------------------------------------------------------------
-- Trivadis AG, Infrastructure Managed Services
-- Saegereistrasse 29, 8152 Glattbrugg, Switzerland
-- ----------------------------------------------------------------------------
-- Name.......: 02_connections.sql
-- Author.....: Stefan Oehrli (oes) stefan.oehrli@accenture.com
-- Editor.....: Stefan Oehrli
-- Date.......: 2020.11.22
-- Revision...: 
-- Purpose....: Template file for guacamole connections
-- Notes......: 
-- Reference..: --
-- -----------------------------------------------------------------------------

-- Set guacamole DB ------------------------------------------------------------
use guacadb;

-- Create connection -----------------------------------------------------------
-- INSERT INTO guacamole_connection (connection_name, protocol) VALUES ('Windows Server (ad - 10.0.1.4)', 'rdp');
-- INSERT INTO guacamole_connection (connection_name, protocol) VALUES ('Database Server (db - 10.0.1.6)', 'ssh');

-- Add parameters to the Windows Server connection -----------------------------
-- INSERT INTO guacamole_connection_parameter VALUES (1, 'hostname', '10.0.1.4');
-- INSERT INTO guacamole_connection_parameter VALUES (1, 'port', '3389');
-- INSERT INTO guacamole_connection_parameter VALUES (1, 'username', 'Administrator');
---INSERT INTO guacamole_connection_parameter VALUES (1, 'password', 'Welcome1');

-- Add parameters to the Database Server connection ----------------------------
-- INSERT INTO guacamole_connection_parameter VALUES (2, 'hostname', '10.0.1.6');
-- INSERT INTO guacamole_connection_parameter VALUES (2, 'port', '22');
-- INSERT INTO guacamole_connection_parameter VALUES (2, 'username', 'oracle');
-- INSERT INTO guacamole_connection_parameter VALUES (2, 'private-key', '-----BEGIN RSA PRIVATE KEY-----
-- MIIEowIBAAKCAQEA0KfOVyCBQyBonPkRmkT/YKXblIX/14S4TzVaEWcLpZWjUD5y
-- AsIUH9OafGZyPQ2GLrlHi9891q2z0rkO4ENu+Z4DAn92O6HRHWrUvOroC0KHrjQJ
-- ...
-- B1aWGWRN7wdFjI/nWlOITarNo/hL7EmI5oAN1BzKvkvYDXqtd8gxJUMFXSl0qY86
-- 944ZZqNHnbHfwb2+aEU75jCK9BEBp2aCCI4FN2p0KP/+1zbk5A3u
-- -----END RSA PRIVATE KEY-----');

-- EOF -------------------------------------------------------------------------