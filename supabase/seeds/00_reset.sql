begin;

truncate table
  deliveries,
  supporters,
  returns,
  categories,
  projects,
  organization_members,
  organizations
restart identity cascade;

commit;
