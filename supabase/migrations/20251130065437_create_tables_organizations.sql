
  create table "public"."organization_members" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid not null,
    "user_id" uuid not null,
    "role" text not null default 'member'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."organizations" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "plan" text not null default 'free'::text,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


CREATE UNIQUE INDEX organization_members_organization_id_user_id_key ON public.organization_members USING btree (organization_id, user_id);

CREATE UNIQUE INDEX organization_members_pkey ON public.organization_members USING btree (id);

CREATE UNIQUE INDEX organizations_pkey ON public.organizations USING btree (id);

alter table "public"."organization_members" add constraint "organization_members_pkey" PRIMARY KEY using index "organization_members_pkey";

alter table "public"."organizations" add constraint "organizations_pkey" PRIMARY KEY using index "organizations_pkey";

alter table "public"."organization_members" add constraint "organization_members_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE not valid;

alter table "public"."organization_members" validate constraint "organization_members_organization_id_fkey";

alter table "public"."organization_members" add constraint "organization_members_organization_id_user_id_key" UNIQUE using index "organization_members_organization_id_user_id_key";

alter table "public"."organization_members" add constraint "organization_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."organization_members" validate constraint "organization_members_user_id_fkey";

grant delete on table "public"."organization_members" to "anon";

grant insert on table "public"."organization_members" to "anon";

grant references on table "public"."organization_members" to "anon";

grant select on table "public"."organization_members" to "anon";

grant trigger on table "public"."organization_members" to "anon";

grant truncate on table "public"."organization_members" to "anon";

grant update on table "public"."organization_members" to "anon";

grant delete on table "public"."organization_members" to "authenticated";

grant insert on table "public"."organization_members" to "authenticated";

grant references on table "public"."organization_members" to "authenticated";

grant select on table "public"."organization_members" to "authenticated";

grant trigger on table "public"."organization_members" to "authenticated";

grant truncate on table "public"."organization_members" to "authenticated";

grant update on table "public"."organization_members" to "authenticated";

grant delete on table "public"."organization_members" to "postgres";

grant insert on table "public"."organization_members" to "postgres";

grant references on table "public"."organization_members" to "postgres";

grant select on table "public"."organization_members" to "postgres";

grant trigger on table "public"."organization_members" to "postgres";

grant truncate on table "public"."organization_members" to "postgres";

grant update on table "public"."organization_members" to "postgres";

grant delete on table "public"."organization_members" to "service_role";

grant insert on table "public"."organization_members" to "service_role";

grant references on table "public"."organization_members" to "service_role";

grant select on table "public"."organization_members" to "service_role";

grant trigger on table "public"."organization_members" to "service_role";

grant truncate on table "public"."organization_members" to "service_role";

grant update on table "public"."organization_members" to "service_role";

grant delete on table "public"."organizations" to "anon";

grant insert on table "public"."organizations" to "anon";

grant references on table "public"."organizations" to "anon";

grant select on table "public"."organizations" to "anon";

grant trigger on table "public"."organizations" to "anon";

grant truncate on table "public"."organizations" to "anon";

grant update on table "public"."organizations" to "anon";

grant delete on table "public"."organizations" to "authenticated";

grant insert on table "public"."organizations" to "authenticated";

grant references on table "public"."organizations" to "authenticated";

grant select on table "public"."organizations" to "authenticated";

grant trigger on table "public"."organizations" to "authenticated";

grant truncate on table "public"."organizations" to "authenticated";

grant update on table "public"."organizations" to "authenticated";

grant delete on table "public"."organizations" to "postgres";

grant insert on table "public"."organizations" to "postgres";

grant references on table "public"."organizations" to "postgres";

grant select on table "public"."organizations" to "postgres";

grant trigger on table "public"."organizations" to "postgres";

grant truncate on table "public"."organizations" to "postgres";

grant update on table "public"."organizations" to "postgres";

grant delete on table "public"."organizations" to "service_role";

grant insert on table "public"."organizations" to "service_role";

grant references on table "public"."organizations" to "service_role";

grant select on table "public"."organizations" to "service_role";

grant trigger on table "public"."organizations" to "service_role";

grant truncate on table "public"."organizations" to "service_role";

grant update on table "public"."organizations" to "service_role";


