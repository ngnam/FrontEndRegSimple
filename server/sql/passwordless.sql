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
