
  create table "public"."backers" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid not null,
    "name" text not null,
    "email" text,
    "phone" text,
    "note" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."pledge_items" (
    "id" uuid not null default gen_random_uuid(),
    "pledge_id" uuid not null,
    "reward_tier_id" uuid not null,
    "reward_variant_id" uuid,
    "quantity" integer not null default 1,
    "unit_price" numeric(12,2) not null,
    "note" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."pledges" (
    "id" uuid not null default gen_random_uuid(),
    "project_id" uuid not null,
    "backer_id" uuid not null,
    "external_pledge_id" text,
    "pledged_amount" numeric(12,2) not null,
    "currency" text not null default 'JPY'::text,
    "pledged_at" timestamp with time zone not null default now(),
    "status" text not null default 'confirmed'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."shipping_addresses" (
    "id" uuid not null default gen_random_uuid(),
    "backer_id" uuid not null,
    "project_id" uuid not null,
    "name" text not null,
    "postal_code" text,
    "prefecture" text,
    "address_line1" text,
    "address_line2" text,
    "address_line3" text,
    "country" text default 'Japan'::text,
    "phone" text,
    "is_default" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


CREATE UNIQUE INDEX backers_pkey ON public.backers USING btree (id);

CREATE UNIQUE INDEX pledge_items_pkey ON public.pledge_items USING btree (id);

CREATE UNIQUE INDEX pledges_pkey ON public.pledges USING btree (id);

CREATE UNIQUE INDEX shipping_addresses_pkey ON public.shipping_addresses USING btree (id);

alter table "public"."backers" add constraint "backers_pkey" PRIMARY KEY using index "backers_pkey";

alter table "public"."pledge_items" add constraint "pledge_items_pkey" PRIMARY KEY using index "pledge_items_pkey";

alter table "public"."pledges" add constraint "pledges_pkey" PRIMARY KEY using index "pledges_pkey";

alter table "public"."shipping_addresses" add constraint "shipping_addresses_pkey" PRIMARY KEY using index "shipping_addresses_pkey";

alter table "public"."backers" add constraint "backers_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE not valid;

alter table "public"."backers" validate constraint "backers_organization_id_fkey";

alter table "public"."pledge_items" add constraint "pledge_items_pledge_id_fkey" FOREIGN KEY (pledge_id) REFERENCES public.pledges(id) ON DELETE CASCADE not valid;

alter table "public"."pledge_items" validate constraint "pledge_items_pledge_id_fkey";

alter table "public"."pledge_items" add constraint "pledge_items_reward_tier_id_fkey" FOREIGN KEY (reward_tier_id) REFERENCES public.reward_tiers(id) ON DELETE RESTRICT not valid;

alter table "public"."pledge_items" validate constraint "pledge_items_reward_tier_id_fkey";

alter table "public"."pledge_items" add constraint "pledge_items_reward_variant_id_fkey" FOREIGN KEY (reward_variant_id) REFERENCES public.reward_variants(id) ON DELETE SET NULL not valid;

alter table "public"."pledge_items" validate constraint "pledge_items_reward_variant_id_fkey";

alter table "public"."pledges" add constraint "pledges_backer_id_fkey" FOREIGN KEY (backer_id) REFERENCES public.backers(id) ON DELETE RESTRICT not valid;

alter table "public"."pledges" validate constraint "pledges_backer_id_fkey";

alter table "public"."pledges" add constraint "pledges_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE not valid;

alter table "public"."pledges" validate constraint "pledges_project_id_fkey";

alter table "public"."shipping_addresses" add constraint "shipping_addresses_backer_id_fkey" FOREIGN KEY (backer_id) REFERENCES public.backers(id) ON DELETE CASCADE not valid;

alter table "public"."shipping_addresses" validate constraint "shipping_addresses_backer_id_fkey";

alter table "public"."shipping_addresses" add constraint "shipping_addresses_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE not valid;

alter table "public"."shipping_addresses" validate constraint "shipping_addresses_project_id_fkey";

grant delete on table "public"."backers" to "anon";

grant insert on table "public"."backers" to "anon";

grant references on table "public"."backers" to "anon";

grant select on table "public"."backers" to "anon";

grant trigger on table "public"."backers" to "anon";

grant truncate on table "public"."backers" to "anon";

grant update on table "public"."backers" to "anon";

grant delete on table "public"."backers" to "authenticated";

grant insert on table "public"."backers" to "authenticated";

grant references on table "public"."backers" to "authenticated";

grant select on table "public"."backers" to "authenticated";

grant trigger on table "public"."backers" to "authenticated";

grant truncate on table "public"."backers" to "authenticated";

grant update on table "public"."backers" to "authenticated";

grant delete on table "public"."backers" to "postgres";

grant insert on table "public"."backers" to "postgres";

grant references on table "public"."backers" to "postgres";

grant select on table "public"."backers" to "postgres";

grant trigger on table "public"."backers" to "postgres";

grant truncate on table "public"."backers" to "postgres";

grant update on table "public"."backers" to "postgres";

grant delete on table "public"."backers" to "service_role";

grant insert on table "public"."backers" to "service_role";

grant references on table "public"."backers" to "service_role";

grant select on table "public"."backers" to "service_role";

grant trigger on table "public"."backers" to "service_role";

grant truncate on table "public"."backers" to "service_role";

grant update on table "public"."backers" to "service_role";

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

grant delete on table "public"."pledge_items" to "anon";

grant insert on table "public"."pledge_items" to "anon";

grant references on table "public"."pledge_items" to "anon";

grant select on table "public"."pledge_items" to "anon";

grant trigger on table "public"."pledge_items" to "anon";

grant truncate on table "public"."pledge_items" to "anon";

grant update on table "public"."pledge_items" to "anon";

grant delete on table "public"."pledge_items" to "authenticated";

grant insert on table "public"."pledge_items" to "authenticated";

grant references on table "public"."pledge_items" to "authenticated";

grant select on table "public"."pledge_items" to "authenticated";

grant trigger on table "public"."pledge_items" to "authenticated";

grant truncate on table "public"."pledge_items" to "authenticated";

grant update on table "public"."pledge_items" to "authenticated";

grant delete on table "public"."pledge_items" to "postgres";

grant insert on table "public"."pledge_items" to "postgres";

grant references on table "public"."pledge_items" to "postgres";

grant select on table "public"."pledge_items" to "postgres";

grant trigger on table "public"."pledge_items" to "postgres";

grant truncate on table "public"."pledge_items" to "postgres";

grant update on table "public"."pledge_items" to "postgres";

grant delete on table "public"."pledge_items" to "service_role";

grant insert on table "public"."pledge_items" to "service_role";

grant references on table "public"."pledge_items" to "service_role";

grant select on table "public"."pledge_items" to "service_role";

grant trigger on table "public"."pledge_items" to "service_role";

grant truncate on table "public"."pledge_items" to "service_role";

grant update on table "public"."pledge_items" to "service_role";

grant delete on table "public"."pledges" to "anon";

grant insert on table "public"."pledges" to "anon";

grant references on table "public"."pledges" to "anon";

grant select on table "public"."pledges" to "anon";

grant trigger on table "public"."pledges" to "anon";

grant truncate on table "public"."pledges" to "anon";

grant update on table "public"."pledges" to "anon";

grant delete on table "public"."pledges" to "authenticated";

grant insert on table "public"."pledges" to "authenticated";

grant references on table "public"."pledges" to "authenticated";

grant select on table "public"."pledges" to "authenticated";

grant trigger on table "public"."pledges" to "authenticated";

grant truncate on table "public"."pledges" to "authenticated";

grant update on table "public"."pledges" to "authenticated";

grant delete on table "public"."pledges" to "postgres";

grant insert on table "public"."pledges" to "postgres";

grant references on table "public"."pledges" to "postgres";

grant select on table "public"."pledges" to "postgres";

grant trigger on table "public"."pledges" to "postgres";

grant truncate on table "public"."pledges" to "postgres";

grant update on table "public"."pledges" to "postgres";

grant delete on table "public"."pledges" to "service_role";

grant insert on table "public"."pledges" to "service_role";

grant references on table "public"."pledges" to "service_role";

grant select on table "public"."pledges" to "service_role";

grant trigger on table "public"."pledges" to "service_role";

grant truncate on table "public"."pledges" to "service_role";

grant update on table "public"."pledges" to "service_role";

grant delete on table "public"."project_members" to "postgres";

grant insert on table "public"."project_members" to "postgres";

grant references on table "public"."project_members" to "postgres";

grant select on table "public"."project_members" to "postgres";

grant trigger on table "public"."project_members" to "postgres";

grant truncate on table "public"."project_members" to "postgres";

grant update on table "public"."project_members" to "postgres";

grant delete on table "public"."projects" to "postgres";

grant insert on table "public"."projects" to "postgres";

grant references on table "public"."projects" to "postgres";

grant select on table "public"."projects" to "postgres";

grant trigger on table "public"."projects" to "postgres";

grant truncate on table "public"."projects" to "postgres";

grant update on table "public"."projects" to "postgres";

grant delete on table "public"."reward_tiers" to "postgres";

grant insert on table "public"."reward_tiers" to "postgres";

grant references on table "public"."reward_tiers" to "postgres";

grant select on table "public"."reward_tiers" to "postgres";

grant trigger on table "public"."reward_tiers" to "postgres";

grant truncate on table "public"."reward_tiers" to "postgres";

grant update on table "public"."reward_tiers" to "postgres";

grant delete on table "public"."reward_variants" to "postgres";

grant insert on table "public"."reward_variants" to "postgres";

grant references on table "public"."reward_variants" to "postgres";

grant select on table "public"."reward_variants" to "postgres";

grant trigger on table "public"."reward_variants" to "postgres";

grant truncate on table "public"."reward_variants" to "postgres";

grant update on table "public"."reward_variants" to "postgres";

grant delete on table "public"."shipping_addresses" to "anon";

grant insert on table "public"."shipping_addresses" to "anon";

grant references on table "public"."shipping_addresses" to "anon";

grant select on table "public"."shipping_addresses" to "anon";

grant trigger on table "public"."shipping_addresses" to "anon";

grant truncate on table "public"."shipping_addresses" to "anon";

grant update on table "public"."shipping_addresses" to "anon";

grant delete on table "public"."shipping_addresses" to "authenticated";

grant insert on table "public"."shipping_addresses" to "authenticated";

grant references on table "public"."shipping_addresses" to "authenticated";

grant select on table "public"."shipping_addresses" to "authenticated";

grant trigger on table "public"."shipping_addresses" to "authenticated";

grant truncate on table "public"."shipping_addresses" to "authenticated";

grant update on table "public"."shipping_addresses" to "authenticated";

grant delete on table "public"."shipping_addresses" to "postgres";

grant insert on table "public"."shipping_addresses" to "postgres";

grant references on table "public"."shipping_addresses" to "postgres";

grant select on table "public"."shipping_addresses" to "postgres";

grant trigger on table "public"."shipping_addresses" to "postgres";

grant truncate on table "public"."shipping_addresses" to "postgres";

grant update on table "public"."shipping_addresses" to "postgres";

grant delete on table "public"."shipping_addresses" to "service_role";

grant insert on table "public"."shipping_addresses" to "service_role";

grant references on table "public"."shipping_addresses" to "service_role";

grant select on table "public"."shipping_addresses" to "service_role";

grant trigger on table "public"."shipping_addresses" to "service_role";

grant truncate on table "public"."shipping_addresses" to "service_role";

grant update on table "public"."shipping_addresses" to "service_role";


