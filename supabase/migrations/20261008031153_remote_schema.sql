SET local check_function_bodies = off;

CREATE SEQUENCE "public"."carrito_items_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."cortes_caja_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."failed_jobs_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."jobs_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."mermas_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."migrations_id_seq" AS integer INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."pedido_items_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."pedidos_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."productos_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."roles_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE SEQUENCE "public"."users_id_seq" AS bigint INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1 CACHE 1 NO CYCLE;

CREATE TABLE "public"."cache_locks" (
  "key"        character varying(255) NOT NULL,
  "owner"      character varying(255) NOT NULL,
  "expiration" integer                NOT NULL,
  CONSTRAINT "cache_locks_pkey" PRIMARY KEY (key)
);

ALTER TABLE "public"."cache_locks"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."cache" (
  "key"        character varying(255) NOT NULL,
  "value"      text                   NOT NULL,
  "expiration" integer                NOT NULL,
  CONSTRAINT "cache_pkey" PRIMARY KEY (key)
);

ALTER TABLE "public"."cache"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."carrito_items" (
  "id"          bigint                         NOT NULL DEFAULT nextval('public.carrito_items_id_seq'::regclass),
  "user_id"     bigint                         NOT NULL,
  "producto_id" bigint                         NOT NULL,
  "cantidad"    integer                        NOT NULL DEFAULT 1,
  "created_at"  timestamp(0) without time zone,
  "updated_at"  timestamp(0) without time zone,
  CONSTRAINT "carrito_items_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."carrito_items"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."cortes_caja" (
  "id"              bigint                         NOT NULL DEFAULT nextval('public.cortes_caja_id_seq'::regclass),
  "user_id"         bigint                         NOT NULL,
  "monto_inicial"   numeric(10,2)                  NOT NULL DEFAULT '0'::numeric,
  "ventas_efectivo" numeric(10,2)                  NOT NULL DEFAULT '0'::numeric,
  "ventas_tarjeta"  numeric(10,2)                  NOT NULL DEFAULT '0'::numeric,
  "total_caja"      numeric(10,2)                  NOT NULL DEFAULT '0'::numeric,
  "diferencia"      numeric(10,2)                  NOT NULL DEFAULT '0'::numeric,
  "observaciones"   text,
  "created_at"      timestamp(0) without time zone,
  "updated_at"      timestamp(0) without time zone,
  CONSTRAINT "cortes_caja_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."cortes_caja"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."failed_jobs" (
  "id"         bigint                         NOT NULL DEFAULT nextval('public.failed_jobs_id_seq'::regclass),
  "uuid"       character varying(255)         NOT NULL,
  "connection" text                           NOT NULL,
  "queue"      text                           NOT NULL,
  "payload"    text                           NOT NULL,
  "exception"  text                           NOT NULL,
  "failed_at"  timestamp(0) without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "failed_jobs_pkey" PRIMARY KEY (id),
  CONSTRAINT "failed_jobs_uuid_unique" UNIQUE (uuid)
);

ALTER TABLE "public"."failed_jobs"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."job_batches" (
  "id"             character varying(255) NOT NULL,
  "name"           character varying(255) NOT NULL,
  "total_jobs"     integer                NOT NULL,
  "pending_jobs"   integer                NOT NULL,
  "failed_jobs"    integer                NOT NULL,
  "failed_job_ids" text                   NOT NULL,
  "options"        text,
  "cancelled_at"   integer,
  "created_at"     integer                NOT NULL,
  "finished_at"    integer,
  CONSTRAINT "job_batches_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."job_batches"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."jobs" (
  "id"           bigint                 NOT NULL DEFAULT nextval('public.jobs_id_seq'::regclass),
  "queue"        character varying(255) NOT NULL,
  "payload"      text                   NOT NULL,
  "attempts"     smallint               NOT NULL,
  "reserved_at"  integer,
  "available_at" integer                NOT NULL,
  "created_at"   integer                NOT NULL,
  CONSTRAINT "jobs_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."jobs"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."mermas" (
  "id"            bigint                         NOT NULL DEFAULT nextval('public.mermas_id_seq'::regclass),
  "producto_id"   bigint                         NOT NULL,
  "user_id"       bigint                         NOT NULL,
  "cantidad"      integer                        NOT NULL,
  "motivo"        character varying(255)         NOT NULL,
  "observaciones" text,
  "created_at"    timestamp(0) without time zone,
  "updated_at"    timestamp(0) without time zone,
  CONSTRAINT "mermas_motivo_check"
    CHECK
    (((motivo)::text = ANY ((ARRAY['mortalidad_biologica'::character varying, 'daño_equipo'::character varying, 'caducidad_insumo'::character varying,
    'ajuste_inventario'::character varying])::text[]))),
  CONSTRAINT "mermas_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."mermas"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."migrations" (
  "id"        integer                NOT NULL DEFAULT nextval('public.migrations_id_seq'::regclass),
  "migration" character varying(255) NOT NULL,
  "batch"     integer                NOT NULL,
  CONSTRAINT "migrations_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."migrations"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."password_reset_tokens" (
  "email"      character varying(255)         NOT NULL,
  "token"      character varying(255)         NOT NULL,
  "created_at" timestamp(0) without time zone,
  CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY (email)
);

