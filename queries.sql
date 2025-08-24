-- queries.sql — Part 2

-- (a) Flat list: all showtimes on a given date at a given theatre
-- Replace :theatre_name and :show_date with your values (or use psql variables).
SELECT
  th.name              AS theatre,
  sc.name              AS screen,
  m.title              AS movie,
  l.name               AS language,
  c.code               AS certification,
  f.name               AS format,
  to_char(st.starts_at, 'HH12:MI AM') AS time
FROM showtime st
JOIN screen sc       ON sc.screen_id = st.screen_id
JOIN theatre th      ON th.theatre_id = sc.theatre_id
JOIN movie m         ON m.movie_id = st.movie_id
LEFT JOIN certification c ON c.certification_id = m.certification_id
JOIN language l      ON l.language_id = st.language_id
JOIN format f        ON f.format_id = st.format_id
WHERE th.name = :theatre_name
  AND st.starts_at::date = :show_date
ORDER BY m.title, l.name, f.name, st.starts_at;

-- (b) Grouped timings per movie+language+format (comma-separated times)
SELECT
  m.title                          AS movie,
  l.name                           AS language,
  c.code                           AS certification,
  f.name                           AS format,
  STRING_AGG(to_char(st.starts_at, 'HH12:MI AM'), ', ' ORDER BY st.starts_at) AS show_times
FROM showtime st
JOIN screen sc   ON sc.screen_id = st.screen_id
JOIN theatre th  ON th.theatre_id = sc.theatre_id
JOIN movie m     ON m.movie_id = st.movie_id
LEFT JOIN certification c ON c.certification_id = m.certification_id
JOIN language l ON l.language_id = st.language_id
JOIN format f   ON f.format_id = st.format_id
WHERE th.name = :theatre_name
  AND st.starts_at::date = :show_date
GROUP BY m.title, l.name, c.code, f.name
ORDER BY m.title, l.name, f.name;
