--
-- This script is meant to be run on the production database.
--
-- Borrowed from: https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/
--

\echo
\echo

--
-- verify paramters and set defaults
-- if they're unspecified
--
\if :{?owner_name}
\else
  \set owner_name owner
\endif
\echo owner_name set to :owner_name

\if :{?owner_password}
\else
  \set owner_password changem3
\endif
\echo owner_password set to :owner_password

\if :{?db_name}
\else
  \set db_name registry
\endif
\echo db_name set to :db_name

\if :{?schema_name}
\else
  \set schema_name :db_name
\endif
\echo schema_name set to :schema_name

\if :{?user_name}
\else
  \set user_name app
\endif
\echo user_name set to :user_name

\if :{?user_password}
\else
  \set user_password changem3
\endif
\echo user_password set to :user_password


\echo
\echo

-- echo all commands
\set ECHO all

CREATE ROLE :owner_name 
  LOGIN 
  ENCRYPTED PASSWORD :'owner_password'
  CONNECTION LIMIT 3;

ALTER ROLE :owner_name SET statement_timeout = '20s';
ALTER ROLE :owner_name SET lock_timeout = '3s';
ALTER ROLE :owner_name SET idle_in_transaction_session_timeout = '3s'; 

CREATE ROLE rw_users NOLOGIN;
CREATE ROLE ro_users NOLOGIN;

CREATE DATABASE :db_name
  WITH OWNER :owner_name
  ENCODING UTF8
  LC_COLLATE 'en_US.utf8' 
  LC_CTYPE 'en_US.utf8';

\c :db_name

REVOKE ALL ON DATABASE :db_name FROM PUBLIC;
DROP SCHEMA public;

SET ROLE :owner_name;
CREATE SCHEMA :schema_name;
RESET ROLE;

ALTER ROLE :owner_name SET search_path TO :schema_name;
SET search_path TO :schema_name;

GRANT CONNECT   ON DATABASE :db_name TO rw_users;
GRANT TEMPORARY ON DATABASE :db_name TO rw_users;

GRANT CONNECT   ON DATABASE :db_name TO ro_users;
GRANT TEMPORARY ON DATABASE :db_name TO ro_users;

GRANT USAGE ON SCHEMA :schema_name TO rw_users;
GRANT USAGE ON SCHEMA :schema_name TO ro_users;

GRANT CREATE, USAGE ON SCHEMA :schema_name TO :owner_name;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT SELECT, INSERT, UPDATE, DELETE
  ON TABLES
  TO rw_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT USAGE, SELECT, UPDATE
  ON SEQUENCES
  TO rw_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT EXECUTE
  ON FUNCTIONS
  TO rw_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT USAGE
  ON TYPES
  TO rw_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT SELECT
  ON TABLES
  TO ro_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT USAGE, SELECT
  ON SEQUENCES
  TO ro_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT EXECUTE
  ON FUNCTIONS
  TO ro_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  IN SCHEMA :schema_name
  GRANT USAGE
  ON TYPES
  TO ro_users;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  REVOKE ALL PRIVILEGES
  ON TABLES
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  REVOKE ALL PRIVILEGES
  ON SEQUENCES
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  REVOKE ALL PRIVILEGES
  ON FUNCTIONS
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  REVOKE ALL PRIVILEGES
  ON TYPES
  FROM PUBLIC;

ALTER DEFAULT PRIVILEGES
  FOR ROLE :owner_name
  REVOKE ALL PRIVILEGES
  ON SCHEMAS
  FROM PUBLIC;

CREATE ROLE :user_name WITH
  LOGIN 
  ENCRYPTED PASSWORD :'user_password'
  CONNECTION LIMIT 90 
  IN ROLE rw_users;
ALTER ROLE :user_name SET statement_timeout = '1s';
ALTER ROLE :user_name SET lock_timeout = '750ms';
ALTER ROLE :user_name SET idle_in_transaction_session_timeout = '1s'; 
ALTER ROLE :user_name SET search_path = :schema_name;

--
-- Show results so we can visually inspect them
--
\l
\dn+
SELECT *
  FROM pg_roles
 WHERE rolname in (:'owner_name', 'rw_users', 'ro_users', :'user_name')
ORDER BY oid;
