-- Write your SQL query below:
DROP TABLE IF EXISTS flight_crew CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS crew_certifications CASCADE;
DROP TABLE IF EXISTS crew CASCADE;
DROP TABLE IF EXISTS airports CASCADE;
DROP TABLE IF EXISTS aircraft CASCADE;

-- ============================================================
-- SCHEMA CREATION
-- ============================================================

CREATE TABLE aircraft (
    aircraft_id BIGSERIAL PRIMARY KEY,
    tail_number VARCHAR(10) UNIQUE NOT NULL,
    aircraft_type VARCHAR(10) NOT NULL,
    seats INTEGER NOT NULL CHECK (seats > 0)
);

CREATE TABLE airports (
    airport_code CHAR(3) PRIMARY KEY,
    airport_name VARCHAR(80) NOT NULL,
    city VARCHAR(60) NOT NULL,
    state CHAR(2) NOT NULL
);

CREATE TABLE crew (
    crew_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL,
    base_airport CHAR(3) NOT NULL,
    hire_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_crew_base_airport
        FOREIGN KEY (base_airport) REFERENCES airports(airport_code)
);

CREATE TABLE crew_certifications (
    cert_id BIGSERIAL PRIMARY KEY,
    crew_id BIGINT NOT NULL,
    aircraft_type VARCHAR(10) NOT NULL,
    cert_level VARCHAR(30) NOT NULL,
    expiration_date DATE NOT NULL,
    CONSTRAINT fk_cert_crew
        FOREIGN KEY (crew_id) REFERENCES crew(crew_id),
    CONSTRAINT uq_crew_aircraft_cert
        UNIQUE (crew_id, aircraft_type)
);

CREATE TABLE flights (
    flight_id BIGSERIAL PRIMARY KEY,
    flight_number VARCHAR(10) UNIQUE NOT NULL,
    origin CHAR(3) NOT NULL,
    destination CHAR(3) NOT NULL,
    departure_time TIMESTAMPTZ NOT NULL,
    arrival_time TIMESTAMPTZ NOT NULL,
    aircraft_id BIGINT NOT NULL,
    flight_status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT fk_origin_airport
        FOREIGN KEY (origin) REFERENCES airports(airport_code),
    CONSTRAINT fk_destination_airport
        FOREIGN KEY (destination) REFERENCES airports(airport_code),
    CONSTRAINT fk_flight_aircraft
        FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    CONSTRAINT chk_different_airports
        CHECK (origin <> destination),
    CONSTRAINT chk_arrival_after_departure
        CHECK (arrival_time > departure_time)
);

CREATE TABLE passengers (
    passenger_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    flight_id BIGINT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    special_request VARCHAR(100),
    booking_status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT fk_passenger_flight
        FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    CONSTRAINT uq_flight_seat
        UNIQUE (flight_id, seat_number)
);

CREATE TABLE flight_crew (
    assignment_id BIGSERIAL PRIMARY KEY,
    flight_id BIGINT NOT NULL,
    crew_id BIGINT NOT NULL,
    duty_start TIMESTAMPTZ NOT NULL,
    duty_end TIMESTAMPTZ NOT NULL,
    position VARCHAR(20) NOT NULL,
    CONSTRAINT fk_assignment_flight
        FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    CONSTRAINT fk_assignment_crew
        FOREIGN KEY (crew_id) REFERENCES crew(crew_id),
    CONSTRAINT chk_duty_end_after_start
        CHECK (duty_end > duty_start)
);

-- ============================================================
-- SAMPLE DATA INSERTION
-- ============================================================

INSERT INTO aircraft (tail_number, aircraft_type, seats)
VALUES
('N101EA', 'A320', 150),
('N102EA', 'A320', 150),
('N103EA', 'A320', 150),
('N201EA', 'E175', 76),
('N202EA', 'E175', 76),
('N203EA', 'E175', 76),
('N301EA', 'B737', 160),
('N302EA', 'B737', 160);

INSERT INTO airports (airport_code, airport_name, city, state)
VALUES
('ATL', 'Hartsfield-Jackson Atlanta International', 'Atlanta', 'GA'),
('BOS', 'Logan International', 'Boston', 'MA'),
('DCA', 'Ronald Reagan Washington National', 'Washington', 'DC'),
('DFW', 'Dallas/Fort Worth International', 'Dallas-Fort Worth', 'TX'),
('EWR', 'Newark Liberty International', 'Newark', 'NJ'),
('JFK', 'John F. Kennedy International', 'New York', 'NY'),
('LGA', 'LaGuardia Airport', 'New York', 'NY'),
('MCO', 'Orlando International', 'Orlando', 'FL'),
('MIA', 'Miami International', 'Miami', 'FL'),
('ORD', 'O''Hare International', 'Chicago', 'IL');

