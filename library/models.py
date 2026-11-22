"""Data classes: one class per kind of result row the app shows."""

from dataclasses import dataclass
from datetime import date


@dataclass(frozen=True)
class Book:
    book_id: int
    title: str
    genre: str
    published_year: int | None
    author: str


@dataclass(frozen=True)
class OverdueLoan:
    member_id: int
    member_name: str
    email: str
    book_title: str
    due_on: date
    days_overdue: int


@dataclass(frozen=True)
class PopularBook:
    book_id: int
    title: str
    times_borrowed: int


@dataclass(frozen=True)
class Member:
    member_id: int
    full_name: str
    email: str
    joined_on: date
