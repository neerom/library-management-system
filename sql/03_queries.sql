-- =====================================================================
-- 03_queries.sql
-- Report queries (joins + aggregates) and CRUD examples.
-- Run AFTER 01_create_tables.sql and 02_insert_data.sql.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q1. Books by a given author
--     Change 'Agatha Christie' to any author name.
-- ---------------------------------------------------------------------
SELECT b.book_id,
       b.title,
       b.genre,
       b.published_year,
       a.full_name AS author
FROM books b
JOIN book_authors ba ON ba.book_id  = b.book_id
JOIN authors a       ON a.author_id = ba.author_id
WHERE a.full_name = 'Agatha Christie'
ORDER BY b.published_year;

-- ---------------------------------------------------------------------
-- Q2. Members with overdue books
--     Overdue = not returned yet AND due date is in the past.
-- ---------------------------------------------------------------------
SELECT m.member_id,
       m.full_name,
       m.email,
       b.title                   AS book_title,
       br.due_on,
       CURRENT_DATE - br.due_on  AS days_overdue
FROM borrowings br
JOIN members m ON m.member_id = br.member_id
JOIN books b   ON b.book_id   = br.book_id
WHERE br.returned_on IS NULL
  AND br.due_on < CURRENT_DATE
ORDER BY days_overdue DESC;

-- ---------------------------------------------------------------------
-- Q3. Top 3 most-borrowed books (aggregate: COUNT + GROUP BY)
-- ---------------------------------------------------------------------
SELECT b.book_id,
       b.title,
       COUNT(br.borrowing_id) AS times_borrowed
FROM books b
JOIN borrowings br ON br.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC, b.title
LIMIT 3;

-- ---------------------------------------------------------------------
-- Q4. Members who have never borrowed anything
--     LEFT JOIN keeps every member; members with no borrowing get NULLs.
-- ---------------------------------------------------------------------
SELECT m.member_id,
       m.full_name,
       m.email,
       m.joined_on
FROM members m
LEFT JOIN borrowings br ON br.member_id = m.member_id
WHERE br.borrowing_id IS NULL
ORDER BY m.full_name;

-- ---------------------------------------------------------------------
-- CRUD examples (Create, Read, Update, Delete) on the members table.
-- Wrapped in BEGIN ... ROLLBACK so your sample data is not changed.
-- ---------------------------------------------------------------------
BEGIN;

-- Create
INSERT INTO members (full_name, email, phone)
VALUES ('Test User', 'test.user@example.com', '9000000000');

-- Read
SELECT member_id, full_name, email, phone
FROM members
WHERE email = 'test.user@example.com';

-- Update
UPDATE members
SET phone = '9111111111'
WHERE email = 'test.user@example.com';

-- Delete
DELETE FROM members
WHERE email = 'test.user@example.com';

ROLLBACK;
