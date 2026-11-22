"""Entry point. Run with:  python main.py"""

import sys

import psycopg2

from library.cli import run_menu
from library.storage import LibraryStorage, load_db_config


def main() -> int:
    try:
        storage = LibraryStorage(load_db_config())
    except psycopg2.OperationalError as error:
        print("Could not connect to the database. Check the values in your .env file.")
        print(f"Details: {error}")
        return 1

    with storage:
        run_menu(storage)
    return 0


if __name__ == "__main__":
    sys.exit(main())
