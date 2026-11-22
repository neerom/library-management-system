"""Database layer: reads settings from .env, connects, runs the queries.

Every query uses placeholders (%s) and passes values separately, so user
input is never pasted into the SQL text. This prevents SQL injection.
"""

import os
from types import TracebackType
from typing import Any

import psycopg2
from dotenv import load_dotenv

from library.models import Book, Member, OverdueLoan, PopularBook

BOOKS_BY_AUTHOR_SQL = """
    SELECT b.book_id, b.title, b.genre, b.published_year, a.full_name
    FROM books b
    JOIN book_authors ba ON ba.book_id  = b.book_id
    JOIN authors a       ON a.author_id = ba.author_id
    WHERE a.full_name ILIKE %s
    ORDER BY a.full_name, b.published_year
"""

OVERDUE_MEMBERS_SQL = """
    SELECT m.member_id, m.full_name, m.email, b.title, br.due_on,
           CURRENT_DATE - br.due_on AS days_overdue
    FROM borrowings br
    JOIN members m ON m.member_id = br.member_id
    JOIN books b   ON b.book_id   = br.book_id
    WHERE br.returned_on IS NULL
      AND br.due_on < CURRENT_DATE
    ORDER BY days_overdue DESC
"""

TOP_BORROWED_SQL = """
    SELECT b.book_id, b.title, COUNT(br.borrowing_id) AS times_borrowed
    FROM books b
    JOIN borrowings br ON br.book_id = b.book_id
    GROUP BY b.book_id, b.title
    ORDER BY times_borrowed DESC, b.title
    LIMIT %s
"""

NEVER_BORROWED_SQL = """
    SELECT m.member_id, m.full_name, m.email, m.joined_on
    FROM members m
    LEFT JOIN borrowings br ON br.member_id = m.member_id
    WHERE br.borrowing_id IS NULL
    ORDER BY m.full_name
"""


def load_db_config() -> dict[str, str]:
    """Read the database settings from the .env file."""
    load_dotenv()
    return {
        "host": os.getenv("DB_HOST", "localhost"),
        "port": os.getenv("DB_PORT", "5432"),
        "dbname": os.getenv("DB_NAME", "library_db"),
        "user": os.getenv("DB_USER", "postgres"),
        "password": os.getenv("DB_PASSWORD", ""),
    }


class LibraryStorage:
    """Holds one database connection and runs the report queries."""

    def __init__(self, config: dict[str, str]) -> None:
        self.conn = psycopg2.connect(
            host=config["host"],
            port=config["port"],
            dbname=config["dbname"],
            user=config["user"],
            password=config["password"],
        )
        # This app only reads data, so make the session read-only.
        self.conn.set_session(readonly=True, autocommit=True)

    def __enter__(self) -> "LibraryStorage":
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        self.close()

    def close(self) -> None:
        self.conn.close()

    def _fetch_all(self, sql: str, params: tuple[Any, ...] = ()) -> list[tuple[Any, ...]]:
        with self.conn.cursor() as cur:
            cur.execute(sql, params)  # values are sent separately -> safe
            rows: list[tuple[Any, ...]] = cur.fetchall()
            return rows

    def books_by_author(self, author_name: str) -> list[Book]:
        """Books whose author name contains the given text (case-insensitive)."""
        rows = self._fetch_all(BOOKS_BY_AUTHOR_SQL, (f"%{author_name}%",))
        return [Book(*row) for row in rows]

    def overdue_members(self) -> list[OverdueLoan]:
        rows = self._fetch_all(OVERDUE_MEMBERS_SQL)
        return [OverdueLoan(*row) for row in rows]

    def top_borrowed_books(self, limit: int = 3) -> list[PopularBook]:
        rows = self._fetch_all(TOP_BORROWED_SQL, (limit,))
        return [PopularBook(*row) for row in rows]

    def members_never_borrowed(self) -> list[Member]:
        rows = self._fetch_all(NEVER_BORROWED_SQL)
        return [Member(*row) for row in rows]
