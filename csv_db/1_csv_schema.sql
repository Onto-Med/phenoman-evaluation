CREATE TABLE allergies (
    start       DATE,
    stop        DATE,
    patient     UUID,
    encounter   UUID,
    code        TEXT,
    description TEXT
);

CREATE TABLE careplans (
    id                    UUID  PRIMARY KEY,
    start                 DATE,
    stop                  DATE,
    patient               UUID,
    encounter             UUID,
    code                  TEXT,
    description           TEXT,
    reasoncode            TEXT,
    reasoncodedescription TEXT
);

CREATE TABLE conditions (
    start       DATE,
    stop        DATE,
    patient     UUID,
    encounter   UUID,
    code        TEXT,
    description TEXT
);

CREATE TABLE encounters (
    id                  UUID              PRIMARY KEY,
    start               DATE,
    stop                DATE,
    patient             UUID,
    provider            UUID,
    payer               UUID,
    encounterclass      TEXT,
    code                TEXT,
    description         TEXT,
    base_encounter_cost DOUBLE PRECISION,
    total_claim_cost    DOUBLE PRECISION,
    payer_coverage      DOUBLE PRECISION,
    reasoncode          TEXT,
    reasondescription   TEXT
);

CREATE TABLE imaging_studies (
    id                   UUID  PRIMARY KEY,
    date                 DATE,
    patient              UUID,
    encounter            UUID,
    bodysite_code        TEXT,
    bodysite_description TEXT,
    modality_code        TEXT,
    modality_description TEXT,
    sop_code             TEXT,
    sop_description      TEXT
);

CREATE TABLE immunizations (
    date        DATE,
    patient     UUID,
    encounter   UUID,
    code        TEXT,
    description TEXT,
    base_cost   DOUBLE PRECISION
);

CREATE TABLE medications (
    start             DATE,
    stop              DATE,
    patient           UUID,
    payer             UUID,
    encounter         UUID,
    code              TEXT,
    description       TEXT,
    base_cost         DOUBLE PRECISION,
    payer_coverage    DOUBLE PRECISION,
    dispenses         DOUBLE PRECISION,
    totalcost         DOUBLE PRECISION,
    reasoncode        TEXT,
    reasondescription TEXT
);

CREATE TABLE observations (
    date        DATE,
    patient     UUID,
    encounter   UUID,
    code        TEXT,
    description TEXT,
    value       TEXT,
    units       TEXT,
    type        TEXT
);

CREATE TABLE organizations (
    id          UUID              PRIMARY KEY,
    name        TEXT,
    address     TEXT,
    city        TEXT,
    state       TEXT,
    zip         TEXT,
    lat         DOUBLE PRECISION,
    lon         DOUBLE PRECISION,
    phone       TEXT,
    revenue     DOUBLE PRECISION,
    utilization DOUBLE PRECISION
);

CREATE TABLE patients (
    id                  UUID             PRIMARY KEY,
    birthdate           DATE,
    deathdate           DATE,
    ssn                 TEXT,
    drivers             TEXT,
    passport            TEXT,
    prefix              TEXT,
    first               TEXT,
    last                TEXT,
    suffix              TEXT,
    maiden              TEXT,
    marital             TEXT,
    race                TEXT,
    ethnicity           TEXT,
    gender              TEXT,
    birthplace          TEXT,
    address             TEXT,
    city                TEXT,
    state               TEXT,
    county              TEXT,
    zip                 TEXT,
    lat                 DOUBLE PRECISION,
    lon                 DOUBLE PRECISION,
    healthcare_expenses DOUBLE PRECISION,
    healthcare_coverage DOUBLE PRECISION
);

CREATE TABLE payer_transitions (
    patient    UUID,
    START_YEAR INTEGER,
    end_year   INTEGER,
    payer      UUID,
    ownership  TEXT
);

CREATE TABLE payers (
    id                      UUID              PRIMARY KEY,
    name                    TEXT,
    address                 TEXT,
    city                    TEXT,
    state_headquartered     TEXT,
    zip                     TEXT,
    phone                   TEXT,
    amount_covered          DOUBLE PRECISION,
    amount_uncovered        DOUBLE PRECISION,
    revenue                 DOUBLE PRECISION,
    covered_encounters      INTEGER,
    uncovered_encounters    INTEGER,
    covered_medications     INTEGER,
    uncovered_medications   INTEGER,
    covered_procedures      INTEGER,
    uncovered_procedures    INTEGER,
    covered_immunizations   INTEGER,
    uncovered_immunizations INTEGER,
    unique_customers        INTEGER,
    qols_avg                DOUBLE PRECISION,
    member_months           INTEGER
);

CREATE TABLE procedures (
    date              DATE,
    patient           UUID,
    encounter         UUID,
    code              TEXT,
    description       TEXT,
    base_cost         DOUBLE PRECISION,
    reasoncode        TEXT,
    reasondescription TEXT
);

CREATE TABLE providers (
    id           UUID,
    organization UUID,
    name         TEXT,
    gender       TEXT,
    speciality   TEXT,
    address      TEXT,
    city         TEXT,
    state        TEXT,
    zip          TEXT,
    lat          DOUBLE PRECISION,
    lon          DOUBLE PRECISION,
    utilization  INTEGER
);

CREATE INDEX ON patients (gender);
CREATE INDEX ON observations (patient);
CREATE INDEX ON observations (code);
CREATE INDEX ON conditions (patient);
CREATE INDEX ON conditions (code);