ALTER TABLE "public"."password_reset_tokens"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."pedido_items" (
  "id"              bigint                         NOT NULL DEFAULT nextval('public.pedido_items_id_seq'::regclass),
  "pedido_id"       bigint                         NOT NULL,
  "producto_id"     bigint                         NOT NULL,
  "cantidad"        integer                        NOT NULL,
  "precio_unitario" numeric(8,2)                   NOT NULL,
  "created_at"      timestamp(0) without time zone,
  "updated_at"      timestamp(0) without time zone,
  CONSTRAINT "pedido_items_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."pedido_items"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."pedidos" (
  "id"                       bigint                         NOT NULL DEFAULT nextval('public.pedidos_id_seq'::regclass),
  "user_id"                  bigint                         NOT NULL,
  "folio"                    character varying(255)         NOT NULL,
  "total"                    numeric(10,2)                  NOT NULL,
  "metodo_entrega"           character varying(255)         NOT NULL DEFAULT 'click_collect'::character varying,
  "estado"                   character varying(255)         NOT NULL DEFAULT 'pendiente_pago'::character varying,
  "carta_responsiva_firmada" boolean                        NOT NULL DEFAULT false,
  "codigo_qr"                character varying(255),
  "apartado_expira_at"       timestamp(0) without time zone,
  "created_at"               timestamp(0) without time zone,
  "updated_at"               timestamp(0) without time zone,
  "estatus_pedido"           character varying(255)         NOT NULL DEFAULT 'pendiente'::character varying,
  CONSTRAINT "pedidos_estado_check"
    CHECK
    (((estado)::text = ANY ((ARRAY['pendiente_pago'::character varying, 'pagado'::character varying, 'en_picking'::character varying, 'listo_mostrador'::character varying,
    'entregado'::character varying, 'cancelado'::character varying])::text[]))),
  CONSTRAINT "pedidos_estatus_pedido_check"
    CHECK
    (((estatus_pedido)::text = ANY ((ARRAY['pendiente'::character varying, 'en_picking'::character varying, 'listo_para_recoleccion'::character varying, 'completado'::character
    varying, 'cancelado'::character varying])::text[]))),
  CONSTRAINT "pedidos_folio_unique" UNIQUE (folio),
  CONSTRAINT "pedidos_metodo_entrega_check" CHECK (((metodo_entrega)::text = ANY ((ARRAY['envio_domicilio'::character varying, 'click_collect'::character varying])::text[]))),
  CONSTRAINT "pedidos_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."pedidos"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."productos" (
  "id"                bigint                         NOT NULL DEFAULT nextval('public.productos_id_seq'::regclass),
  "nombre"            character varying(255)         NOT NULL,
  "tipo"              character varying(255)         NOT NULL,
  "precio"            numeric(8,2)                   NOT NULL,
  "stock"             integer                        NOT NULL DEFAULT 0,
  "imagen_url"        character varying(255),
  "ph_min"            double precision,
  "ph_max"            double precision,
  "temp_min"          double precision,
  "temp_max"          double precision,
  "nivel_agresividad" character varying(255),
  "tipo_agua"         character varying(255)         NOT NULL DEFAULT 'dulce'::character varying,
  "estatus"           boolean                        NOT NULL DEFAULT true,
  "created_at"        timestamp(0) without time zone,
  "updated_at"        timestamp(0) without time zone,
  CONSTRAINT "productos_nivel_agresividad_check"
    CHECK (((nivel_agresividad)::text = ANY ((ARRAY['pacifico'::character varying, 'semi_agresivo'::character varying, 'agresivo'::character varying])::text[]))),
  CONSTRAINT "productos_pkey" PRIMARY KEY (id),
  CONSTRAINT "productos_tipo_agua_check" CHECK (((tipo_agua)::text = ANY ((ARRAY['dulce'::character varying, 'salada'::character varying, 'ambos'::character varying])::text[]))),
  CONSTRAINT "productos_tipo_check"
    CHECK (((tipo)::text = ANY ((ARRAY['fauna'::character varying, 'flora'::character varying, 'equipo'::character varying, 'insumo'::character varying])::text[])))
);

