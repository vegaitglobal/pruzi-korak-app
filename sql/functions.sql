CREATE
OR REPLACE FUNCTION clear_active_device (input_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
UPDATE users
SET
    active_device_id = NULL
WHERE
    id = input_user_id;

RETURN TRUE;

END;

$$ LANGUAGE plpgsql;

-- 
-- 
-- 

CREATE
OR REPLACE FUNCTION handle_user_deletion ()
RETURNS TRIGGER AS $$
BEGIN
SELECT
    value INTO token
FROM
    app_secrets
WHERE
    key = 'service_key_token';

  PERFORM net.http_post(
    url := 'https://bdvaskveojvffluqztqg.supabase.co/functions/v1/handle-deleted-user',
    headers := json_build_object(
      'Content-Type', 'application/json',
      'Authorization', token
    )::jsonb,
    body := json_build_object(
      'user_id', OLD.id
    )::jsonb
  );
RETURN OLD;

END;

$$ LANGUAGE plpgsql;

-- 
-- 
-- 

CREATE
OR REPLACE FUNCTION notify_new_user ()
RETURNS TRIGGER
AS $$
DECLARE token TEXT;

BEGIN
SELECT
    value INTO token
FROM
    app_secrets
WHERE
    key = 'service_key_token';

  PERFORM net.http_post(
    url := 'https://bdvaskveojvffluqztqg.supabase.co/functions/v1/handle-new-user',
    headers := json_build_object(
      'Content-Type', 'application/json',
      'Authorization', token
    )::jsonb,
    body := json_build_object(
      'user_id', NEW.id,
      'email', NEW.email,
      'password', NEW.passcode,
      'raw_user_metadata', to_jsonb(NEW)
    )::jsonb
  );
  RETURN NEW;
END;

$$ LANGUAGE plpgsql;

-- 
-- 
-- 

CREATE
OR REPLACE FUNCTION validate_and_register_device (input_user_id UUID, device_id TEXT)
RETURNS BOOLEAN AS $$
DECLARE device_owner_user_id UUID;

current_active_device_id UUID;

device_owner_active_device_id UUID;

target_device_uuid UUID;

BEGIN
-- Get the user's current active device
SELECT
    active_device_id INTO current_active_device_id
FROM
    users
WHERE
    id = input_user_id;

-- Get the device (if exists)
SELECT
    user_id,
    id INTO device_owner_user_id,
    target_device_uuid
FROM
    devices
WHERE
    identifier = device_id;

-- If user's active device is different from this one
IF current_active_device_id IS NOT NULL
AND (
    target_device_uuid IS NULL
    OR target_device_uuid <> current_active_device_id
) THEN RAISE EXCEPTION 'You are already logged in on another device' USING ERRCODE = '28000';

END IF;

-- If device is owned by another user
IF device_owner_user_id IS NOT NULL
AND device_owner_user_id <> input_user_id THEN
SELECT
    active_device_id INTO device_owner_active_device_id
FROM
    users
WHERE
    id = device_owner_user_id;

IF device_owner_active_device_id IS NOT NULL
AND device_owner_active_device_id <> target_device_uuid THEN RAISE EXCEPTION 'Device already active for another user' USING ERRCODE = '28000';

END IF;

RAISE EXCEPTION 'Device already assigned to another user' USING ERRCODE = '28000';

END IF;

-- Register device if it doesn't exist
IF target_device_uuid IS NULL THEN
INSERT INTO
    devices (id, identifier, user_id)
VALUES
    (gen_random_uuid (), device_id, input_user_id) RETURNING id INTO target_device_uuid;

END IF;

-- Set this device as active for the user
UPDATE users
SET
    active_device_id = target_device_uuid
WHERE
    id = input_user_id;

RETURN TRUE;

END;

$$ LANGUAGE plpgsql;