-- =======================================================================
-- DROP TABLES IF EXISTS (RESET)
-- =======================================================================
DROP TABLE Booking CASCADE CONSTRAINTS;
DROP TABLE Flight CASCADE CONSTRAINTS;
DROP TABLE Agency CASCADE CONSTRAINTS;
DROP TABLE Passenger CASCADE CONSTRAINTS;

DROP TABLE Works CASCADE CONSTRAINTS;
DROP TABLE Project CASCADE CONSTRAINTS;
DROP TABLE Department CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;

-- =======================================================================
-- PART 1: TRAVEL AGENCY DATABASE (DDL & DML)
-- =======================================================================

CREATE TABLE Passenger (
    pid NUMBER PRIMARY KEY,
    pname VARCHAR2(100) NOT NULL,
    pgender VARCHAR2(10),
    pcity VARCHAR2(100)
);

CREATE TABLE Agency (
    aid NUMBER PRIMARY KEY,
    aname VARCHAR2(100) NOT NULL,
    acity VARCHAR2(100)
);

CREATE TABLE Flight (
    fid NUMBER PRIMARY KEY,
    fdate DATE NOT NULL,
    time VARCHAR2(10),
    src VARCHAR2(100),
    dest VARCHAR2(100)
);

CREATE TABLE Booking (
    pid NUMBER,
    aid NUMBER,
    fid NUMBER,
    fdate DATE,
    CONSTRAINT pk_booking PRIMARY KEY (pid, aid, fid),
    CONSTRAINT fk_book_pass FOREIGN KEY (pid) REFERENCES Passenger(pid),
    CONSTRAINT fk_book_agen FOREIGN KEY (aid) REFERENCES Agency(aid),
    CONSTRAINT fk_book_flig FOREIGN KEY (fid) REFERENCES Flight(fid)
);

-- Insert Passenger Data (Using 'Male' / 'Female' and English cities)
INSERT INTO Passenger VALUES (100, 'Cheolsu Kim', 'Male', 'Gangnam-gu, Seoul');
INSERT INTO Passenger VALUES (101, 'Younghee Lee', 'Female', 'Gangdong-gu, Seoul');
INSERT INTO Passenger VALUES (102, 'Minjun Park', 'Male', 'Dobong-gu, Seoul');
INSERT INTO Passenger VALUES (103, 'Suyeon Choi', 'Female', 'Mapo-gu, Seoul');
INSERT INTO Passenger VALUES (104, 'Hong Gil-dong', 'Male', 'Songpa-gu, Seoul');

-- Insert Agency Data
INSERT INTO Agency VALUES (1, 'Madang Travel Agency', 'Gangnam-gu, Seoul');
INSERT INTO Agency VALUES (2, 'Sky Travel Agency', 'Gangdong-gu, Seoul');
INSERT INTO Agency VALUES (3, 'Wind Travel Agency', 'Dobong-gu, Seoul');

-- Insert Flight Data (Using 'Gimpo', 'Jeju', 'Busan' in English)
INSERT INTO Flight VALUES (100, TO_DATE('2025-01-15', 'YYYY-MM-DD'), '09:00', 'Gimpo', 'Jeju');
INSERT INTO Flight VALUES (101, TO_DATE('2025-01-20', 'YYYY-MM-DD'), '11:00', 'Gimpo', 'Jeju');
INSERT INTO Flight VALUES (102, TO_DATE('2025-01-25', 'YYYY-MM-DD'), '14:00', 'Gimpo', 'Busan');
INSERT INTO Flight VALUES (103, TO_DATE('2024-12-31', 'YYYY-MM-DD'), '16:00', 'Gimpo', 'Jeju');
INSERT INTO Flight VALUES (104, TO_DATE('2025-02-01', 'YYYY-MM-DD'), '18:00', 'Busan', 'Jeju');

