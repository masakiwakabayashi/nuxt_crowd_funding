-------------------------------------------------------------------------------
-- Extend returns and supporters with pricing/schedule fields for dashboard data
-------------------------------------------------------------------------------

alter table returns
  add column if not exists price numeric(20, 0) not null default 0,
  add column if not exists estimated_delivery timestamp with time zone;

comment on column returns.price is 'Price of the reward tier in the project''s currency';
comment on column returns.estimated_delivery is 'Estimated delivery date for the reward tier';

alter table supporters
  add column if not exists pledged_amount numeric(20, 0) not null default 0;

comment on column supporters.pledged_amount is 'Total amount pledged by the supporter for the related project';
