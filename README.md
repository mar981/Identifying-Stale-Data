# Identifying-Stale-Data
- Identified stale tables that were not actively refreshed/updated tables in our main production schemas by DBT or referenced by any Looker objects.
- Engineered a custom SQL script utilizing Redshift’s system tables to identify any tables and schemas actively touched by either DBT workflows or Looker’s objects (by updating to filter on redshift user) when creating visualization in production so as to weed out stale tables. 
