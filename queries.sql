
-- Find all songs longer than 5 minutes
SELECT * FROM "songs"
WHERE "duration_in_seconds" > 300;

-- Find the first 100 songs in the database, organised alphabetically
SELECT * FROM "songs"
ORDER BY "song_title"
LIMIT 100;

-- Find all albums with a duration longer than 1 hour
SELECT * FROM "albums"
WHERE "duration_in_seconds" > 3600;

-- Find all albums released from 1990 onwards
SELECT * FROM "albums"
WHERE "release_date" >= '1990-01-01';

-- Find all bands that are still currently active
SELECT * FROM "bands"
WHERE "is_active" = true;

-- Find all songs in a specific album
SELECT * FROM "songs"
WHERE "album_id" = (
    SELECT "id" FROM "albums"
    WHERE "album_title" = "Led Zeppelin II"
);

-- Find all musicians who are known to play a given instrument
SELECT *
FROM "musicians"
WHERE "id" IN (
    SELECT "musician_id"
    FROM "proficiencies"
    WHERE "instrument_id" = (
        SELECT "id" FROM "instruments"
        WHERE "instrument_name" = "bass guitar"
    )
);

-- Find all musicians in a given band
SELECT *
FROM "musicians"
WHERE "id" IN (
    SELECT "musician_id"
    FROM "memberships"
    WHERE "band_id" = (
        SELECT "id" FROM "bands"
        WHERE "band_name" = 'Led Zeppelin'
    )
);

-- Find all bands that a musician belongs to
SELECT *
FROM "bands"
WHERE "id" IN (
    SELECT "band_id"
    FROM "memberships"
    WHERE "musician_id" = (
        SELECT "id" FROM "musicians"
        WHERE "first_name" = "John Paul" AND "last_name" = "Jones"
    )
);

-- Inserting Values Into Table

-- Add a new band
INSERT INTO "bands" ("band_name", "year_formed", "number_of_albums", "is_active")
VALUES ('Led Zeppelin', 1968, 8, false);

-- Add new albums (albums should only be added after their respective band is added, so as not to violate foreign key constraints)
INSERT INTO "albums" ("band_id", "album_title", "duration_in_seconds", "release_date")
VALUES
(1, 'Led Zeppelin II', 2497, '1969-10-22'),
(1, 'Led Zeppelin', 2693, '1969-01-12');

-- Add new songs (songs should only be added after their respective album is added, so as not to violate foreign key constraints)
INSERT INTO "songs" ("album_id", "song_title", "duration_in_seconds")
VALUES
(1, 'Whole Lotta Love', 334),
(1, 'What Is and What Should Never Be', 286),
(1, 'The Lemon Song', 379),
(1, 'Thank You', 289),
(1, 'Heartbreaker', 254),
(1, 'Living Loving Maid (She''s Just a Woman)', 159),
(1, 'Ramble On', 274),
(1, 'Moby Dick', 260),
(1, 'Bring It on Home', 259),
(2, 'Good Times Bad Times', 166),
(2, 'Babe I''m Gonna Leave You', 402),
(2, 'You Shook Me', 388),
(2, 'Dazed and Confused', 388),
(2, 'Your Time Is Gonna Come', 274),
(2, 'Black Mountain Side', 132),
(2, 'Communication Breakdown', 150),
(2, 'I Can''t Quit You Baby', 282),
(2, 'How Many More Times', 507);

-- Add new musicians
INSERT INTO "musicians" ("first_name", "last_name", "date_of_birth", "is_active")
VALUES
('John Paul', 'Jones', '1946-01-03', true),
('Robert', 'Plant', '1948-08-20', true),
('John', 'Bonham', '1948-05-31', false),
('Jimmy', 'Page', '1944-01-09', true);

-- Add a new instrument
INSERT INTO "instruments" ("instrument_name", "instrument_type")
VALUES
('bass guitar', 'string'),
('electric guitar', 'string'),
('drums', 'percussion');

-- Add a new membership (relating bands and musicians)
INSERT INTO "memberships" ("band_id", "musician_id")
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4);

-- Add a new proficiency (relating musicians and instruments)
INSERT INTO "proficiencies" ("musician_id", "instrument_id")
VALUES
(1, 1),
(3, 3),
(4, 2);

-- Update the name of a column in the instruments table
UPDATE "instruments"
SET "instrument_name" = "bass"
WHERE "instrument_name" = "bass guitar";

-- Delete bands with no albums released
DELETE FROM "bands"
WHERE "number_of_albums" = 0;