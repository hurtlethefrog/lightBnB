DROP TABLE IF EXISTS guest_reviews CASCADE;
DROP TABLE IF EXISTS property_reviews CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS rates CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP TABLE IF EXISTS users CASCADE;

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
  cost_per_night INTEGER,
  parking_spaces INTEGER,
  number_of_bathrooms INTEGER,
  number_of_bedrooms INTEGER,
  active BOOLEAN,
  provence TEXT,
  post_code TEXT,
  street TEXT,
  country TEXT,
  city TEXT,
  thumbnail_photo_url TEXT,
  cover_photo_url TEXT,
  owner_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE rates (
  id SERIAL PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  rate INTEGER,
  property_id INT NOT NULL REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  property_id INT NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  guest_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE property_reviews (
  id SERIAL PRIMARY KEY,
  message TEXT,
  rating INTEGER,
  reservation_id INT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
  guest_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  property_id INT NOT NULL REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE guest_reviews (
  id SERIAL PRIMARY KEY,
  message TEXT,
  rating INTEGER,
  guest_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  owner_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reservation_id INT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE
);