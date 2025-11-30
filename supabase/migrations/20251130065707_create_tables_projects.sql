
  create table "public"."project_members" (
    "id" uuid not null default gen_random_uuid(),
    "project_id" uuid not null,
    "user_id" uuid not null,
    "role" text not null default 'member'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."projects" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid not null,
    "name" text not null,
    "platform" text,
    "external_project_id" text,
    "project_url" text,
    "start_date" date,
    "end_date" date,
    "status" text not null default 'draft'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."reward_tiers" (
    "id" uuid not null default gen_random_uuid(),
    "project_id" uuid not null,
    "code" text,
    "title" text not null,
    "description" text,
    "price" numeric(12,2) not null,
    "type" text not null default 'physical'::text,
    "requires_shipping" boolean not null default false,
    "estimated_delivery_date" date,
    "max_backers" integer,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."reward_variants" (
    "id" uuid not null default gen_random_uuid(),
    "reward_tier_id" uuid not null,
    "name" text not null,
    "code" text,
    "extra_note" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


CREATE UNIQUE INDEX project_members_pkey ON public.project_members USING btree (id);

CREATE UNIQUE INDEX project_members_project_id_user_id_key ON public.project_members USING btree (project_id, user_id);

CREATE UNIQUE INDEX projects_pkey ON public.projects USING btree (id);

CREATE UNIQUE INDEX reward_tiers_pkey ON public.reward_tiers USING btree (id);

CREATE UNIQUE INDEX reward_variants_pkey ON public.reward_variants USING btree (id);

alter table "public"."project_members" add constraint "project_members_pkey" PRIMARY KEY using index "project_members_pkey";

alter table "public"."projects" add constraint "projects_pkey" PRIMARY KEY using index "projects_pkey";

alter table "public"."reward_tiers" add constraint "reward_tiers_pkey" PRIMARY KEY using index "reward_tiers_pkey";

alter table "public"."reward_variants" add constraint "reward_variants_pkey" PRIMARY KEY using index "reward_variants_pkey";

alter table "public"."project_members" add constraint "project_members_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE not valid;

alter table "public"."project_members" validate constraint "project_members_project_id_fkey";

alter table "public"."project_members" add constraint "project_members_project_id_user_id_key" UNIQUE using index "project_members_project_id_user_id_key";

alter table "public"."project_members" add constraint "project_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."project_members" validate constraint "project_members_user_id_fkey";

alter table "public"."projects" add constraint "projects_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE not valid;

alter table "public"."projects" validate constraint "projects_organization_id_fkey";

alter table "public"."reward_tiers" add constraint "reward_tiers_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE not valid;

alter table "public"."reward_tiers" validate constraint "reward_tiers_project_id_fkey";

alter table "public"."reward_variants" add constraint "reward_variants_reward_tier_id_fkey" FOREIGN KEY (reward_tier_id) REFERENCES public.reward_tiers(id) ON DELETE CASCADE not valid;

alter table "public"."reward_variants" validate constraint "reward_variants_reward_tier_id_fkey";

grant delete on table "public"."organization_members" to "postgres";

grant insert on table "public"."organization_members" to "postgres";

grant references on table "public"."organization_members" to "postgres";

grant select on table "public"."organization_members" to "postgres";

grant trigger on table "public"."organization_members" to "postgres";

grant truncate on table "public"."organization_members" to "postgres";

grant update on table "public"."organization_members" to "postgres";

grant delete on table "public"."organizations" to "postgres";

grant insert on table "public"."organizations" to "postgres";

grant references on table "public"."organizations" to "postgres";

grant select on table "public"."organizations" to "postgres";

grant trigger on table "public"."organizations" to "postgres";

grant truncate on table "public"."organizations" to "postgres";

grant update on table "public"."organizations" to "postgres";

grant delete on table "public"."project_members" to "anon";

grant insert on table "public"."project_members" to "anon";

grant references on table "public"."project_members" to "anon";

grant select on table "public"."project_members" to "anon";

grant trigger on table "public"."project_members" to "anon";

grant truncate on table "public"."project_members" to "anon";

grant update on table "public"."project_members" to "anon";

grant delete on table "public"."project_members" to "authenticated";

grant insert on table "public"."project_members" to "authenticated";

grant references on table "public"."project_members" to "authenticated";

grant select on table "public"."project_members" to "authenticated";

grant trigger on table "public"."project_members" to "authenticated";

grant truncate on table "public"."project_members" to "authenticated";

grant update on table "public"."project_members" to "authenticated";

grant delete on table "public"."project_members" to "postgres";

grant insert on table "public"."project_members" to "postgres";

grant references on table "public"."project_members" to "postgres";

grant select on table "public"."project_members" to "postgres";

grant trigger on table "public"."project_members" to "postgres";

grant truncate on table "public"."project_members" to "postgres";

grant update on table "public"."project_members" to "postgres";

grant delete on table "public"."project_members" to "service_role";

grant insert on table "public"."project_members" to "service_role";

grant references on table "public"."project_members" to "service_role";

grant select on table "public"."project_members" to "service_role";

grant trigger on table "public"."project_members" to "service_role";

grant truncate on table "public"."project_members" to "service_role";

grant update on table "public"."project_members" to "service_role";

grant delete on table "public"."projects" to "anon";

grant insert on table "public"."projects" to "anon";

grant references on table "public"."projects" to "anon";

grant select on table "public"."projects" to "anon";

grant trigger on table "public"."projects" to "anon";

grant truncate on table "public"."projects" to "anon";

grant update on table "public"."projects" to "anon";

grant delete on table "public"."projects" to "authenticated";

grant insert on table "public"."projects" to "authenticated";

grant references on table "public"."projects" to "authenticated";

grant select on table "public"."projects" to "authenticated";

grant trigger on table "public"."projects" to "authenticated";

grant truncate on table "public"."projects" to "authenticated";

grant update on table "public"."projects" to "authenticated";

grant delete on table "public"."projects" to "postgres";

grant insert on table "public"."projects" to "postgres";

grant references on table "public"."projects" to "postgres";

grant select on table "public"."projects" to "postgres";

grant trigger on table "public"."projects" to "postgres";

grant truncate on table "public"."projects" to "postgres";

grant update on table "public"."projects" to "postgres";

grant delete on table "public"."projects" to "service_role";

grant insert on table "public"."projects" to "service_role";

grant references on table "public"."projects" to "service_role";

grant select on table "public"."projects" to "service_role";

grant trigger on table "public"."projects" to "service_role";

grant truncate on table "public"."projects" to "service_role";

grant update on table "public"."projects" to "service_role";

grant delete on table "public"."reward_tiers" to "anon";

grant insert on table "public"."reward_tiers" to "anon";

grant references on table "public"."reward_tiers" to "anon";

grant select on table "public"."reward_tiers" to "anon";

grant trigger on table "public"."reward_tiers" to "anon";

grant truncate on table "public"."reward_tiers" to "anon";

grant update on table "public"."reward_tiers" to "anon";

grant delete on table "public"."reward_tiers" to "authenticated";

grant insert on table "public"."reward_tiers" to "authenticated";

grant references on table "public"."reward_tiers" to "authenticated";

grant select on table "public"."reward_tiers" to "authenticated";

grant trigger on table "public"."reward_tiers" to "authenticated";

grant truncate on table "public"."reward_tiers" to "authenticated";

grant update on table "public"."reward_tiers" to "authenticated";

grant delete on table "public"."reward_tiers" to "postgres";

grant insert on table "public"."reward_tiers" to "postgres";

grant references on table "public"."reward_tiers" to "postgres";

grant select on table "public"."reward_tiers" to "postgres";

grant trigger on table "public"."reward_tiers" to "postgres";

grant truncate on table "public"."reward_tiers" to "postgres";

grant update on table "public"."reward_tiers" to "postgres";

grant delete on table "public"."reward_tiers" to "service_role";

grant insert on table "public"."reward_tiers" to "service_role";

grant references on table "public"."reward_tiers" to "service_role";

grant select on table "public"."reward_tiers" to "service_role";

grant trigger on table "public"."reward_tiers" to "service_role";

grant truncate on table "public"."reward_tiers" to "service_role";

grant update on table "public"."reward_tiers" to "service_role";

grant delete on table "public"."reward_variants" to "anon";

grant insert on table "public"."reward_variants" to "anon";

grant references on table "public"."reward_variants" to "anon";

grant select on table "public"."reward_variants" to "anon";

grant trigger on table "public"."reward_variants" to "anon";

grant truncate on table "public"."reward_variants" to "anon";

grant update on table "public"."reward_variants" to "anon";

grant delete on table "public"."reward_variants" to "authenticated";

grant insert on table "public"."reward_variants" to "authenticated";

grant references on table "public"."reward_variants" to "authenticated";

grant select on table "public"."reward_variants" to "authenticated";

grant trigger on table "public"."reward_variants" to "authenticated";

grant truncate on table "public"."reward_variants" to "authenticated";

grant update on table "public"."reward_variants" to "authenticated";

grant delete on table "public"."reward_variants" to "postgres";

grant insert on table "public"."reward_variants" to "postgres";

grant references on table "public"."reward_variants" to "postgres";

grant select on table "public"."reward_variants" to "postgres";

grant trigger on table "public"."reward_variants" to "postgres";

grant truncate on table "public"."reward_variants" to "postgres";

grant update on table "public"."reward_variants" to "postgres";

grant delete on table "public"."reward_variants" to "service_role";

grant insert on table "public"."reward_variants" to "service_role";

grant references on table "public"."reward_variants" to "service_role";

grant select on table "public"."reward_variants" to "service_role";

grant trigger on table "public"."reward_variants" to "service_role";

grant truncate on table "public"."reward_variants" to "service_role";

grant update on table "public"."reward_variants" to "service_role";


