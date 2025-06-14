CREATE TABLE
    organizations (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        name VARCHAR(255),
        mediaUrl TEXT,
        message TEXT
    );

CREATE TABLE
    social_media (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        instagramUrl VARCHAR(255),
        linkedInUrl VARCHAR(255),
        facebookUrl VARCHAR(255),
        twitterUrl VARCHAR(255),
        websiteUrl1 VARCHAR(255),
        websiteUrl2 VARCHAR(255),
        organizationId UUID,
        FOREIGN KEY (organizationId) REFERENCES organizations (id)
    );

CREATE TABLE
    campaigns (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        name VARCHAR(255),
        message TEXT,
        startDate DATE,
        endDate DATE,
        organizationId UUID,
        FOREIGN KEY (organizationId) REFERENCES organizations (id)
    );

CREATE TABLE
    motivational_messages (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        message TEXT,
        campaignId UUID,
        FOREIGN KEY (campaignId) REFERENCES campaigns (id)
    );

CREATE TABLE
    teams (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        name VARCHAR(255),
        campaignId UUID,
        FOREIGN KEY (campaignId) REFERENCES campaigns (id)
    );

CREATE TABLE
    users (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        firstName VARCHAR(255),
        lastName VARCHAR(255),
        email VARCHAR(255) UNIQUE,
        passcode VARCHAR(255),
        mediaUrl TEXT,
        activeDeviceId UUID,
        teamId UUID,
        FOREIGN KEY (teamId) REFERENCES teams (id)
    );

CREATE TABLE
    devices (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        identifier VARCHAR(255) UNIQUE,
        userId UUID,
        FOREIGN KEY (userId) REFERENCES users (id)
    );

CREATE TABLE
    daily_user_distances (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        date DATE,
        totalKilometers DOUBLE PRECISION,
        userId UUID,
        FOREIGN KEY (userId) REFERENCES users (id)
    );

CREATE TABLE
    app_secrets (key TEXT PRIMARY KEY, value TEXT NOT NULL);

ALTER TABLE app_secrets enable ROW LEVEL SECURITY;

INSERT INTO
    app_secrets (key, value)
VALUES
    ('service_role_key', '{SERVICE_ROLE_KEY}');