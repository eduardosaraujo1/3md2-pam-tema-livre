CREATE TABLE
    users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL
    );

CREATE TABLE
    destination_metadata (
        user_id INTEGER,
        destination_id INTEGER,
        observation TEXT,
        is_favorite BOOLEAN NOT NULL DEFAULT 0,
        PRIMARY KEY (user_id, destination_id),
        FOREIGN KEY (user_id) REFERENCES users (id)
    );

CREATE TABLE
    tokens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        token TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
    );