INSERT INTO crew (first_name, last_name, role, base_airport, hire_date, status)
VALUES
('Ava', 'Johnson', 'Captain', 'JFK', '2017-04-10', 'Active'),
('Liam', 'Martinez', 'Captain', 'ATL', '2016-09-21', 'Active'),
('Sophia', 'Nguyen', 'Captain', 'ORD', '2015-02-03', 'Active'),
('Mason', 'Clark', 'Captain', 'JFK', '2018-11-15', 'Active'),
('Isabella', 'Davis', 'Captain', 'ATL', '2014-06-30', 'Active'),
('Ethan', 'Walker', 'Captain', 'ORD', '2013-08-19', 'Active'),
('Amelia', 'Lopez', 'Captain', 'JFK', '2019-03-22', 'Active'),
('Noah', 'King', 'Captain', 'ATL', '2012-12-05', 'Active'),
('Olivia', 'Harris', 'FirstOfficer', 'JFK', '2020-01-13', 'Active'),
('James', 'Young', 'FirstOfficer', 'ATL', '2021-05-02', 'Active'),
('Mia', 'Allen', 'FirstOfficer', 'ORD', '2020-09-17', 'Active'),
('Benjamin', 'Scott', 'FirstOfficer', 'JFK', '2019-10-29', 'Active'),
('Charlotte', 'Baker', 'FirstOfficer', 'ATL', '2022-02-14', 'Active'),
('Lucas', 'Gonzalez', 'FirstOfficer', 'ORD', '2021-07-08', 'Active'),
('Harper', 'Perez', 'FirstOfficer', 'JFK', '2022-11-01', 'Active'),
('Henry', 'Rivera', 'FirstOfficer', 'ATL', '2023-03-20', 'Active'),
('Ella', 'Price', 'FlightAttendant', 'JFK', '2021-06-01', 'Active'),
('Jack', 'Reed', 'FlightAttendant', 'ATL', '2020-04-19', 'Active'),
('Grace', 'Cook', 'FlightAttendant', 'ORD', '2022-08-07', 'Active'),
('Leo', 'Morgan', 'FlightAttendant', 'JFK', '2023-01-11', 'Active'),
('Chloe', 'Bell', 'FlightAttendant', 'ATL', '2021-09-23', 'Active'),
('Daniel', 'Murphy', 'FlightAttendant', 'ORD', '2019-05-16', 'Active'),
('Zoe', 'Bailey', 'FlightAttendant', 'JFK', '2022-12-09', 'Active'),
('Ryan', 'Cooper', 'FlightAttendant', 'ATL', '2020-10-04', 'Active');

INSERT INTO crew_certifications (crew_id, aircraft_type, cert_level, expiration_date)
VALUES
(1, 'A320', 'Type Rated', '2028-02-23'),
(2, 'A320', 'Type Rated', '2029-02-22'),
(3, 'A320', 'Type Rated', '2027-02-23'),
(4, 'A320', 'Type Rated', '2028-02-23'),
(5, 'A320', 'Type Rated', '2029-02-22'),
(6, 'A320', 'Type Rated', '2027-02-23'),
(7, 'A320', 'Type Rated', '2028-02-23'),
(8, 'A320', 'Type Rated', '2029-02-22'),
(9, 'A320', 'Type Rated', '2027-02-23'),
(10, 'A320', 'Type Rated', '2028-02-23'),
(11, 'A320', 'Type Rated', '2029-02-22'),
(12, 'A320', 'Type Rated', '2027-02-23'),
(13, 'A320', 'Type Rated', '2028-02-23'),
(14, 'A320', 'Type Rated', '2029-02-22'),
(15, 'A320', 'Type Rated', '2027-02-23'),
(16, 'A320', 'Type Rated', '2028-02-23'),
(1, 'E175', 'Type Rated', '2028-02-23'),
(2, 'E175', 'Type Rated', '2029-02-22'),
(3, 'E175', 'Type Rated', '2027-02-23'),
(4, 'E175', 'Type Rated', '2028-02-23'),
(5, 'E175', 'Type Rated', '2029-02-22'),
(6, 'E175', 'Type Rated', '2027-02-23'),
(7, 'E175', 'Type Rated', '2028-02-23'),
(8, 'E175', 'Type Rated', '2029-02-22');

