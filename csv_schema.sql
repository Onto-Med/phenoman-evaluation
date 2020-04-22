CREATE TABLE allergies (
    START date,
    STOP date,
    PATIENT uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text
);

CREATE TABLE careplans (
    Id uuid PRIMARY KEY,
    START date,
    STOP date,
    PATIENT uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text,
    REASONCODE text,
    REASONDESCRIPTION text
);

CREATE TABLE conditions (
    START date,
    STOP date,
    PATIENT uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text
);

CREATE TABLE encounters (
    Id uuid PRIMARY KEY,
    START date,
    STOP date,
    PATIENT uuid,
    PROVIDER uuid,
    PAYER uuid,
    ENCOUNTERCLASS text,
    CODE text,
    DESCRIPTION text,
    BASE_ENCOUNTER_COST double precision,
    TOTAL_CLAIM_COST double precision,
    PAYER_COVERAGE double precision,
    REASONCODE text,
    REASONDESCRIPTION text
);

CREATE TABLE imaging_studies (
    Id uuid PRIMARY KEY,
    DATE date,
    PATIENT uuid,
    ENCOUNTER uuid,
    BODYSITE_CODE text,
    BODYSITE_DESCRIPTION text,
    MODALITY_CODE text,
    MODALITY_DESCRIPTION text,
    SOP_CODE text,
    SOP_DESCRIPTION text
);

CREATE TABLE immunizations (
    DATE date,
    PATIENT uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text,
    BASE_COST double precision
);

CREATE TABLE medications (
    START date,
    STOP date,
    PATIENT uuid,
    PAYER uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text,
    BASE_COST double precision,
    PAYER_COVERAGE double precision,
    DISPENSES double precision,
    TOTALCOST double precision,
    REASONCODE text,
    REASONDESCRIPTION text
);

CREATE TABLE observations (
    DATE date,
    PATIENT uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text,
    VALUE text,
    UNITS text,
    TYPE text
);

CREATE TABLE organizations (
    Id uuid PRIMARY KEY,
    NAME text,
    ADDRESS text,
    CITY text,
    STATE text,
    ZIP text,
    LAT double precision,
    LON double precision,
    PHONE text,
    REVENUE double precision,
    UTILIZATION double precision
);

CREATE TABLE patients (
    Id uuid PRIMARY KEY,
    BIRTHDATE date,
    DEATHDATE date,
    SSN text,
    DRIVERS text,
    PASSPORT text,
    PREFIX text,
    FIRST text,
    LAST text,
    SUFFIX text,
    MAIDEN text,
    MARITAL text,
    RACE text,
    ETHNICITY text,
    GENDER text,
    BIRTHPLACE text,
    ADDRESS text,
    CITY text,
    STATE text,
    COUNTY text,
    ZIP text,
    LAT double precision,
    LON double precision,
    HEALTHCARE_EXPENSES double precision,
    HEALTHCARE_COVERAGE double precision
);

CREATE TABLE payer_transitions (
    PATIENT uuid,
    START_YEAR integer,
    END_YEAR integer,
    PAYER uuid,
    OWNERSHIP text
);

CREATE TABLE payers (
    Id uuid PRIMARY KEY,
    NAME text,
    ADDRESS text,
    CITY text,
    STATE_HEADQUARTERED text,
    ZIP text,
    PHONE text,
    AMOUNT_COVERED double precision,
    AMOUNT_UNCOVERED double precision,
    REVENUE double precision,
    COVERED_ENCOUNTERS integer,
    UNCOVERED_ENCOUNTERS integer,
    COVERED_MEDICATIONS integer,
    UNCOVERED_MEDICATIONS integer,
    COVERED_PROCEDURES integer,
    UNCOVERED_PROCEDURES integer,
    COVERED_IMMUNIZATIONS integer,
    UNCOVERED_IMMUNIZATIONS integer,
    UNIQUE_CUSTOMERS integer,
    QOLS_AVG double precision,
    MEMBER_MONTHS integer
);

CREATE TABLE procedures (
    DATE date,
    PATIENT uuid,
    ENCOUNTER uuid,
    CODE text,
    DESCRIPTION text,
    BASE_COST double precision,
    REASONCODE text,
    REASONDESCRIPTION text
);

CREATE TABLE providers (
    Id uuid,
    ORGANIZATION uuid,
    NAME text,
    GENDER text,
    SPECIALITY text,
    ADDRESS text,
    CITY text,
    STATE text,
    ZIP text,
    LAT double precision,
    LON double precision,
    UTILIZATION integer
);