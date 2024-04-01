
-- Create tables

-- Represent songs in the jukebox
CREATE TABLE "songs" (
  "id" INTEGER,
  "album_id" INTEGER,
  "song_title" TEXT NOT NULL,
  "duration_in_seconds" INTEGER NOT NULL CHECK (length("duration_in_seconds") >= 0),
  PRIMARY KEY("id"),
  FOREIGN KEY("album_id") REFERENCES "albums"("id")
);

-- Represent albums in the jukebox
CREATE TABLE "albums" (
  "id" INTEGER,
  "band_id" INTEGER,
  "album_title" TEXT NOT NULL,
  "duration_in_seconds" INTEGER NOT NULL CHECK (length("duration_in_seconds") >= 0),
  "release_date" TEXT NOT NULL,
  PRIMARY KEY("id"),
  FOREIGN KEY("band_id") REFERENCES "bands"("id")
);

-- Represent a list of bands
CREATE TABLE "bands" (
  "id" INTEGER,
  "band_name" TEXT NOT NULL,
  "year_formed" INTEGER NOT NULL,
  "number_of_albums" INTEGER NOT NULL CHECK (length("number_of_albums") >= 0),
  "is_active" BOOLEAN NOT NULL,
  PRIMARY KEY("id")
);

-- Represent a list of musicians
CREATE TABLE "musicians" (
  "id" INTEGER,
  "first_name" TEXT NOT NULL,
  "last_name" TEXT NOT NULL,
  "date_of_birth" TEXT NOT NULL,
  "is_active" BOOLEAN NOT NULL,
  PRIMARY KEY("id")
);

-- Represent a list of musical instruments
CREATE TABLE "instruments" (
  "id" INTEGER,
  "instrument_name" TEXT NOT NULL,
  "instrument_type" TEXT NOT NULL,
  PRIMARY KEY("id")
);

-- Junction table to represent the many-to-many relationship between bands and musicians
CREATE TABLE "memberships" (
  "id" INTEGER,
  "band_id" INTEGER,
  "musician_id" INTEGER,
  PRIMARY KEY("id"),
  FOREIGN KEY("band_id") REFERENCES "bands"("id"),
  FOREIGN KEY("musician_id") REFERENCES "musicians"("id")
);

-- Junction table to represent the many-to-many relationship between musicians and instruments
CREATE TABLE "proficiencies" (
  "id" INTEGER,
  "musician_id" INTEGER,
  "instrument_id" INTEGER,
  PRIMARY KEY("id"),
  FOREIGN KEY("musician_id") REFERENCES "musicians"("id"),
  FOREIGN KEY("instrument_id") REFERENCES "instruments"("id")
);

-- Create indexes to speed common searches
CREATE INDEX "musician_name_search" ON "musicians" ("first_name", "last_name");
CREATE INDEX "song_search" ON "songs" ("song_name");
CREATE INDEX "band_search" ON "bands" ("band_name");
CREATE INDEX "album_number_search" ON "bands" ("number_of_albums");

-- Create views

-- Create band_discography view
CREATE VIEW band_discography AS
SELECT "song_title", "album_title", "songs"."duration_in_seconds" AS "song length", "albums"."duration_in_seconds" AS "album length",
"release_date" AS "album release date", "band_name"
FROM "songs"
JOIN "albums" ON "songs"."album_id" = "albums"."id"
JOIN "bands" ON "albums"."band_id" = "bands"."id";

-- create band_members view
CREATE VIEW band_members AS
SELECT "first_name", "last_name", "instrument_name", "instrument_type", "band_name", "year_formed" AS "year_band_formed",
"bands"."is_active" AS "band_is_active", "musicians"."is_active" AS "musician_is_active"  FROM "bands"
FULL OUTER JOIN "memberships" ON "bands"."id" = "memberships"."band_id"
FULL OUTER JOIN "musicians" ON "memberships"."musician_id" = "musicians"."id"
FULL OUTER JOIN "proficiencies" ON "musicians"."id" = "proficiencies"."musician_id"
FULL OUTER JOIN "instruments" ON "proficiencies"."instrument_id" = "instruments"."id";