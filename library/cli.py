"""Text menu for running the reports."""

from dataclasses import astuple, fields
from typing import Any, Sequence

from library.storage import LibraryStorage

MENU = """
========= Library Management System =========
 1. Books by a given author
 2. Members with overdue books
 3. Top 3 most-borrowed books
 4. Members who have never borrowed
 5. Run all
 0. Exit
=============================================="""


def print_table(items: Sequence[Any]) -> None:
    """Print a list of dataclass objects as a simple text table."""
    if not items:
        print("No results found.")
        return
    headers = [f.name for f in fields(items[0])]
    rows = [[str(value) for value in astuple(item)] for item in items]
    widths = [max(len(h), *(len(row[i]) for row in rows)) for i, h in enumerate(headers)]
    print(" | ".join(h.ljust(w) for h, w in zip(headers, widths)))
    print("-+-".join("-" * w for w in widths))
    for row in rows:
        print(" | ".join(v.ljust(w) for v, w in zip(row, widths)))


def show_books_by_author(storage: LibraryStorage) -> None:
    name = input("Author name (e.g. Agatha Christie): ").strip()
    if not name:
        print("Please type an author name.")
        return
    print(f"\nBooks by '{name}':")
    print_table(storage.books_by_author(name))


def show_overdue(storage: LibraryStorage) -> None:
    print("\nMembers with overdue books:")
    print_table(storage.overdue_members())


def show_top_borrowed(storage: LibraryStorage) -> None:
    print("\nTop 3 most-borrowed books:")
    print_table(storage.top_borrowed_books(3))


def show_never_borrowed(storage: LibraryStorage) -> None:
    print("\nMembers who have never borrowed:")
    print_table(storage.members_never_borrowed())


def run_all(storage: LibraryStorage) -> None:
    show_books_by_author(storage)
    show_overdue(storage)
    show_top_borrowed(storage)
    show_never_borrowed(storage)


def run_menu(storage: LibraryStorage) -> None:
    """Show the menu until the user chooses 0."""
    actions = {
        "1": show_books_by_author,
        "2": show_overdue,
        "3": show_top_borrowed,
        "4": show_never_borrowed,
        "5": run_all,
    }
    while True:
        print(MENU)
        choice = input("Choose an option: ").strip()
        if choice == "0":
            print("Goodbye!")
            break
        action = actions.get(choice)
        if action is None:
            print("Invalid choice, please enter 0-5.")
        else:
            action(storage)
