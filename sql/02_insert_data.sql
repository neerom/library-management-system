-- =====================================================================
-- 02_insert_data.sql
-- Sample data: 47 authors, 50 books (10 genres x 5), 10 members,
-- 25 borrowings. Run AFTER 01_create_tables.sql.
--
-- Borrowing dates are relative to CURRENT_DATE so "overdue" results
-- work no matter which day you run this.
-- ISBNs are sample values, not real ones.
-- =====================================================================

-- Empty all tables and reset the id counters so ids start at 1 again
TRUNCATE borrowings, book_authors, books, authors, members RESTART IDENTITY CASCADE;

-- ---------------------------------------------------------------------
-- AUTHORS (ids 1-47)
-- ---------------------------------------------------------------------
INSERT INTO authors (full_name, country) VALUES
('Harper Lee', 'USA'),                 -- 1
('F. Scott Fitzgerald', 'USA'),        -- 2
('J.D. Salinger', 'USA'),              -- 3
('Arundhati Roy', 'India'),            -- 4
('George Orwell', 'UK'),               -- 5
('Agatha Christie', 'UK'),             -- 6
('Arthur Conan Doyle', 'UK'),          -- 7
('Frank Herbert', 'USA'),              -- 8
('Isaac Asimov', 'USA'),               -- 9
('Andy Weir', 'USA'),                  -- 10
('J.R.R. Tolkien', 'UK'),              -- 11
('J.K. Rowling', 'UK'),                -- 12
('Terry Pratchett', 'UK'),             -- 13
('Neil Gaiman', 'UK'),                 -- 14
('Jane Austen', 'UK'),                 -- 15
('Charlotte Bronte', 'UK'),            -- 16
('Emily Bronte', 'UK'),                -- 17
('Bram Stoker', 'Ireland'),            -- 18
('Mary Shelley', 'UK'),                -- 19
('Stephen King', 'USA'),               -- 20
('Shirley Jackson', 'USA'),            -- 21
('Yuval Noah Harari', 'Israel'),       -- 22
('Jared Diamond', 'USA'),              -- 23
('Jawaharlal Nehru', 'India'),         -- 24
('Ramachandra Guha', 'India'),         -- 25
('Stephen Hawking', 'UK'),             -- 26
('Richard Dawkins', 'UK'),             -- 27
('Carl Sagan', 'USA'),                 -- 28
('Charles Darwin', 'UK'),              -- 29
('Siddhartha Mukherjee', 'India'),     -- 30
('A.P.J. Abdul Kalam', 'India'),       -- 31
('Arun Tiwari', 'India'),              -- 32
('Walter Isaacson', 'USA'),            -- 33
('Nelson Mandela', 'South Africa'),    -- 34
('Mahatma Gandhi', 'India'),           -- 35
('Anne Frank', 'Germany'),             -- 36
('Andrew Hunt', 'USA'),                -- 37
('David Thomas', 'UK'),                -- 38
('Robert C. Martin', 'USA'),           -- 39
('Brian W. Kernighan', 'Canada'),      -- 40
('Dennis M. Ritchie', 'USA'),          -- 41
('Erich Gamma', 'Switzerland'),        -- 42
('Richard Helm', 'Australia'),         -- 43
('Ralph Johnson', 'USA'),              -- 44
('John Vlissides', 'USA'),             -- 45
('Harold Abelson', 'USA'),             -- 46
('Gerald Jay Sussman', 'USA');         -- 47

