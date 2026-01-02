-------------------------------------------------------------------------------
-- Add due_date column to deliveries for planned delivery scheduling
-------------------------------------------------------------------------------

alter table deliveries
  add column if not exists due_date timestamp with time zone;

comment on column deliveries.due_date is 'Planned delivery date for the reward shipment';