ALTER TABLE "public"."productos"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."roles" (
  "id"          bigint                         NOT NULL DEFAULT nextval('public.roles_id_seq'::regclass),
  "nombre"      character varying(255)         NOT NULL,
  "descripcion" character varying(255),
  "created_at"  timestamp(0) without time zone,
  "updated_at"  timestamp(0) without time zone,
  CONSTRAINT "roles_nombre_unique" UNIQUE (nombre),
  CONSTRAINT "roles_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."roles"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."sessions" (
  "id"            character varying(255) NOT NULL,
  "user_id"       bigint,
  "ip_address"    character varying(45),
  "user_agent"    text,
  "payload"       text                   NOT NULL,
  "last_activity" integer                NOT NULL,
  CONSTRAINT "sessions_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."sessions"
  ENABLE ROW LEVEL SECURITY;

CREATE TABLE "public"."users" (
  "id"                bigint                         NOT NULL DEFAULT nextval('public.users_id_seq'::regclass),
  "role_id"           bigint                         NOT NULL DEFAULT '5'::bigint,
  "name"              character varying(255)         NOT NULL,
  "email"             character varying(255)         NOT NULL,
  "email_verified_at" timestamp(0) without time zone,
  "password"          character varying(255)         NOT NULL,
  "telefono"          character varying(15),
  "direccion"         text,
  "estatus"           boolean                        NOT NULL DEFAULT true,
  "remember_token"    character varying(100),
  "created_at"        timestamp(0) without time zone,
  "updated_at"        timestamp(0) without time zone,
  CONSTRAINT "users_email_unique" UNIQUE (email),
  CONSTRAINT "users_pkey" PRIMARY KEY (id)
);

ALTER TABLE "public"."users"
  ENABLE ROW LEVEL SECURITY;

ALTER SEQUENCE "public"."carrito_items_id_seq" OWNED BY "public"."carrito_items"."id";

ALTER SEQUENCE "public"."cortes_caja_id_seq" OWNED BY "public"."cortes_caja"."id";

ALTER SEQUENCE "public"."failed_jobs_id_seq" OWNED BY "public"."failed_jobs"."id";

ALTER SEQUENCE "public"."jobs_id_seq" OWNED BY "public"."jobs"."id";

ALTER SEQUENCE "public"."mermas_id_seq" OWNED BY "public"."mermas"."id";

ALTER SEQUENCE "public"."migrations_id_seq" OWNED BY "public"."migrations"."id";

ALTER SEQUENCE "public"."pedido_items_id_seq" OWNED BY "public"."pedido_items"."id";

ALTER SEQUENCE "public"."pedidos_id_seq" OWNED BY "public"."pedidos"."id";

ALTER SEQUENCE "public"."productos_id_seq" OWNED BY "public"."productos"."id";

ALTER SEQUENCE "public"."roles_id_seq" OWNED BY "public"."roles"."id";

ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";

CREATE OR REPLACE FUNCTION public.rls_auto_enable()
  RETURNS event_trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path TO 'pg_catalog'
  AS $function$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$function$;

ALTER TABLE "public"."pedido_items"
  ADD CONSTRAINT "pedido_items_pedido_id_foreign" FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;

ALTER TABLE "public"."carrito_items"
  ADD CONSTRAINT "carrito_items_producto_id_foreign" FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;

ALTER TABLE "public"."mermas"
  ADD CONSTRAINT "mermas_producto_id_foreign" FOREIGN KEY (producto_id) REFERENCES public.productos(id) ON DELETE CASCADE;

ALTER TABLE "public"."pedido_items"
  ADD CONSTRAINT "pedido_items_producto_id_foreign" FOREIGN KEY (producto_id) REFERENCES public.productos(id);

ALTER TABLE "public"."carrito_items"
  ADD CONSTRAINT "carrito_items_user_id_foreign" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

ALTER TABLE "public"."cortes_caja"
  ADD CONSTRAINT "cortes_caja_user_id_foreign" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

ALTER TABLE "public"."mermas"
  ADD CONSTRAINT "mermas_user_id_foreign" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

ALTER TABLE "public"."pedidos"
  ADD CONSTRAINT "pedidos_user_id_foreign" FOREIGN KEY (user_id) REFERENCES public.users(id);

ALTER TABLE "public"."users"
  ADD CONSTRAINT "users_role_id_foreign" FOREIGN KEY (role_id) REFERENCES public.roles(id);

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);