-- ---------------------------------------------------------------------
-- BOOKS (ids 1-50): 10 genres x 5 books
-- available_copies is recalculated at the end of this file
-- ---------------------------------------------------------------------
INSERT INTO books (title, isbn, genre, published_year, total_copies, available_copies) VALUES
-- Fiction
('To Kill a Mockingbird',                       '9781000000001', 'Fiction',         1960, 4, 4),  -- 1
('The Great Gatsby',                            '9781000000002', 'Fiction',         1925, 3, 3),  -- 2
('The Catcher in the Rye',                      '9781000000003', 'Fiction',         1951, 2, 2),  -- 3
('The God of Small Things',                     '9781000000004', 'Fiction',         1997, 3, 3),  -- 4
('Animal Farm',                                 '9781000000005', 'Fiction',         1945, 5, 5),  -- 5
-- Mystery
('Murder on the Orient Express',                '9781000000006', 'Mystery',         1934, 4, 4),  -- 6
('And Then There Were None',                    '9781000000007', 'Mystery',         1939, 3, 3),  -- 7
('The Murder of Roger Ackroyd',                 '9781000000008', 'Mystery',         1926, 2, 2),  -- 8
('The Hound of the Baskervilles',               '9781000000009', 'Mystery',         1902, 3, 3),  -- 9
('A Study in Scarlet',                          '9781000000010', 'Mystery',         1887, 2, 2),  -- 10
-- Science Fiction
('Dune',                                        '9781000000011', 'Science Fiction', 1965, 3, 3),  -- 11
('Foundation',                                  '9781000000012', 'Science Fiction', 1951, 3, 3),  -- 12
('I, Robot',                                    '9781000000013', 'Science Fiction', 1950, 2, 2),  -- 13
('Nineteen Eighty-Four',                        '9781000000014', 'Science Fiction', 1949, 4, 4),  -- 14
('The Martian',                                 '9781000000015', 'Science Fiction', 2011, 2, 2),  -- 15
-- Fantasy
('The Hobbit',                                  '9781000000016', 'Fantasy',         1937, 4, 4),  -- 16
('The Fellowship of the Ring',                  '9781000000017', 'Fantasy',         1954, 3, 3),  -- 17
('Harry Potter and the Philosopher''s Stone',   '9781000000018', 'Fantasy',         1997, 6, 6),  -- 18
('Harry Potter and the Chamber of Secrets',     '9781000000019', 'Fantasy',         1998, 4, 4),  -- 19
('Good Omens',                                  '9781000000020', 'Fantasy',         1990, 2, 2),  -- 20
-- Romance
('Pride and Prejudice',                         '9781000000021', 'Romance',         1813, 3, 3),  -- 21
('Emma',                                        '9781000000022', 'Romance',         1815, 2, 2),  -- 22
('Sense and Sensibility',                       '9781000000023', 'Romance',         1811, 2, 2),  -- 23
('Jane Eyre',                                   '9781000000024', 'Romance',         1847, 3, 3),  -- 24
('Wuthering Heights',                           '9781000000025', 'Romance',         1847, 2, 2),  -- 25
-- Horror
('Dracula',                                     '9781000000026', 'Horror',          1897, 3, 3),  -- 26
('Frankenstein',                                '9781000000027', 'Horror',          1818, 3, 3),  -- 27
('The Shining',                                 '9781000000028', 'Horror',          1977, 2, 2),  -- 28
('It',                                          '9781000000029', 'Horror',          1986, 2, 2),  -- 29
('The Haunting of Hill House',                  '9781000000030', 'Horror',          1959, 1, 1),  -- 30
-- History
('Sapiens: A Brief History of Humankind',       '9781000000031', 'History',         2011, 5, 5),  -- 31
('Homo Deus',                                   '9781000000032', 'History',         2015, 3, 3),  -- 32
('Guns, Germs, and Steel',                      '9781000000033', 'History',         1997, 2, 2),  -- 33
('The Discovery of India',                      '9781000000034', 'History',         1946, 3, 3),  -- 34
('India After Gandhi',                          '9781000000035', 'History',         2007, 2, 2),  -- 35
-- Science
('A Brief History of Time',                     '9781000000036', 'Science',         1988, 4, 4),  -- 36
('The Selfish Gene',                            '9781000000037', 'Science',         1976, 2, 2),  -- 37
('Cosmos',                                      '9781000000038', 'Science',         1980, 3, 3),  -- 38
('On the Origin of Species',                    '9781000000039', 'Science',         1859, 2, 2),  -- 39
('The Gene: An Intimate History',               '9781000000040', 'Science',         2016, 2, 2),  -- 40
-- Biography
('Wings of Fire',                               '9781000000041', 'Biography',       1999, 5, 5),  -- 41
('Steve Jobs',                                  '9781000000042', 'Biography',       2011, 3, 3),  -- 42
('Long Walk to Freedom',                        '9781000000043', 'Biography',       1994, 2, 2),  -- 43
('The Story of My Experiments with Truth',      '9781000000044', 'Biography',       1927, 3, 3),  -- 44
('The Diary of a Young Girl',                   '9781000000045', 'Biography',       1947, 3, 3),  -- 45
-- Technology
('The Pragmatic Programmer',                    '9781000000046', 'Technology',      1999, 3, 3),  -- 46
('Clean Code',                                  '9781000000047', 'Technology',      2008, 1, 1),  -- 47
('The C Programming Language',                  '9781000000048', 'Technology',      1978, 2, 2),  -- 48
('Design Patterns',                             '9781000000049', 'Technology',      1994, 2, 2),  -- 49
('Structure and Interpretation of Computer Programs', '9781000000050', 'Technology', 1985, 2, 2); -- 50

