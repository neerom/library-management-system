-- =====================================================================
-- 01_create_tables.sql
-- Library Management System - schema (PostgreSQL)
--
-- Tables:
--   authors       one row per author
--   books         one row per book title (with copy counts)
--   book_authors  junction table -> many-to-many between books and authors
--   members       library members
--   borrowings    one row each time a member borrows a book
--
-- Normalization (3NF):
--   * Every column holds a single value (no "author1, author2" lists).
--   * Authors live in their own table; the book <-> author link is the
--     junction table book_authors, so a book can have many authors and
--     an author can write many books.
--   * Non-key columns depend only on their table's primary key.
--
-- WARNING: re-running this file drops the tables and all their data.
-- =====================================================================

DROP TABLE IF EXISTS borrowings, book_authors, books, authors, members CASCADE;

CREATE TABLE authors (
    author_id  SERIAL       PRIMARY KEY,
    full_name  VARCHAR(100) NOT NULL,
    country    VARCHAR(60)
);

CREATE TABLE books (
    book_id          SERIAL       PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    isbn             CHAR(13)     NOT NULL UNIQUE,
    genre            VARCHAR(50)  NOT NULL,
    published_year   INT,
    total_copies     INT          NOT NULL DEFAULT 1,
    available_copies INT          NOT NULL DEFAULT 1,
    CONSTRAINT chk_isbn_digits      CHECK (isbn ~ '^[0-9]{13}$'),
    CONSTRAINT chk_published_year   CHECK (published_year BETWEEN 1450 AND 2100),
    CONSTRAINT chk_total_copies     CHECK (total_copies >= 0),
    -- available copies can never go below 0 or above the total
    CONSTRAINT chk_available_copies CHECK (available_copies BETWEEN 0 AND total_copies)
);

-- Many-to-many: one book can have many authors, one author many books
CREATE TABLE book_authors (
    book_id   INT NOT NULL REFERENCES books(book_id)     ON DELETE CASCADE,
    author_id INT NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

CREATE TABLE members (
    member_id  SERIAL       PRIMARY KEY,
    full_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    phone      VARCHAR(15),
    joined_on  DATE         NOT NULL DEFAULT CURRENT_DATE
);

-- Borrowing history. returned_on IS NULL means the book is still out.
-- Foreign keys have no ON DELETE CASCADE on purpose: you cannot delete
-- a book or member that still has borrowing history.
CREATE TABLE borrowings (
    borrowing_id SERIAL PRIMARY KEY,
    book_id      INT    NOT NULL REFERENCES books(book_id),
    member_id    INT    NOT NULL REFERENCES members(member_id),
    borrowed_on  DATE   NOT NULL DEFAULT CURRENT_DATE,
    due_on       DATE   NOT NULL,
    returned_on  DATE,
    CONSTRAINT chk_due_after_borrow    CHECK (due_on >= borrowed_on),
    CONSTRAINT chk_return_after_borrow CHECK (returned_on IS NULL OR returned_on >= borrowed_on)
);