INSERT INTO flights (flight_number, origin, destination, departure_time, arrival_time, aircraft_id, flight_status)
VALUES
('EA101', 'ATL', 'DCA', '2026-03-10 07:30:00-04', '2026-03-10 09:55:00-04', 1, 'Scheduled'),
('EA102', 'ATL', 'EWR', '2026-03-10 11:15:00-04', '2026-03-10 13:40:00-04', 2, 'Scheduled'),
('EA103', 'ATL', 'JFK', '2026-03-10 15:05:00-04', '2026-03-10 17:30:00-04', 3, 'Scheduled'),
('EA104', 'ATL', 'MIA', '2026-03-10 19:20:00-04', '2026-03-10 21:10:00-04', 4, 'Scheduled'),
('EA105', 'BOS', 'DCA', '2026-03-11 07:30:00-04', '2026-03-11 09:40:00-04', 5, 'Scheduled'),
('EA106', 'DCA', 'ATL', '2026-03-11 11:15:00-04', '2026-03-11 13:40:00-04', 6, 'Scheduled'),
('EA107', 'DCA', 'BOS', '2026-03-11 15:05:00-04', '2026-03-11 17:30:00-04', 7, 'Scheduled'),
('EA108', 'DFW', 'ORD', '2026-03-11 19:20:00-04', '2026-03-11 22:15:00-04', 8, 'Scheduled'),
('EA109', 'EWR', 'ATL', '2026-03-12 07:30:00-04', '2026-03-12 09:40:00-04', 1, 'Scheduled'),
('EA110', 'JFK', 'ATL', '2026-03-12 11:15:00-04', '2026-03-12 13:25:00-04', 2, 'Scheduled'),
('EA111', 'JFK', 'ORD', '2026-03-12 15:05:00-04', '2026-03-12 18:00:00-04', 3, 'Scheduled'),
('EA112', 'LGA', 'MCO', '2026-03-12 19:20:00-04', '2026-03-12 21:45:00-04', 4, 'Scheduled'),
('EA113', 'MCO', 'LGA', '2026-03-13 07:30:00-04', '2026-03-13 09:55:00-04', 5, 'Scheduled'),
('EA114', 'MIA', 'ATL', '2026-03-13 11:15:00-04', '2026-03-13 13:40:00-04', 6, 'Scheduled'),
('EA115', 'ORD', 'DFW', '2026-03-13 15:05:00-04', '2026-03-13 18:00:00-04', 7, 'Scheduled'),
('EA116', 'ORD', 'JFK', '2026-03-13 19:20:00-04', '2026-03-13 22:15:00-04', 8, 'Scheduled'),
('EA117', 'ATL', 'DCA', '2026-03-14 07:30:00-04', '2026-03-14 09:55:00-04', 1, 'Delayed'),
('EA118', 'ATL', 'EWR', '2026-03-14 11:15:00-04', '2026-03-14 13:40:00-04', 2, 'Scheduled'),
('EA119', 'ATL', 'JFK', '2026-03-14 15:05:00-04', '2026-03-14 17:30:00-04', 3, 'Scheduled'),
('EA120', 'ATL', 'MIA', '2026-03-14 19:20:00-04', '2026-03-14 21:10:00-04', 4, 'Scheduled'),
('EA121', 'BOS', 'DCA', '2026-03-15 07:30:00-04', '2026-03-15 09:40:00-04', 5, 'Scheduled'),
('EA122', 'DCA', 'ATL', '2026-03-15 11:15:00-04', '2026-03-15 13:40:00-04', 6, 'Scheduled'),
('EA123', 'DCA', 'BOS', '2026-03-15 15:05:00-04', '2026-03-15 17:30:00-04', 7, 'Scheduled'),
('EA124', 'DFW', 'ORD', '2026-03-15 19:20:00-04', '2026-03-15 22:15:00-04', 8, 'Scheduled'),
('EA125', 'EWR', 'ATL', '2026-03-16 07:30:00-04', '2026-03-16 09:40:00-04', 1, 'Scheduled');

