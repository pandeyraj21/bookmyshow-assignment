-- schema.sql — BookMyShow-style theatre schedule (BCNF) — PostgreSQL

-- City / location
CREATE TABLE city (
  city_id        SERIAL PRIMARY KEY,
  name           TEXT NOT NULL,
  state          TEXT,
  country        TEXT NOT NULL DEFAULT 'India',
  UNIQUE (name, state, country)
);

-- Theatre (a venue with multiple screens)
CREATE TABLE theatre (
  theatre_id     SERIAL PRIMARY KEY,
  name           TEXT NOT NULL,        -- e.g., 'PVR: Nexus (Forum)'
  chain          TEXT,                 -- e.g., 'PVR'
  address        TEXT,
  city_id        INT NOT NULL REFERENCES city(city_id) ON DELETE RESTRICT,
  UNIQUE (name, city_id)
);

-- Individual auditorium/screen inside a theatre
CREATE TABLE screen (
  screen_id      SERIAL PRIMARY KEY,
  theatre_id     INT NOT NULL REFERENCES theatre(theatre_id) ON DELETE CASCADE,
  name           TEXT NOT NULL,        -- e.g., 'Audi 1'
  capacity       INT NOT NULL,
  UNIQUE (theatre_id, name)
);

-- Certifications (UA, U, A ...)
CREATE TABLE certification (
  certification_id SERIAL PRIMARY KEY,
  code             TEXT NOT NULL UNIQUE
);

-- Movies and attributes
CREATE TABLE movie (
  movie_id        SERIAL PRIMARY KEY,
  title           TEXT NOT NULL,
  duration_min    INT NOT NULL,
  release_date    DATE,
  certification_id INT REFERENCES certification(certification_id),
  UNIQUE (title, release_date)
);

-- Languages (many-to-many with movies)
CREATE TABLE language (
  language_id     SERIAL PRIMARY KEY,
  name            TEXT NOT NULL UNIQUE
);

CREATE TABLE movie_language (
  movie_id        INT NOT NULL REFERENCES movie(movie_id) ON DELETE CASCADE,
  language_id     INT NOT NULL REFERENCES language(language_id) ON DELETE RESTRICT,
  PRIMARY KEY (movie_id, language_id)
);

-- Projection / experience format (2D/3D/IMAX/4K Dolby etc.)
CREATE TABLE format (
  format_id       SERIAL PRIMARY KEY,
  name            TEXT NOT NULL UNIQUE
);

-- Seat types and seats (optional for listing shows, included for completeness)
CREATE TABLE seat_type (
  seat_type_id    SERIAL PRIMARY KEY,
  name            TEXT NOT NULL UNIQUE,
  price_multiplier NUMERIC(6,3) NOT NULL DEFAULT 1.000
);

CREATE TABLE seat (
  seat_id         SERIAL PRIMARY KEY,
  screen_id       INT NOT NULL REFERENCES screen(screen_id) ON DELETE CASCADE,
  row_label       TEXT NOT NULL,
  seat_number     INT  NOT NULL,
  seat_type_id    INT REFERENCES seat_type(seat_type_id),
  UNIQUE (screen_id, row_label, seat_number)
);

-- Scheduled screening (movie on a specific screen at a start time)
CREATE TABLE showtime (
  showtime_id     SERIAL PRIMARY KEY,
  screen_id       INT NOT NULL REFERENCES screen(screen_id) ON DELETE RESTRICT,
  movie_id        INT NOT NULL REFERENCES movie(movie_id) ON DELETE RESTRICT,
  language_id     INT NOT NULL REFERENCES language(language_id) ON DELETE RESTRICT,
  format_id       INT NOT NULL REFERENCES format(format_id) ON DELETE RESTRICT,
  starts_at       TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  base_price_cents INT NOT NULL CHECK (base_price_cents >= 0),
  status          TEXT NOT NULL DEFAULT 'OPEN',  -- OPEN/CANCELLED/SOLD_OUT
  UNIQUE (screen_id, starts_at)
);

-- (Optional) Booking artifacts
CREATE TABLE app_user (
  user_id         SERIAL PRIMARY KEY,
  email           TEXT NOT NULL UNIQUE,
  full_name       TEXT
);

CREATE TABLE booking (
  booking_id      SERIAL PRIMARY KEY,
  user_id         INT NOT NULL REFERENCES app_user(user_id),
  showtime_id     INT NOT NULL REFERENCES showtime(showtime_id) ON DELETE CASCADE,
  booked_at       TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE ticket (
  ticket_id       SERIAL PRIMARY KEY,
  booking_id      INT NOT NULL REFERENCES booking(booking_id) ON DELETE CASCADE,
  showtime_id     INT NOT NULL REFERENCES showtime(showtime_id) ON DELETE CASCADE,
  seat_id         INT NOT NULL REFERENCES seat(seat_id) ON DELETE RESTRICT,
  price_cents     INT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'BOOKED', -- BOOKED/CANCELLED
  UNIQUE (showtime_id, seat_id)
);
