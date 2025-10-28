CREATE TABLE
    users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password_hash TEXT
    );

CREATE TABLE
    destinations (
        id INTEGER PRIMARY KEY,
        observation TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
    );

CREATE TABLE
    tokens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        token TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
    );