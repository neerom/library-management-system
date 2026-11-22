-- =====================================================================
-- 04_borrow_transaction.sql
-- "Borrow a book" as one transaction.
--
-- Two things must happen together, or not at all:
--   1. books.available_copies goes down by 1
--   2. a new row is added to borrowings
-- BEGIN ... COMMIT makes them one unit. If any step fails, nothing is
-- saved (ROLLBACK).
--
-- Run with psql:  psql -U postgres -d library_db -f sql/04_borrow_transaction.sql
-- =====================================================================

-- =====================================================================
-- Part A: SUCCESS - member 3 (Rohan Mehta) borrows book 12 (Foundation)
-- =====================================================================

-- Before
SELECT book_id, title, available_copies FROM books WHERE book_id = 12;

BEGIN;

-- Step 1: lock the book row. Anyone else trying to borrow the same
-- book now waits until we COMMIT, so two people can't take the last copy.
SELECT book_id, title, available_copies
FROM books
WHERE book_id = 12
FOR UPDATE;

-- Step 2: reduce available copies by 1.
-- If it is already 0, the CHECK constraint chk_available_copies raises
-- an error and the whole transaction is cancelled.
UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 12;

-- Step 3: record the borrowing (due in 14 days)
INSERT INTO borrowings (book_id, member_id, borrowed_on, due_on)
VALUES (12, 3, CURRENT_DATE, CURRENT_DATE + 14);

COMMIT;

-- After: available_copies is 1 lower and the new borrowing exists
SELECT book_id, title, available_copies FROM books WHERE book_id = 12;

SELECT borrowing_id, book_id, member_id, borrowed_on, due_on
FROM borrowings
WHERE book_id = 12 AND member_id = 3
ORDER BY borrowing_id DESC
LIMIT 1;


-- =====================================================================
-- Part B: FAILURE - member 2 tries to borrow book 47 (Clean Code),
-- which has 0 copies available. Expect an ERROR on the UPDATE.
-- =====================================================================

-- Before (available_copies = 0)
SELECT book_id, title, available_copies FROM books WHERE book_id = 47;

BEGIN;

SELECT book_id, title, available_copies
FROM books
WHERE book_id = 47
FOR UPDATE;

-- ERROR: violates check constraint "chk_available_copies"
UPDATE books
SET available_copies = available_copies - 1
WHERE book_id = 47;

-- ERROR: current transaction is aborted (this insert never runs)
INSERT INTO borrowings (book_id, member_id, borrowed_on, due_on)
VALUES (47, 2, CURRENT_DATE, CURRENT_DATE + 14);

-- Undo everything in this transaction
ROLLBACK;

-- After: nothing changed - still 0 copies and no borrowing for member 2
SELECT book_id, title, available_copies FROM books WHERE book_id = 47;

SELECT COUNT(*) AS member_2_clean_code_borrowings
FROM borrowings
WHERE book_id = 47 AND member_id = 2;
