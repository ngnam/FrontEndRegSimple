CREATE TABLE users (
  id character(36) PRIMARY KEY,
  email TEXT UNIQUE,
  role varchar(50) not null,
  created_at timestamp not null default now()
);

CREATE TABLE user_types (
  user_id character(36) PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  user_type varchar(50) not null
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

CREATE TABLE analytics
(
  event_name varchar(50) not null,
  params text not null,
  created_at timestamp not null default now()
);

CREATE TABLE bookmarks
(
  user_id character(36) REFERENCES users(id) ON DELETE CASCADE,
  snippet_id text not null,
  category_id text not null,
  created_at timestamp not null default now(),
  PRIMARY KEY (user_id, snippet_id)
);