-- ---------------------------------------------------------------------
-- BOOK_AUTHORS (many-to-many). Some books have several authors,
-- some authors have several books.
-- ---------------------------------------------------------------------
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 6), (8, 6), (9, 7), (10, 7),
(11, 8), (12, 9), (13, 9), (14, 5), (15, 10),
(16, 11), (17, 11), (18, 12), (19, 12),
(20, 13), (20, 14),                          -- Good Omens: 2 authors
(21, 15), (22, 15), (23, 15), (24, 16), (25, 17),
(26, 18), (27, 19), (28, 20), (29, 20), (30, 21),
(31, 22), (32, 22), (33, 23), (34, 24), (35, 25),
(36, 26), (37, 27), (38, 28), (39, 29), (40, 30),
(41, 31), (41, 32),                          -- Wings of Fire: 2 authors
(42, 33), (43, 34), (44, 35), (45, 36),
(46, 37), (46, 38),                          -- Pragmatic Programmer: 2 authors
(47, 39),
(48, 40), (48, 41),                          -- K&R: 2 authors
(49, 42), (49, 43), (49, 44), (49, 45),      -- Design Patterns: 4 authors
(50, 46), (50, 47);                          -- SICP: 2 authors

-- ---------------------------------------------------------------------
-- MEMBERS (ids 1-10). Members 9 and 10 never borrow anything.
-- ---------------------------------------------------------------------
INSERT INTO members (full_name, email, phone, joined_on) VALUES
('Aarav Sharma', 'aarav.sharma@example.com', '9876500001', '2024-01-15'),  -- 1
('Priya Nair',   'priya.nair@example.com',   '9876500002', '2024-02-20'),  -- 2
('Rohan Mehta',  'rohan.mehta@example.com',  '9876500003', '2024-03-05'),  -- 3
('Ananya Iyer',  'ananya.iyer@example.com',  '9876500004', '2024-04-11'),  -- 4
('Vikram Singh', 'vikram.singh@example.com', '9876500005', '2024-05-23'),  -- 5
('Sneha Reddy',  'sneha.reddy@example.com',  '9876500006', '2024-06-30'),  -- 6
('Karan Patel',  'karan.patel@example.com',  '9876500007', '2024-08-14'),  -- 7
('Meera Joshi',  'meera.joshi@example.com',  '9876500008', '2024-09-09'),  -- 8
('Arjun Das',    'arjun.das@example.com',    '9876500009', '2025-01-02'),  -- 9
('Fatima Khan',  'fatima.khan@example.com',  '9876500010', '2025-03-18');  -- 10

