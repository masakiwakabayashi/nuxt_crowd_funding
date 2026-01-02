begin;

alter table deliveries
  add column if not exists project_id uuid;

alter table deliveries
  alter column project_id drop not null;

update deliveries
set project_id = r.project_id
from rewards r
where deliveries.reward_id = r.id
  and deliveries.project_id is null;

alter table deliveries
  alter column project_id set not null;

do $$
begin
  alter table deliveries
    add constraint deliveries_project_id_fkey
    foreign key (project_id) references projects(id) on delete cascade;
exception
  when duplicate_object then null;
end;
$$;

create index if not exists idx_deliveries_project_id on deliveries(project_id);

commit;
