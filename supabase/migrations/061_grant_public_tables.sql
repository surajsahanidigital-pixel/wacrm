-- ============================================================
-- 061_grant_public_tables.sql
-- Grant schema and table privileges to standard Supabase roles
-- ============================================================

-- Ensure roles can access public schema
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;

-- Grant standard table, sequence, and routine privileges
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO anon, authenticated, service_role;

-- Ensure future objects inherit permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON ROUTINES TO anon, authenticated, service_role;

-- Re-apply intentional revocations from earlier migrations:
-- 1. pending_message_statuses is an internal worker queue table (migration 054)
REVOKE ALL ON TABLE pending_message_statuses FROM anon, authenticated;

-- 2. notifications update is restricted to read_at only (migration 027)
REVOKE UPDATE ON notifications FROM authenticated;
GRANT UPDATE (read_at) ON notifications TO authenticated;