INSERT INTO flight_crew (flight_id, crew_id, duty_start, duty_end, position)
VALUES
(1, 1, '2026-03-10 06:15:00-04', '2026-03-10 10:25:00-04', 'Captain'),
(2, 2, '2026-03-10 10:00:00-04', '2026-03-10 14:10:00-04', 'Captain'),
(3, 3, '2026-03-10 13:50:00-04', '2026-03-10 18:15:00-04', 'Captain'),
(4, 4, '2026-03-10 18:05:00-04', '2026-03-10 21:55:00-04', 'Captain'),
(5, 5, '2026-03-11 06:15:00-04', '2026-03-11 10:25:00-04', 'Captain'),
(6, 6, '2026-03-11 10:00:00-04', '2026-03-11 14:25:00-04', 'Captain'),
(7, 7, '2026-03-11 13:50:00-04', '2026-03-11 18:15:00-04', 'Captain'),
(8, 8, '2026-03-11 18:05:00-04', '2026-03-11 23:00:00-04', 'Captain'),
(9, 1, '2026-03-12 06:15:00-04', '2026-03-12 10:25:00-04', 'Captain'),
(10, 2, '2026-03-12 10:00:00-04', '2026-03-12 14:10:00-04', 'Captain'),
(11, 3, '2026-03-12 13:50:00-04', '2026-03-12 18:45:00-04', 'Captain'),
(12, 4, '2026-03-12 18:05:00-04', '2026-03-12 22:30:00-04', 'Captain'),
(13, 5, '2026-03-13 06:15:00-04', '2026-03-13 10:40:00-04', 'Captain'),
(14, 6, '2026-03-13 10:00:00-04', '2026-03-13 14:25:00-04', 'Captain'),
(15, 7, '2026-03-13 13:50:00-04', '2026-03-13 18:45:00-04', 'Captain'),
(16, 8, '2026-03-13 18:05:00-04', '2026-03-13 23:00:00-04', 'Captain'),
(17, 1, '2026-03-14 06:15:00-04', '2026-03-14 10:40:00-04', 'Captain'),
(18, 2, '2026-03-14 10:00:00-04', '2026-03-14 14:25:00-04', 'Captain'),
(19, 3, '2026-03-14 13:50:00-04', '2026-03-14 18:15:00-04', 'Captain'),
(20, 4, '2026-03-14 18:05:00-04', '2026-03-14 21:55:00-04', 'Captain'),
(21, 5, '2026-03-15 06:15:00-04', '2026-03-15 10:25:00-04', 'Captain'),
(22, 6, '2026-03-15 10:00:00-04', '2026-03-15 14:25:00-04', 'Captain'),
(23, 7, '2026-03-15 13:50:00-04', '2026-03-15 18:15:00-04', 'Captain'),
(24, 8, '2026-03-15 18:05:00-04', '2026-03-15 23:00:00-04', 'Captain'),
(25, 1, '2026-03-16 06:15:00-04', '2026-03-16 10:25:00-04', 'Captain');

INSERT INTO passengers (first_name, last_name, flight_id, seat_number, special_request, booking_status)
VALUES
('Michael', 'Johnson', 1, '12A', 'Window seat', 'Confirmed'),
('Ashley', 'Davis', 1, '14C', 'Vegetarian meal', 'Confirmed'),
('Chris', 'Martin', 2, '7B', NULL, 'Confirmed'),
('Jasmine', 'Taylor', 3, '21D', 'Extra legroom', 'Confirmed'),
('Kayla', 'Moore', 4, '9A', NULL, 'Confirmed'),
('Robert', 'Smith', 5, '10C', 'Aisle seat', 'Confirmed'),
('Emily', 'Brown', 6, '3F', NULL, 'Confirmed'),
('Anthony', 'Wilson', 7, '18B', NULL, 'Confirmed'),
('Brianna', 'Thomas', 8, '22A', 'Wheelchair assistance', 'Confirmed'),
('Jordan', 'Lee', 9, '11D', NULL, 'Confirmed'),
('Taylor', 'White', 10, '15A', 'Window seat', 'Confirmed'),
('Morgan', 'Hall', 11, '16B', NULL, 'Confirmed'),
('Avery', 'Adams', 12, '20C', NULL, 'Confirmed'),
('Cameron', 'Nelson', 13, '4A', NULL, 'Confirmed'),
('Riley', 'Hill', 14, '8D', 'Vegetarian meal', 'Confirmed'),
('Peyton', 'Green', 15, '6C', NULL, 'Confirmed'),
('Casey', 'Bennett', 16, '19A', NULL, 'Confirmed'),
('Jamie', 'Roberts', 17, '13B', 'Aisle seat', 'Confirmed');

