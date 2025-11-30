alter table "public"."backers" enable row level security;

alter table "public"."fulfillment_digital" enable row level security;

alter table "public"."fulfillment_shipping" enable row level security;

alter table "public"."fulfillments" enable row level security;

alter table "public"."organization_members" enable row level security;

alter table "public"."organizations" enable row level security;

alter table "public"."pledge_items" enable row level security;

alter table "public"."pledges" enable row level security;

alter table "public"."projects" enable row level security;

alter table "public"."reward_tiers" enable row level security;

alter table "public"."reward_variants" enable row level security;

alter table "public"."shipping_addresses" enable row level security;


  create policy "backers_admin_write"
  on "public"."backers"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(organization_id))
with check (public.current_user_is_org_admin(organization_id));



  create policy "backers_select_for_members"
  on "public"."backers"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(organization_id));



  create policy "fulfillment_digital_admin_write"
  on "public"."fulfillment_digital"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.fulfillments f
     JOIN public.projects p ON ((p.id = f.project_id)))
  WHERE (f.id = fulfillment_digital.fulfillment_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.fulfillments f
     JOIN public.projects p ON ((p.id = f.project_id)))
  WHERE (f.id = fulfillment_digital.fulfillment_id))));



  create policy "fulfillment_digital_select_for_members"
  on "public"."fulfillment_digital"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM (public.fulfillments f
     JOIN public.projects p ON ((p.id = f.project_id)))
  WHERE (f.id = fulfillment_digital.fulfillment_id))));



  create policy "fulfillment_shipping_admin_write"
  on "public"."fulfillment_shipping"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.fulfillments f
     JOIN public.projects p ON ((p.id = f.project_id)))
  WHERE (f.id = fulfillment_shipping.fulfillment_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.fulfillments f
     JOIN public.projects p ON ((p.id = f.project_id)))
  WHERE (f.id = fulfillment_shipping.fulfillment_id))));



  create policy "fulfillment_shipping_select_for_members"
  on "public"."fulfillment_shipping"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM (public.fulfillments f
     JOIN public.projects p ON ((p.id = f.project_id)))
  WHERE (f.id = fulfillment_shipping.fulfillment_id))));



  create policy "fulfillments_admin_write"
  on "public"."fulfillments"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = fulfillments.project_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = fulfillments.project_id))));



  create policy "fulfillments_select_for_members"
  on "public"."fulfillments"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = fulfillments.project_id))));



  create policy "fulfillments_staff_update_assigned_only"
  on "public"."fulfillments"
  as permissive
  for update
  to public
using (public.current_user_is_assigned_to_fulfillment(id))
with check (public.current_user_is_assigned_to_fulfillment(id));



  create policy "org_members_admin_delete"
  on "public"."organization_members"
  as permissive
  for delete
  to public
using (public.current_user_is_org_admin(organization_id));



  create policy "org_members_admin_insert"
  on "public"."organization_members"
  as permissive
  for insert
  to public
with check (public.current_user_is_org_admin(organization_id));



  create policy "org_members_admin_update"
  on "public"."organization_members"
  as permissive
  for update
  to public
using (public.current_user_is_org_admin(organization_id))
with check (public.current_user_is_org_admin(organization_id));



  create policy "org_members_select_for_members"
  on "public"."organization_members"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(organization_id));



  create policy "org_select_for_members"
  on "public"."organizations"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(id));



  create policy "org_update_for_admins"
  on "public"."organizations"
  as permissive
  for update
  to public
using (public.current_user_is_org_admin(id))
with check (public.current_user_is_org_admin(id));



  create policy "pledge_items_admin_write"
  on "public"."pledge_items"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.pledges pl
     JOIN public.projects p ON ((p.id = pl.project_id)))
  WHERE (pl.id = pledge_items.pledge_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.pledges pl
     JOIN public.projects p ON ((p.id = pl.project_id)))
  WHERE (pl.id = pledge_items.pledge_id))));



  create policy "pledge_items_select_for_members"
  on "public"."pledge_items"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM (public.pledges pl
     JOIN public.projects p ON ((p.id = pl.project_id)))
  WHERE (pl.id = pledge_items.pledge_id))));



  create policy "pledges_admin_write"
  on "public"."pledges"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = pledges.project_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = pledges.project_id))));



  create policy "pledges_select_for_members"
  on "public"."pledges"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = pledges.project_id))));



  create policy "projects_admin_delete"
  on "public"."projects"
  as permissive
  for delete
  to public
using (public.current_user_is_org_admin(organization_id));



  create policy "projects_admin_insert"
  on "public"."projects"
  as permissive
  for insert
  to public
with check (public.current_user_is_org_admin(organization_id));



  create policy "projects_admin_update"
  on "public"."projects"
  as permissive
  for update
  to public
using (public.current_user_is_org_admin(organization_id))
with check (public.current_user_is_org_admin(organization_id));



  create policy "projects_select_for_members"
  on "public"."projects"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(organization_id));



  create policy "reward_tiers_admin_write"
  on "public"."reward_tiers"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = reward_tiers.project_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = reward_tiers.project_id))));



  create policy "reward_tiers_select_for_members"
  on "public"."reward_tiers"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = reward_tiers.project_id))));



  create policy "reward_variants_admin_write"
  on "public"."reward_variants"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.reward_tiers rt
     JOIN public.projects p ON ((p.id = rt.project_id)))
  WHERE (rt.id = reward_variants.reward_tier_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM (public.reward_tiers rt
     JOIN public.projects p ON ((p.id = rt.project_id)))
  WHERE (rt.id = reward_variants.reward_tier_id))));



  create policy "reward_variants_select_for_members"
  on "public"."reward_variants"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM (public.reward_tiers rt
     JOIN public.projects p ON ((p.id = rt.project_id)))
  WHERE (rt.id = reward_variants.reward_tier_id))));



  create policy "shipping_addresses_admin_write"
  on "public"."shipping_addresses"
  as permissive
  for all
  to public
using (public.current_user_is_org_admin(( SELECT b.organization_id
   FROM public.backers b
  WHERE (b.id = shipping_addresses.backer_id))))
with check (public.current_user_is_org_admin(( SELECT b.organization_id
   FROM public.backers b
  WHERE (b.id = shipping_addresses.backer_id))));



  create policy "shipping_addresses_select_for_members"
  on "public"."shipping_addresses"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT b.organization_id
   FROM public.backers b
  WHERE (b.id = shipping_addresses.backer_id))));


alter table "public"."project_members" enable row level security;


  create policy "project_members_admin_delete"
  on "public"."project_members"
  as permissive
  for delete
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = project_members.project_id))));



  create policy "project_members_admin_insert"
  on "public"."project_members"
  as permissive
  for insert
  to public
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = project_members.project_id))));



  create policy "project_members_admin_update"
  on "public"."project_members"
  as permissive
  for update
  to public
using (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = project_members.project_id))))
with check (public.current_user_is_org_admin(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = project_members.project_id))));



  create policy "project_members_select_for_members"
  on "public"."project_members"
  as permissive
  for select
  to public
using (public.current_user_is_org_member(( SELECT p.organization_id
   FROM public.projects p
  WHERE (p.id = project_members.project_id))));




