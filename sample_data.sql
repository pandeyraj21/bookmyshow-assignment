-- sample_data.sql — minimal dataset aligned with screenshot feel

-- Cities
INSERT INTO city (name, state) VALUES ('Bengaluru', 'Karnataka');

-- Theatre & screens
INSERT INTO theatre (name, chain, city_id) 
VALUES ('PVR: Nexus (Forum)', 'PVR', 1);

INSERT INTO screen (theatre_id, name, capacity) VALUES
(1, 'Audi 1', 220),
(1, 'Audi 2', 200);

-- Certifications
INSERT INTO certification (code) VALUES ('UA'), ('U'), ('A');

-- Languages
INSERT INTO language (name) VALUES ('Hindi'), ('Telugu'), ('English');

-- Formats
INSERT INTO format (name) VALUES ('2D'), ('3D'), ('4K Dolby 7.1');

-- Movies
INSERT INTO movie (title, duration_min, release_date, certification_id) VALUES
('Dasara', 156, '2023-03-30', (SELECT certification_id FROM certification WHERE code='UA')),
('Kisi Ka Bhai Kisi Ki Jaan', 145, '2023-04-21', (SELECT certification_id FROM certification WHERE code='UA')),
('Tu Jhoothi Main Makkaar', 164, '2023-03-08', (SELECT certification_id FROM certification WHERE code='UA')),
('Avatar: The Way of Water', 192, '2022-12-16', (SELECT certification_id FROM certification WHERE code='UA'));

-- Movie supported languages
INSERT INTO movie_language VALUES
((SELECT movie_id FROM movie WHERE title='Dasara'), (SELECT language_id FROM language WHERE name='Telugu')),
((SELECT movie_id FROM movie WHERE title='Kisi Ka Bhai Kisi Ki Jaan'), (SELECT language_id FROM language WHERE name='Hindi')),
((SELECT movie_id FROM movie WHERE title='Tu Jhoothi Main Makkaar'), (SELECT language_id FROM language WHERE name='Hindi')),
((SELECT movie_id FROM movie WHERE title='Avatar: The Way of Water'), (SELECT language_id FROM language WHERE name='English'));

-- A sample day of showtimes (e.g., 2023-04-25)
INSERT INTO showtime (screen_id, movie_id, language_id, format_id, starts_at, base_price_cents) VALUES
-- Dasara (Telugu, 2D)
(1, (SELECT movie_id FROM movie WHERE title='Dasara'),
    (SELECT language_id FROM language WHERE name='Telugu'),
    (SELECT format_id FROM format WHERE name='2D'),
    '2023-04-25 12:15', 25000),

-- Kisi Ka Bhai Kisi Ki Jaan (Hindi, variants)
(1, (SELECT movie_id FROM movie WHERE title='Kisi Ka Bhai Kisi Ki Jaan'),
    (SELECT language_id FROM language WHERE name='Hindi'),
    (SELECT format_id FROM format WHERE name='2D'),
    '2023-04-25 13:00', 26000),
(1, (SELECT movie_id FROM movie WHERE title='Kisi Ka Bhai Kisi Ki Jaan'),
    (SELECT language_id FROM language WHERE name='Hindi'),
    (SELECT format_id FROM format WHERE name='4K Dolby 7.1'),
    '2023-04-25 16:10', 29000),
(2, (SELECT movie_id FROM movie WHERE title='Kisi Ka Bhai Kisi Ki Jaan'),
    (SELECT language_id FROM language WHERE name='Hindi'),
    (SELECT format_id FROM format WHERE name='2D'),
    '2023-04-25 18:20', 26000),
(2, (SELECT movie_id FROM movie WHERE title='Kisi Ka Bhai Kisi Ki Jaan'),
    (SELECT language_id FROM language WHERE name='Hindi'),
    (SELECT format_id FROM format WHERE name='4K Dolby 7.1'),
    '2023-04-25 19:20', 29000),
(1, (SELECT movie_id FROM movie WHERE title='Kisi Ka Bhai Kisi Ki Jaan'),
    (SELECT language_id FROM language WHERE name='Hindi'),
    (SELECT format_id FROM format WHERE name='4K Dolby 7.1'),
    '2023-04-25 22:30', 29000),

-- Tu Jhoothi Main Makkaar (Hindi, 2D)
(2, (SELECT movie_id FROM movie WHERE title='Tu Jhoothi Main Makkaar'),
    (SELECT language_id FROM language WHERE name='Hindi'),
    (SELECT format_id FROM format WHERE name='2D'),
    '2023-04-25 21:15', 25000),

-- Avatar (English, 3D)
(1, (SELECT movie_id FROM movie WHERE title='Avatar: The Way of Water'),
    (SELECT language_id FROM language WHERE name='English'),
    (SELECT format_id FROM format WHERE name='3D'),
    '2023-04-25 12:30', 32000);
