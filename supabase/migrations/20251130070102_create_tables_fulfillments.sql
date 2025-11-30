
  create table "public"."fulfillment_digital" (
    "id" uuid not null default gen_random_uuid(),
    "fulfillment_id" uuid not null,
    "download_url" text,
    "access_code" text,
    "expires_at" timestamp with time zone,
    "download_count" integer not null default 0,
    "last_accessed_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."fulfillment_shipping" (
    "id" uuid not null default gen_random_uuid(),
    "fulfillment_id" uuid not null,
    "shipping_address_id" uuid not null,
    "carrier" text,
    "tracking_number" text,
    "shipped_at" timestamp with time zone,
    "delivered_at" timestamp with time zone,
    "shipping_status" text default 'preparing'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );



  create table "public"."fulfillments" (
    "id" uuid not null default gen_random_uuid(),
    "pledge_item_id" uuid not null,
    "project_id" uuid not null,
    "backer_id" uuid not null,
    "type" text not null default 'physical'::text,
    "status" text not null default 'pending'::text,
    "assigned_to" uuid,
    "due_date" date,
    "delivered_at" timestamp with time zone,
    "note" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


CREATE UNIQUE INDEX fulfillment_digital_pkey ON public.fulfillment_digital USING btree (id);

CREATE UNIQUE INDEX fulfillment_shipping_pkey ON public.fulfillment_shipping USING btree (id);

CREATE UNIQUE INDEX fulfillments_pkey ON public.fulfillments USING btree (id);

alter table "public"."fulfillment_digital" add constraint "fulfillment_digital_pkey" PRIMARY KEY using index "fulfillment_digital_pkey";

alter table "public"."fulfillment_shipping" add constraint "fulfillment_shipping_pkey" PRIMARY KEY using index "fulfillment_shipping_pkey";

alter table "public"."fulfillments" add constraint "fulfillments_pkey" PRIMARY KEY using index "fulfillments_pkey";

alter table "public"."fulfillment_digital" add constraint "fulfillment_digital_fulfillment_id_fkey" FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillments(id) ON DELETE CASCADE not valid;

alter table "public"."fulfillment_digital" validate constraint "fulfillment_digital_fulfillment_id_fkey";

alter table "public"."fulfillment_shipping" add constraint "fulfillment_shipping_fulfillment_id_fkey" FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillments(id) ON DELETE CASCADE not valid;

alter table "public"."fulfillment_shipping" validate constraint "fulfillment_shipping_fulfillment_id_fkey";

alter table "public"."fulfillment_shipping" add constraint "fulfillment_shipping_shipping_address_id_fkey" FOREIGN KEY (shipping_address_id) REFERENCES public.shipping_addresses(id) ON DELETE RESTRICT not valid;

alter table "public"."fulfillment_shipping" validate constraint "fulfillment_shipping_shipping_address_id_fkey";

alter table "public"."fulfillments" add constraint "fulfillments_assigned_to_fkey" FOREIGN KEY (assigned_to) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."fulfillments" validate constraint "fulfillments_assigned_to_fkey";

alter table "public"."fulfillments" add constraint "fulfillments_backer_id_fkey" FOREIGN KEY (backer_id) REFERENCES public.backers(id) ON DELETE RESTRICT not valid;

alter table "public"."fulfillments" validate constraint "fulfillments_backer_id_fkey";

alter table "public"."fulfillments" add constraint "fulfillments_pledge_item_id_fkey" FOREIGN KEY (pledge_item_id) REFERENCES public.pledge_items(id) ON DELETE CASCADE not valid;

alter table "public"."fulfillments" validate constraint "fulfillments_pledge_item_id_fkey";

alter table "public"."fulfillments" add constraint "fulfillments_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE not valid;

alter table "public"."fulfillments" validate constraint "fulfillments_project_id_fkey";

grant delete on table "public"."backers" to "postgres";

grant insert on table "public"."backers" to "postgres";

grant references on table "public"."backers" to "postgres";

grant select on table "public"."backers" to "postgres";

grant trigger on table "public"."backers" to "postgres";

grant truncate on table "public"."backers" to "postgres";

grant update on table "public"."backers" to "postgres";

grant delete on table "public"."fulfillment_digital" to "anon";

grant insert on table "public"."fulfillment_digital" to "anon";

grant references on table "public"."fulfillment_digital" to "anon";

grant select on table "public"."fulfillment_digital" to "anon";

grant trigger on table "public"."fulfillment_digital" to "anon";

grant truncate on table "public"."fulfillment_digital" to "anon";

grant update on table "public"."fulfillment_digital" to "anon";

grant delete on table "public"."fulfillment_digital" to "authenticated";

grant insert on table "public"."fulfillment_digital" to "authenticated";

grant references on table "public"."fulfillment_digital" to "authenticated";

grant select on table "public"."fulfillment_digital" to "authenticated";

grant trigger on table "public"."fulfillment_digital" to "authenticated";

grant truncate on table "public"."fulfillment_digital" to "authenticated";

grant update on table "public"."fulfillment_digital" to "authenticated";

grant delete on table "public"."fulfillment_digital" to "postgres";

grant insert on table "public"."fulfillment_digital" to "postgres";

grant references on table "public"."fulfillment_digital" to "postgres";

grant select on table "public"."fulfillment_digital" to "postgres";

grant trigger on table "public"."fulfillment_digital" to "postgres";

grant truncate on table "public"."fulfillment_digital" to "postgres";

grant update on table "public"."fulfillment_digital" to "postgres";

grant delete on table "public"."fulfillment_digital" to "service_role";

grant insert on table "public"."fulfillment_digital" to "service_role";

grant references on table "public"."fulfillment_digital" to "service_role";

grant select on table "public"."fulfillment_digital" to "service_role";

grant trigger on table "public"."fulfillment_digital" to "service_role";

grant truncate on table "public"."fulfillment_digital" to "service_role";

grant update on table "public"."fulfillment_digital" to "service_role";

grant delete on table "public"."fulfillment_shipping" to "anon";

grant insert on table "public"."fulfillment_shipping" to "anon";

grant references on table "public"."fulfillment_shipping" to "anon";

grant select on table "public"."fulfillment_shipping" to "anon";

grant trigger on table "public"."fulfillment_shipping" to "anon";

grant truncate on table "public"."fulfillment_shipping" to "anon";

grant update on table "public"."fulfillment_shipping" to "anon";

grant delete on table "public"."fulfillment_shipping" to "authenticated";

grant insert on table "public"."fulfillment_shipping" to "authenticated";

grant references on table "public"."fulfillment_shipping" to "authenticated";

grant select on table "public"."fulfillment_shipping" to "authenticated";

grant trigger on table "public"."fulfillment_shipping" to "authenticated";

grant truncate on table "public"."fulfillment_shipping" to "authenticated";

grant update on table "public"."fulfillment_shipping" to "authenticated";

grant delete on table "public"."fulfillment_shipping" to "postgres";

grant insert on table "public"."fulfillment_shipping" to "postgres";

grant references on table "public"."fulfillment_shipping" to "postgres";

grant select on table "public"."fulfillment_shipping" to "postgres";

grant trigger on table "public"."fulfillment_shipping" to "postgres";

grant truncate on table "public"."fulfillment_shipping" to "postgres";

grant update on table "public"."fulfillment_shipping" to "postgres";

grant delete on table "public"."fulfillment_shipping" to "service_role";

grant insert on table "public"."fulfillment_shipping" to "service_role";

grant references on table "public"."fulfillment_shipping" to "service_role";

grant select on table "public"."fulfillment_shipping" to "service_role";

grant trigger on table "public"."fulfillment_shipping" to "service_role";

grant truncate on table "public"."fulfillment_shipping" to "service_role";

grant update on table "public"."fulfillment_shipping" to "service_role";

grant delete on table "public"."fulfillments" to "anon";

grant insert on table "public"."fulfillments" to "anon";

grant references on table "public"."fulfillments" to "anon";

grant select on table "public"."fulfillments" to "anon";

grant trigger on table "public"."fulfillments" to "anon";

grant truncate on table "public"."fulfillments" to "anon";

grant update on table "public"."fulfillments" to "anon";

grant delete on table "public"."fulfillments" to "authenticated";

grant insert on table "public"."fulfillments" to "authenticated";

grant references on table "public"."fulfillments" to "authenticated";

grant select on table "public"."fulfillments" to "authenticated";

grant trigger on table "public"."fulfillments" to "authenticated";

grant truncate on table "public"."fulfillments" to "authenticated";

grant update on table "public"."fulfillments" to "authenticated";

grant delete on table "public"."fulfillments" to "postgres";

grant insert on table "public"."fulfillments" to "postgres";

grant references on table "public"."fulfillments" to "postgres";

grant select on table "public"."fulfillments" to "postgres";

grant trigger on table "public"."fulfillments" to "postgres";

grant truncate on table "public"."fulfillments" to "postgres";

grant update on table "public"."fulfillments" to "postgres";

grant delete on table "public"."fulfillments" to "service_role";

grant insert on table "public"."fulfillments" to "service_role";

grant references on table "public"."fulfillments" to "service_role";

grant select on table "public"."fulfillments" to "service_role";

grant trigger on table "public"."fulfillments" to "service_role";

grant truncate on table "public"."fulfillments" to "service_role";

grant update on table "public"."fulfillments" to "service_role";

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

grant delete on table "public"."pledge_items" to "postgres";

grant insert on table "public"."pledge_items" to "postgres";

grant references on table "public"."pledge_items" to "postgres";

grant select on table "public"."pledge_items" to "postgres";

grant trigger on table "public"."pledge_items" to "postgres";

grant truncate on table "public"."pledge_items" to "postgres";

grant update on table "public"."pledge_items" to "postgres";

grant delete on table "public"."pledges" to "postgres";

grant insert on table "public"."pledges" to "postgres";

grant references on table "public"."pledges" to "postgres";

grant select on table "public"."pledges" to "postgres";

grant trigger on table "public"."pledges" to "postgres";

grant truncate on table "public"."pledges" to "postgres";

grant update on table "public"."pledges" to "postgres";

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

grant delete on table "public"."shipping_addresses" to "postgres";

grant insert on table "public"."shipping_addresses" to "postgres";

grant references on table "public"."shipping_addresses" to "postgres";

grant select on table "public"."shipping_addresses" to "postgres";

grant trigger on table "public"."shipping_addresses" to "postgres";

grant truncate on table "public"."shipping_addresses" to "postgres";

grant update on table "public"."shipping_addresses" to "postgres";


