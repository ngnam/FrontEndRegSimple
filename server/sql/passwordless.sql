CREATE TABLE users (
  id character(36) PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  created_at timestamp not null default now()
);

CREATE TABLE passwordless
(
  user_id character(36) PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  code character (4) NOT NULL,
  created_at timestamp not null default now()
);

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.created_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON passwordless
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
