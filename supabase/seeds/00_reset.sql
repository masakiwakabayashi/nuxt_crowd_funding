begin;

truncate table
  deliveries,
  supporters,
  rewards,
  categories,
  projects,
  organization_members,
  organizations
restart identity cascade;

commit;
