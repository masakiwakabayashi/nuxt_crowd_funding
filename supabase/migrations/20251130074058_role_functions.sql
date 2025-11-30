set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.current_user_is_org_admin(org_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
  select exists (
    select 1
    from public.organization_members om
    where om.organization_id = org_id
      and om.user_id = auth.uid()
      and om.role = 'admin'
  );
$function$
;

CREATE OR REPLACE FUNCTION public.current_user_is_org_member(org_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
  select exists (
    select 1
    from public.organization_members om
    where om.organization_id = org_id
      and om.user_id = auth.uid()
  );
$function$
;

CREATE OR REPLACE FUNCTION public.current_user_is_assigned_to_fulfillment(f_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
  select exists (
    select 1
    from public.fulfillments f
    where f.id = f_id
      and f.assigned_to = auth.uid()
  );
$function$
;


