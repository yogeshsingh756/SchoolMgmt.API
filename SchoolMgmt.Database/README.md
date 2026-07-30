# SchoolMgmt.Database

Scripts-only project for MySQL schema and stored procedures. The API continues to use Dapper at runtime; this project exists so DB changes are tracked in source control and reviewed with related C# changes.

This project is **not built** when you run the API (solution build skips it). Apply scripts manually in MySQL Workbench / CLI.

## Layout

| Folder | Purpose |
|--------|---------|
| `Tables/` | One file per table (`CREATE` + indexes / `AUTO_INCREMENT` / FKs), plus `_00_CreateDatabase.sql` |
| `StoredProcedures/` | One file per SP (`DROP` + `CREATE`), grouped under `Auth/`, `Admin/`, `SuperAdmin/`, `Org/`, `User/`, `Permissions/`, `Common/` |

## Conventions

- **One object per file**, named after the object (e.g. `sp_Auth_GetUserByUsername.sql`, `Users.sql`).
- Stored procedures use `DROP PROCEDURE IF EXISTS` then `CREATE PROCEDURE` so they can be redeployed safely.
- Do **not** store connection strings or credentials here.

## SQL80001 / Error List noise

These scripts are **MySQL** (backticks, `DELIMITER`, `ENGINE=InnoDB`, etc.). Visual Studio’s SQL language service validates them as **T-SQL**, which produces false `SQL80001` errors.

They are not real build failures (`dotnet build` on the API succeeds). To clear the Error List:

1. Set the Error List filter to **Build Only** (not Build + IntelliSense), or
2. Visual Studio: **Tools → Options → Text Editor → SQL Server → IntelliSense** → turn off **Enable IntelliSense**.

## Workflow

1. Keep `Tables/` and `StoredProcedures/` in sync when the live MySQL schema or SPs change.
2. For every future DB change: edit/add the `.sql` file here, then apply it to the database.
3. Commit the script with the related C# change so PRs review API + DB together.
