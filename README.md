# dbt Databricks Practice

This repository is a hands-on dbt practice project for Databricks. It uses a small medallion-style layout, starts from raw source tables in Databricks, adds a local seed for quick experimentation, and includes both generic and singular tests so you can practice the full dbt workflow.

## What this practice covers

- Connecting dbt to a Databricks SQL warehouse
- Declaring raw tables as dbt `sources`
- Building a `bronze` layer from source tables
- Loading a small seed file with `dbt seed`
- Writing generic and singular data tests
- Exploring data with an analysis query
- Customizing schema naming with a macro

## Current project contents

- `models/source/sources.yml`: source definitions for the raw sales tables in Databricks
- `models/bronze/`: bronze models for sales, returns, date, product, customer, and store
- `seeds/lookup.csv`: a small lookup seed for practice
- `tests/generic/generic_non_negative.sql`: reusable generic test for numeric columns
- `tests/non_negative_test.sql`: singular test against `bronze_sales`
- `analyses/1_explore.sql`: simple exploration query using `ref('lookup')`
- `macros/generate_shema.sql`: custom schema naming macro

## Project structure

```text
dbt-databricks-practice/
|-- dbt_databricks_sales/
|   |-- analyses/
|   |-- macros/
|   |-- models/
|   |   |-- bronze/
|   |   |-- example/
|   |   `-- source/
|   |-- seeds/
|   `-- tests/
|-- pyproject.toml
|-- requirements.txt
`-- uv.lock
```

## Prerequisites

- Python 3.11+
- A Databricks workspace and SQL warehouse
- A Databricks personal access token with SQL access
- `uv` installed, or the ability to install packages from `requirements.txt`

## Environment setup

### 1. Install dependencies

Using `uv`:

```powershell
uv sync
```

Using `pip`:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 2. Configure your dbt profile

Create or update `C:\Users\Admin\.dbt\profiles.yml` with your Databricks connection details. Use an environment variable for the token instead of hardcoding it.

```yaml
dbt_databricks_sales:
  outputs:
    dev:
      type: databricks
      host: <your-databricks-host>
      http_path: <your-sql-warehouse-http-path>
      catalog: <your-catalog>
      schema: default
      threads: 1
      token: "{{ env_var('DBT_DATABRICKS_TOKEN') }}"
  target: dev
```

Set the token in PowerShell before running dbt:

```powershell
$env:DBT_DATABRICKS_TOKEN = "<your-databricks-pat>"
```

## Running the practice

Activate the virtual environment and move into the dbt project:

```powershell
.\.venv\Scripts\Activate.ps1
Set-Location .\dbt_databricks_sales
```

Useful commands:

```powershell
dbt debug
dbt ls
dbt seed --select lookup
dbt build --select path:models/bronze
dbt test --select path:models/bronze
dbt compile
```

## What each area does

### Sources

The raw inputs are declared in `models/source/sources.yml` under the `s_source` source. The project currently expects these source tables:

- `fact_sales`
- `fact_returns`
- `dim_date`
- `dim_product`
- `dim_customer`
- `dim_store`

### Bronze layer

The `bronze` models currently do simple `select *` passthroughs from the raw source tables. This is a good place to practice:

- column cleanup and renaming
- data typing
- lightweight standardization
- source-level testing

### Seeds

`seeds/lookup.csv` is a small local seed you can load with `dbt seed`. The analysis query in `analyses/1_explore.sql` references this seed with `{{ ref('lookup') }}`.

### Tests

This practice includes:

- built-in tests such as `not_null`, `unique`, and `accepted_values`
- a reusable generic test: `generic_non_negative`
- a singular test: `tests/non_negative_test.sql`

## Notes about the current state

- `models/example/` still contains the dbt starter models from `dbt init`. They are useful for learning, but you can remove them later if you want this repo to focus only on the sales practice.
- `dbt_project.yml` already has `silver` and `gold` configuration blocks, but there are no models in those layers yet.
- The custom macro in `macros/generate_shema.sql` keeps custom schema names like `bronze`, `silver`, and `gold` from being prefixed with the default target schema.

## Suggested next steps

- Add `silver` models that clean and join the bronze layer
- Add a `gold` mart for reporting
- Replace `select *` in bronze with explicit columns
- Add source freshness or source tests
- Document models with richer descriptions and column-level metadata