-- Insert Booking Data
INSERT INTO Booking VALUES (100, 1, 100, TO_DATE('2025-01-15', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (100, 2, 101, TO_DATE('2025-01-20', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (100, 1, 104, TO_DATE('2025-02-01', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (100, 3, 103, TO_DATE('2024-12-31', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (101, 1, 100, TO_DATE('2025-01-15', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (102, 2, 101, TO_DATE('2025-01-20', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (103, 3, 102, TO_DATE('2025-01-25', 'YYYY-MM-DD'));
INSERT INTO Booking VALUES (104, 1, 103, TO_DATE('2024-12-31', 'YYYY-MM-DD'));


-- =======================================================================
-- PART 2: COMPANY PROJECT DATABASE (DDL & DML)
-- =======================================================================

CREATE TABLE Employee (
    empno NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20),
    address VARCHAR2(200),
    sex VARCHAR2(10),
    position VARCHAR2(50),
    deptno NUMBER
);

CREATE TABLE Department (
    deptno NUMBER PRIMARY KEY,
    deptname VARCHAR2(100) NOT NULL,
    manager NUMBER
);

CREATE TABLE Project (
    projno NUMBER PRIMARY KEY,
    projname VARCHAR2(100) NOT NULL,
    deptno NUMBER REFERENCES Department(deptno)
);

CREATE TABLE Works (
    empno NUMBER REFERENCES Employee(empno),
    projno NUMBER REFERENCES Project(projno),
    hours NUMBER,
    CONSTRAINT pk_works PRIMARY KEY (empno, projno)
);

-- Insert Employee Data
INSERT INTO Employee VALUES (101, 'Kim', '010-1111-1111', 'Seoul', 'Male', 'Manager', 1);
INSERT INTO Employee VALUES (102, 'Lee', '010-2222-2222', 'Incheon', 'Female', 'Staff', 1);
INSERT INTO Employee VALUES (103, 'Park', '010-3232-3333', 'Seoul', 'Male', 'Manager', 2);
INSERT INTO Employee VALUES (104, 'Choi', '010-4444-4444', 'Busan', 'Female', 'Staff', 2);
INSERT INTO Employee VALUES (105, 'Jung', '010-5555-5555', 'Daegu', 'Male', 'Manager', 3);
INSERT INTO Employee VALUES (106, 'Han', '010-6666-6666', 'Seoul', 'Female', 'Staff', 1);

-- Insert Department Data
INSERT INTO Department VALUES (1, 'IT_Dept', 101);
INSERT INTO Department VALUES (2, 'HR_Dept', 103);
INSERT INTO Department VALUES (3, 'Sales_Dept', 105);

-- Add Foreign Key Constraint to Employee
ALTER TABLE Employee ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES Department(deptno);

-- Insert Project Data
INSERT INTO Project VALUES (1, 'Future', 1);
INSERT INTO Project VALUES (2, 'SmartCity', 2);
INSERT INTO Project VALUES (3, 'Digital', 1);

-- Insert Works Data
INSERT INTO Works VALUES (101, 1, 40);
INSERT INTO Works VALUES (102, 1, 35);
INSERT INTO Works VALUES (103, 2, 50);
INSERT INTO Works VALUES (104, 2, 30);
INSERT INTO Works VALUES (105, 3, 45);
INSERT INTO Works VALUES (106, 1, 20);
INSERT INTO Works VALUES (101, 3, 25);

COMMIT;


-- =======================================================================
-- PART 3: EXERCISE QUERIES
-- =======================================================================

-- 1. Passenger pid, pname, pcity
SELECT pid, pname, pcity FROM Passenger;

-- 2. Passenger pgender = 'Male'
SELECT pname, pcity FROM Passenger WHERE pgender = 'Male';

-- 3. Flight src = 'Gimpo'
SELECT fid, fdate, dest FROM Flight WHERE src = 'Gimpo';

-- 4. Booking count group by pid
SELECT pid, COUNT(*) AS booking_count FROM Booking GROUP BY pid;

-- 5. Agency all columns
SELECT aid, aname, acity FROM Agency;

-- 6. Flight count dest = 'Jeju'
SELECT COUNT(*) AS jeju_flight_count FROM Flight WHERE dest = 'Jeju';

-- 7. Booking fdate > '2025-01-01'
SELECT pid, aid, fid FROM Booking WHERE fdate > TO_DATE('2025-01-01', 'YYYY-MM-DD');

-- 8. Booking count group by aid desc
SELECT aid, COUNT(*) AS booking_count FROM Booking GROUP BY aid ORDER BY booking_count DESC;

-- 9. Flight latest fdate
SELECT fid, src, dest FROM Flight WHERE fdate = (SELECT MAX(fdate) FROM Flight);

-- 10. Passenger pcity in Gangnam or Gangdong
SELECT pname FROM Passenger WHERE pcity IN ('Gangnam-gu, Seoul', 'Gangdong-gu, Seoul');

-- 11. Join Passenger & Booking
SELECT p.pname, b.fid FROM Passenger p JOIN Booking b ON p.pid = b.pid;

-- 12. Join Agency & Booking
SELECT a.aname, COUNT(b.fid) AS booking_count FROM Agency a LEFT JOIN Booking b ON a.aid = b.aid GROUP BY a.aname;

-- 13. Join Passenger, Booking, Flight
SELECT p.pname, f.src, f.dest FROM Passenger p JOIN Booking b ON p.pid = b.pid JOIN Flight f ON b.fid = f.fid;

-- 14. Distinct Passenger & Agency Join
SELECT DISTINCT p.pname, a.aname FROM Passenger p JOIN Booking b ON p.pid = b.pid JOIN Agency a ON b.aid = a.aid;

-- 15. Passenger Left Join Booking (No Booking)
SELECT p.pname FROM Passenger p LEFT JOIN Booking b ON p.pid = b.pid WHERE b.pid IS NULL;

-- 16. Flight dest count for fdate >= 2025
SELECT f.dest, COUNT(b.fid) AS booking_count FROM Flight f JOIN Booking b ON f.fid = b.fid WHERE f.fdate >= TO_DATE('2025-01-01', 'YYYY-MM-DD') GROUP BY f.dest;

-- 17. Passenger booked for 'Jeju'
SELECT DISTINCT p.pname FROM Passenger p JOIN Booking b ON p.pid = b.pid JOIN Flight f ON b.fid = f.fid WHERE f.dest = 'Jeju';

-- 18. Passenger booked via 'Madang Travel Agency'
SELECT DISTINCT p.pname FROM Passenger p JOIN Booking b ON p.pid = b.pid JOIN Agency a ON b.aid = a.aid WHERE a.aname = 'Madang Travel Agency';

-- 19. Join 4 Tables for year 2025
SELECT p.pname, a.aname, f.src, f.dest FROM Passenger p JOIN Booking b ON p.pid = b.pid JOIN Flight f ON b.fid = f.fid JOIN Agency a ON b.aid = a.aid WHERE b.fdate BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-12-31', 'YYYY-MM-DD');

-- 20. Flight Left Join Booking (No Booking)
SELECT f.fid, f.src, f.dest FROM Flight f LEFT JOIN Booking b ON f.fid = b.fid WHERE b.fid IS NULL;

-- 21. Subquery IN (Passenger with Bookings)
SELECT pname FROM Passenger WHERE pid IN (SELECT pid FROM Booking);

-- 22. Subquery Passenger booked >= 2025
SELECT pname FROM Passenger WHERE pid IN (SELECT pid FROM Booking WHERE fdate >= TO_DATE('2025-01-01', 'YYYY-MM-DD'));

-- 23. Subquery Agency bookings >= 3
SELECT aname FROM Agency WHERE aid IN (SELECT aid FROM Booking GROUP BY aid HAVING COUNT(*) >= 3);

-- 24. Subquery NOT IN (Flight never booked)
SELECT fid, src, dest FROM Flight WHERE fid NOT IN (SELECT DISTINCT fid FROM Booking WHERE fid IS NOT NULL);

-- 25. Subquery Top booked Passenger
SELECT pname FROM Passenger WHERE pid = (SELECT pid FROM (SELECT pid FROM Booking GROUP BY pid ORDER BY COUNT(*) DESC) WHERE ROWNUM = 1);

-- 26. Subquery Passenger booked for 'Busan'
SELECT pname FROM Passenger WHERE pid IN (SELECT pid FROM Booking WHERE fid IN (SELECT fid FROM Flight WHERE dest = 'Busan'));

-- 27. Subquery NOT IN (Agency with no bookings)
SELECT aname FROM Agency WHERE aid NOT IN (SELECT DISTINCT aid FROM Booking WHERE aid IS NOT NULL);

-- 28. Subquery Passenger booked via aid = 1
SELECT pname FROM Passenger WHERE pid IN (SELECT pid FROM Booking WHERE aid = 1);

-- 29. Subquery Booking count > average booking count
SELECT pid FROM Booking GROUP BY pid HAVING COUNT(*) > (SELECT AVG(COUNT(*)) FROM Booking GROUP BY pid);

-- 30. Subquery Passenger booked in 2024
SELECT pname FROM Passenger WHERE pid IN (SELECT pid FROM Booking WHERE fdate BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') AND TO_DATE('2024-12-31', 'YYYY-MM-DD'));

-- 31. Correlated Subquery EXISTS (Passenger with Bookings)
SELECT DISTINCT p.pname FROM Passenger p WHERE EXISTS (SELECT 1 FROM Booking b WHERE b.pid = p.pid);

-- 32. Correlated Subquery Booking count >= 2
SELECT p.pname FROM Passenger p WHERE (SELECT COUNT(*) FROM Booking b WHERE b.pid = p.pid) >= 2;

-- 33. Correlated Subquery NOT EXISTS (Flight never booked)
SELECT f.fid FROM Flight f WHERE NOT EXISTS (SELECT 1 FROM Booking b WHERE b.fid = f.fid);

-- 34. Correlated Subquery EXISTS (Booked >= 2025)
SELECT p.pname FROM Passenger p WHERE EXISTS (SELECT 1 FROM Booking b WHERE b.pid = p.pid AND b.fdate >= TO_DATE('2025-01-01', 'YYYY-MM-DD'));

-- 35. Correlated Subquery distinct aid >= 2
SELECT p.pname FROM Passenger p WHERE (SELECT COUNT(DISTINCT b.aid) FROM Booking b WHERE b.pid = p.pid) >= 2;

-- 36. Correlated Subquery NOT EXISTS (Agency no bookings)
SELECT a.aname FROM Agency a WHERE NOT EXISTS (SELECT 1 FROM Booking b WHERE b.aid = a.aid);

-- 37. Correlated Subquery EXISTS (Booked for 'Jeju')
SELECT p.pname FROM Passenger p WHERE EXISTS (SELECT 1 FROM Booking b JOIN Flight f ON b.fid = f.fid WHERE b.pid = p.pid AND f.dest = 'Jeju');

-- 38. Correlated Subquery (Booked 2024 AND NOT Booked 2025)
SELECT p.pname FROM Passenger p WHERE EXISTS (SELECT 1 FROM Booking b1 WHERE b1.pid = p.pid AND b1.fdate BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') AND TO_DATE('2024-12-31', 'YYYY-MM-DD')) AND NOT EXISTS (SELECT 1 FROM Booking b2 WHERE b2.pid = p.pid AND b2.fdate >= TO_DATE('2025-01-01', 'YYYY-MM-DD'));

-- 39. Correlated Subquery Max booking per dest
SELECT f1.fid FROM Flight f1 WHERE (SELECT COUNT(*) FROM Booking b1 WHERE b1.fid = f1.fid) = (SELECT MAX(COUNT(*)) FROM Flight f2 JOIN Booking b2 ON f2.fid = b2.fid WHERE f2.dest = f1.dest GROUP BY f2.fid);

-- 40. Correlated Subquery (All bookings from 'Gimpo')
SELECT p.pname FROM Passenger p WHERE EXISTS (SELECT 1 FROM Booking WHERE pid = p.pid) AND NOT EXISTS (SELECT 1 FROM Booking b JOIN Flight f ON b.fid = f.fid WHERE b.pid = p.pid AND f.src <> 'Gimpo');


-- =======================================================================
-- PART 4: COMPANY PROJECT QUESTIONS
-- =======================================================================

-- 3) All Employee names
SELECT name FROM Employee;

-- 4) Female Employee names
SELECT name FROM Employee WHERE sex = 'Female';

-- 5) Department Manager Name and Address
SELECT e.name, e.address FROM Employee e JOIN Department d ON e.empno = d.manager;

-- 6) Employee Name and Address working in IT_Dept
SELECT e.name, e.address FROM Employee e JOIN Department d ON e.deptno = d.deptno WHERE d.deptname = 'IT_Dept';

-- 7) Employee Name working in Project 'Future'
SELECT DISTINCT e.name FROM Employee e JOIN Works w ON e.empno = w.empno JOIN Project p ON w.projno = p.projno WHERE p.projname = 'Future';

EXIT