-- ---------------------------------------------------------------------
-- BORROWINGS. returned_on NULL = still borrowed.
-- Loan period is 14 days. Most-borrowed: book 18 (5x), 6 (4x), 31 (3x).
-- ---------------------------------------------------------------------
INSERT INTO borrowings (book_id, member_id, borrowed_on, due_on, returned_on) VALUES
-- Harry Potter and the Philosopher's Stone - 5 times
(18, 1, CURRENT_DATE - 120, CURRENT_DATE - 106, CURRENT_DATE - 110),
(18, 2, CURRENT_DATE - 90,  CURRENT_DATE - 76,  CURRENT_DATE - 80),
(18, 3, CURRENT_DATE - 60,  CURRENT_DATE - 46,  CURRENT_DATE - 50),
(18, 4, CURRENT_DATE - 40,  CURRENT_DATE - 26,  CURRENT_DATE - 30),
(18, 5, CURRENT_DATE - 10,  CURRENT_DATE + 4,   NULL),               -- out, not yet due
-- Murder on the Orient Express - 4 times
(6, 2,  CURRENT_DATE - 100, CURRENT_DATE - 86,  CURRENT_DATE - 90),
(6, 6,  CURRENT_DATE - 70,  CURRENT_DATE - 56,  CURRENT_DATE - 60),
(6, 7,  CURRENT_DATE - 45,  CURRENT_DATE - 31,  CURRENT_DATE - 35),
(6, 1,  CURRENT_DATE - 25,  CURRENT_DATE - 11,  NULL),               -- OVERDUE
-- Sapiens - 3 times
(31, 3, CURRENT_DATE - 80,  CURRENT_DATE - 66,  CURRENT_DATE - 70),
(31, 8, CURRENT_DATE - 50,  CURRENT_DATE - 36,  CURRENT_DATE - 40),
(31, 4, CURRENT_DATE - 20,  CURRENT_DATE - 6,   NULL),               -- OVERDUE
-- Other books
(47, 5, CURRENT_DATE - 30,  CURRENT_DATE - 16,  NULL),               -- OVERDUE (Clean Code: only copy)
(11, 6, CURRENT_DATE - 15,  CURRENT_DATE - 1,   NULL),               -- OVERDUE
(11, 1, CURRENT_DATE - 150, CURRENT_DATE - 136, CURRENT_DATE - 140),
(16, 7, CURRENT_DATE - 5,   CURRENT_DATE + 9,   NULL),               -- out, not yet due
(36, 8, CURRENT_DATE - 12,  CURRENT_DATE + 2,   NULL),               -- out, not yet due
(41, 2, CURRENT_DATE - 35,  CURRENT_DATE - 21,  CURRENT_DATE - 25),
(41, 3, CURRENT_DATE - 8,   CURRENT_DATE + 6,   NULL),               -- out, not yet due
(28, 6, CURRENT_DATE - 55,  CURRENT_DATE - 41,  CURRENT_DATE - 45),
(21, 7, CURRENT_DATE - 33,  CURRENT_DATE - 19,  NULL),               -- OVERDUE
(46, 8, CURRENT_DATE - 3,   CURRENT_DATE + 11,  NULL),               -- out, not yet due
(4, 1,  CURRENT_DATE - 65,  CURRENT_DATE - 51,  CURRENT_DATE - 52),
(14, 4, CURRENT_DATE - 18,  CURRENT_DATE - 4,   CURRENT_DATE - 2),   -- returned late
(26, 5, CURRENT_DATE - 75,  CURRENT_DATE - 61,  CURRENT_DATE - 62);

-- ---------------------------------------------------------------------
-- Make available_copies match the books that are currently out
-- ---------------------------------------------------------------------
UPDATE books b
SET available_copies = b.total_copies - (
    SELECT COUNT(*)
    FROM borrowings br
    WHERE br.book_id = b.book_id
      AND br.returned_on IS NULL
);

-- Quick check: row counts per table
SELECT 'authors' AS table_name, COUNT(*) AS row_count FROM authors
UNION ALL SELECT 'books',        COUNT(*) FROM books
UNION ALL SELECT 'book_authors', COUNT(*) FROM book_authors
UNION ALL SELECT 'members',      COUNT(*) FROM members
UNION ALL SELECT 'borrowings',   COUNT(*) FROM borrowings;
