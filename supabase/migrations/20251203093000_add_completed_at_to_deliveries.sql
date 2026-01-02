-------------------------------------------------------------------------------
-- Add completed_at column to deliveries for tracking fulfillment date
-------------------------------------------------------------------------------

alter table deliveries
  add column if not exists completed_at timestamp with time zone;

comment on column deliveries.completed_at is 'Actual completion date for the reward delivery';