CREATE EVENT TRIGGER "ensure_rls"
  ON ddl_command_end
  WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
  EXECUTE FUNCTION "public"."rls_auto_enable"();

GRANT EXECUTE ON FUNCTION "public"."rls_auto_enable"() TO PUBLIC, "anon", "authenticated";

REVOKE ALL ON FUNCTION "public"."rls_auto_enable"() FROM "postgres";

GRANT EXECUTE ON FUNCTION "public"."rls_auto_enable"() TO "postgres";

GRANT EXECUTE ON FUNCTION "public"."rls_auto_enable"() TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."carrito_items_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."carrito_items_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."carrito_items_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."carrito_items_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."cortes_caja_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."cortes_caja_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."cortes_caja_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."cortes_caja_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."failed_jobs_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."failed_jobs_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."failed_jobs_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."failed_jobs_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."jobs_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."jobs_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."jobs_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."jobs_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."mermas_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."mermas_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."mermas_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."mermas_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."migrations_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."migrations_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."migrations_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."migrations_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pedido_items_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."pedido_items_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pedido_items_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pedido_items_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pedidos_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."pedidos_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pedidos_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."pedidos_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."productos_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."productos_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."productos_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."productos_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."roles_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."roles_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."roles_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."roles_id_seq" TO "service_role";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."users_id_seq" TO "anon", "authenticated";

REVOKE ALL ON SEQUENCE "public"."users_id_seq" FROM "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."users_id_seq" TO "postgres";

GRANT SELECT, UPDATE, USAGE ON SEQUENCE "public"."users_id_seq" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cache" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."cache" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cache" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cache" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cache_locks" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."cache_locks" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cache_locks" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cache_locks" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."carrito_items" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."carrito_items" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."carrito_items" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."carrito_items" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cortes_caja" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."cortes_caja" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cortes_caja" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."cortes_caja" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."failed_jobs" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."failed_jobs" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."failed_jobs" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."failed_jobs" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."job_batches" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."job_batches" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."job_batches" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."job_batches" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."jobs" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."jobs" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."jobs" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."jobs" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mermas" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."mermas" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mermas" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."mermas" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."migrations" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."migrations" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."migrations" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."migrations" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."password_reset_tokens" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."password_reset_tokens" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."password_reset_tokens" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."password_reset_tokens" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pedido_items" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."pedido_items" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pedido_items" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pedido_items" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pedidos" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."pedidos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pedidos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."pedidos" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."productos" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."productos" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."productos" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."productos" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."roles" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."roles" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."roles" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."roles" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."sessions" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."sessions" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."sessions" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."sessions" TO "service_role";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "anon", "authenticated";

REVOKE ALL ON TABLE "public"."users" FROM "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "postgres";

GRANT DELETE, INSERT, MAINTAIN, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE ON TABLE "public"."users" TO "service_role";

