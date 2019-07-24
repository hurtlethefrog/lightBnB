DELETE FROM guest_reviews;
DELETE FROM property_reviews;
DELETE FROM reservations;
DELETE FROM rates;
DELETE FROM properties;
DELETE FROM users;

ALTER SEQUENCE users RESTART WITH 1;
ALTER SEQUENCE properties RESTART WITH 1;
ALTER SEQUENCE rates RESTART WITH 1;
ALTER SEQUENCE reservations RESTART WITH 1;
ALTER SEQUENCE property_reviews RESTART WITH 1;
ALTER SEQUENCE guest_reviews RESTART WITH 1;

INSERT INTO users (name, email, password)
VALUES ('duncan haran', 'example@email.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u'),
('james', 'example2@email.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u');

INSERT INTO properties (title, description, cost_per_night, parking_spaces, bathrooms, images, owner_id)
VALUES ('big house', 'what a nice house', 1000, 3, 2, 'aURl with images', 1);

INSERT INTO rates (start_date, end_date, rate, property_id)
VALUES (now(), '2020-01-01', 5, 1);

INSERT INTO reservations (start_date, end_date, property_id, user_id)
VALUES ('2020-05-01', '2021-01-01', 1, 2);

INSERT INTO property_reviews (message, rating, reservation_id, property_id, user_id)
VALUES ('this place stinks', 1, 1, 1, 2);

INSERT INTO guest_reviews (message, rating, user_id, owner_id, reservation_id)
VALUES ('this guy stank up my place', 5, 2, 1, 1);