-- ============================================================
-- SQL QUERIES FOR FINAL REPORT / PRESENTATION
-- ============================================================

-- Query 1: View all tables
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- Query 2: Complete flight schedule with airport and aircraft details
SELECT
    f.flight_number,
    f.origin,
    origin_airport.city AS origin_city,
    f.destination,
    destination_airport.city AS destination_city,
    f.departure_time,
    f.arrival_time,
    a.tail_number,
    a.aircraft_type,
    a.seats,
    f.flight_status
FROM flights f
JOIN airports origin_airport
    ON f.origin = origin_airport.airport_code
JOIN airports destination_airport
    ON f.destination = destination_airport.airport_code
JOIN aircraft a
    ON f.aircraft_id = a.aircraft_id
ORDER BY f.departure_time;

-- Query 3: Delayed flights report
SELECT
    flight_number,
    origin,
    destination,
    departure_time,
    arrival_time,
    flight_status
FROM flights
WHERE flight_status = 'Delayed';

-- Query 4: Passenger count per flight
SELECT
    f.flight_number,
    f.origin,
    f.destination,
    COUNT(p.passenger_id) AS total_passengers
FROM flights f
LEFT JOIN passengers p
    ON f.flight_id = p.flight_id
GROUP BY f.flight_number, f.origin, f.destination
ORDER BY total_passengers DESC, f.flight_number;

-- Query 5: Aircraft utilization by tail number
SELECT
    a.tail_number,
    a.aircraft_type,
    COUNT(f.flight_id) AS total_flights
FROM aircraft a
LEFT JOIN flights f
    ON a.aircraft_id = f.aircraft_id
GROUP BY a.tail_number, a.aircraft_type
ORDER BY total_flights DESC;

-- Query 6: Crew assignment schedule
SELECT
    f.flight_number,
    c.first_name || ' ' || c.last_name AS crew_member,
    c.role AS crew_role,
    fc.position,
    fc.duty_start,
    fc.duty_end
FROM flight_crew fc
JOIN flights f
    ON fc.flight_id = f.flight_id
JOIN crew c
    ON fc.crew_id = c.crew_id
ORDER BY fc.duty_start;

-- Query 7: Crew certification report
SELECT
    c.first_name || ' ' || c.last_name AS crew_member,
    c.role,
    cc.aircraft_type,
    cc.cert_level,
    cc.expiration_date
FROM crew_certifications cc
JOIN crew c
    ON cc.crew_id = c.crew_id
ORDER BY cc.expiration_date;

-- Query 8: Crew certified for aircraft type assigned to their flight
SELECT
    f.flight_number,
    a.aircraft_type,
    c.first_name || ' ' || c.last_name AS crew_member,
    fc.position,
    cc.cert_level,
    cc.expiration_date
FROM flight_crew fc
JOIN flights f
    ON fc.flight_id = f.flight_id
JOIN aircraft a
    ON f.aircraft_id = a.aircraft_id
JOIN crew c
    ON fc.crew_id = c.crew_id
JOIN crew_certifications cc
    ON cc.crew_id = c.crew_id
   AND cc.aircraft_type = a.aircraft_type
ORDER BY f.flight_number;

-- Query 9: Flights using aircraft with above-average seat capacity
SELECT
    f.flight_number,
    a.tail_number,
    a.aircraft_type,
    a.seats
FROM flights f
JOIN aircraft a
    ON f.aircraft_id = a.aircraft_id
WHERE a.seats > (
    SELECT AVG(seats)
    FROM aircraft
)
ORDER BY a.seats DESC;

-- Query 10: INSERT example - add a new passenger
INSERT INTO passengers (first_name, last_name, flight_id, seat_number, special_request, booking_status)
VALUES ('Demo', 'Passenger', 1, '1A', 'Aisle seat', 'Confirmed');

-- Query 11: UPDATE example - update the demo passenger seat
UPDATE passengers
SET seat_number = '1B'
WHERE first_name = 'Demo'
  AND last_name = 'Passenger'
  AND flight_id = 1;

-- Query 12: DELETE example - remove demo passenger
DELETE FROM passengers
WHERE first_name = 'Demo'
  AND last_name = 'Passenger'
  AND flight_id = 1;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
