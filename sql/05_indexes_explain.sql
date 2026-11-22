-- =====================================================================
-- 05_indexes_explain.sql
-- Add indexes and prove the improvement with EXPLAIN ANALYZE.
--
-- Query being optimized: "which loans are overdue?" (used by Q2)
--     WHERE returned_on IS NULL AND due_on < CURRENT_DATE
--
-- Problem: our sample data has only ~25 borrowings, and on a table that
-- small PostgreSQL reads the whole table anyway, index or not. So we
-- TEMPORARILY add 200,000 old (already returned) borrowings inside a
-- transaction, measure, and ROLLBACK at the end. Your sample data is
-- not changed.
--
-- Run with psql:  psql -U postgres -d library_db -f sql/05_indexes_explain.sql
-- =====================================================================

BEGIN;

-- 1. Add 200,000 returned borrowings (temporary test data)
INSERT INTO borrowings (book_id, member_id, borrowed_on, due_on, returned_on)
SELECT (g % 50) + 1,                          -- book 1..50
       (g % 8) + 1,                           -- member 1..8
       DATE '2015-01-01' + (g % 3000),        -- borrowed_on
       DATE '2015-01-01' + (g % 3000) + 14,   -- due_on
       DATE '2015-01-01' + (g % 3000) + 10    -- returned_on
FROM generate_series(1, 200000) AS g;

ANALYZE borrowings;   -- refresh table statistics for the planner

-- 2. BEFORE: no index -> "Seq Scan" reads all ~200,000 rows
--    Sample result (PostgreSQL 16; your times will differ):
--      Parallel Seq Scan on borrowings
--        Filter: ((returned_on IS NULL) AND (due_on < CURRENT_DATE))
--        Rows Removed by Filter: 100010   (per worker, x2 workers)
--      Execution Time: 9.000 ms
EXPLAIN ANALYZE
SELECT borrowing_id, member_id, book_id, due_on
FROM borrowings
WHERE returned_on IS NULL
  AND due_on < CURRENT_DATE;

-- 3. Add a PARTIAL index: it only holds rows still out
--    (returned_on IS NULL), so it stays tiny even with millions of rows.
CREATE INDEX idx_borrowings_overdue
    ON borrowings (due_on)
    WHERE returned_on IS NULL;

ANALYZE borrowings;

-- 4. AFTER: the planner now uses idx_borrowings_overdue and reads only
--    the few open loans. Compare "Execution Time" with step 2.
--    Sample result (PostgreSQL 16; your times will differ):
--      Bitmap Heap Scan on borrowings
--        ->  Bitmap Index Scan on idx_borrowings_overdue
--              Index Cond: (due_on < CURRENT_DATE)
--      Execution Time: 0.042 ms      (about 200x faster than 9.000 ms)
EXPLAIN ANALYZE
SELECT borrowing_id, member_id, book_id, due_on
FROM borrowings
WHERE returned_on IS NULL
  AND due_on < CURRENT_DATE;

-- 5. Remove the 200,000 test rows (and the test index)
ROLLBACK;


-- =====================================================================
-- Permanent indexes
-- =====================================================================

-- Overdue lookups (Q2)
CREATE INDEX IF NOT EXISTS idx_borrowings_overdue
    ON borrowings (due_on)
    WHERE returned_on IS NULL;

-- PostgreSQL does NOT index foreign keys automatically.
-- These speed up the joins in Q3 (book_id), Q4 (member_id), Q1 (author_id).
CREATE INDEX IF NOT EXISTS idx_borrowings_book_id     ON borrowings (book_id);
CREATE INDEX IF NOT EXISTS idx_borrowings_member_id   ON borrowings (member_id);
CREATE INDEX IF NOT EXISTS idx_book_authors_author_id ON book_authors (author_id);

-- List the indexes now on our tables
SELECT tablename, indexname
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
