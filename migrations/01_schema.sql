DROP TABLE IF EXISTS guest_reviews;
DROP TABLE IF EXISTS property_reviews;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS rates;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT,
  email TEXT,
  password TEXT
);

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  title TEXT,
  description TEXT,
  cost_per_night SMALLINT,
  parking_spaces SMALLINT,
  bathrooms SMALLINT,
  active BOOLEAN,
  images TEXT,
  owner_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE rates (
  id SERIAL PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  rate SMALLINT,
  property_id INT NOT NULL REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  property_id INT NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE property_reviews (
  id SERIAL PRIMARY KEY,
  message TEXT,
  rating SMALLINT,
  reservation_id INT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  property_id INT NOT NULL REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE guest_reviews (
  id SERIAL PRIMARY KEY,
  message TEXT,
  rating SMALLINT,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  owner_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reservation_id INT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE
);