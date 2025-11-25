INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    VALUES (9, 'Spa', 20, 30, 100000, 800)
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    SELECT (SELECT max(facid) FROM cd.facilities) + 1, 'Spa', 20, 30, 100000, 800;
UPDATE cd.facilities
    SET initialoutlay = 10000
    WHERE facid = 1;
UPDATE cd.facilities
    SET membercost = (
            SELECT membercost * 1.1
                FROM cd.facilities
                WHERE facid = 0),
        guestcost = (
            SELECT guestcost * 1.1
                FROM cd.facilities
                WHERE facid = 0)
    WHERE facid = 1;
DELETE
    FROM cd.bookings;
DELETE
    FROM cd.members
    WHERE memid = 37;
SELECT facid, name, membercost, monthlymaintenance
    FROM cd.facilities
    WHERE membercost > 0 AND membercost < 0.02 * monthlymaintenance;
SELECT *
    FROM   cd.facilities
    WHERE  name LIKE '%Tennis%';
SELECT *
    FROM cd.facilities
    WHERE facid IN (1,5);
SELECT memid, surname, firstname, joindate
    FROM cd.members
    WHERE joindate >= '2012-09-01';
SELECT surname
    FROM cd.members
UNION
SELECT name
    FROM cd.facilities;
SELECT starttime
    FROM cd.bookings
        INNER JOIN cd.members ON cd.members.memid = cd.bookings.memid
    WHERE firstname = 'David' AND
    surname = 'Farrell';
SELECT book.starttime AS start, fac.name AS name
    FROM cd.facilities fac
        INNER JOIN cd.bookings book ON fac.facid = book.facid
    WHERE fac.name LIKE 'Tennis Court%' AND book.starttime >= '2012-09-21' AND book.starttime < '2012-09-22'
    ORDER BY book.starttime;
SELECT mem.firstname AS memfname, mem.surname AS memsname, rec.firstname AS recfname, rec.surname AS recsname
    FROM cd.members mem
        LEFT OUTER JOIN cd.members rec ON rec.memid = mem.recommendedby
    ORDER BY memsname, memfname;
SELECT DISTINCT rec.firstname AS firstname, rec.surname AS surname
    FROM cd.members mem
        INNER JOIN cd.members rec ON rec.memid = mem.recommendedby
    ORDER BY surname, firstname;
SELECT DISTINCT mem.firstname || ' ' || mem.surname AS member, (
    SELECT rec.firstname || ' ' || rec.surname AS recommender
        FROM cd.members rec
        WHERE rec.memid = mem.recommendedby)
    FROM cd.members mem
    ORDER BY member;
SELECT recommendedby, count(*)
    FROM cd.members
    WHERE recommendedby IS NOT NULL
    GROUP BY recommendedby
    ORDER BY recommendedby;
SELECT facid, sum(slots) AS "Total Slots"
    FROM cd.bookings
    GROUP BY facid
    ORDER BY facid;
SELECT facid, sum(slots) AS "Total Slots"
    FROM cd.bookings
    WHERE starttime starttime >= '2012-09-01' AND starttime < '2012-10-01'
    GROUP BY facid
    ORDER BY facid;
SELECT facid, extract(month FROM starttime) AS month, sum(slots) AS "Total Slots"
    FROM cd.bookings
    WHERE extract(year FROM starttime) = 2012
    GROUP BY facid, month
    ORDER BY facid;
SELECT COUNT(DISTINCT book.memid) AS "count"
    FROM cd.members mem LEFT OUTER JOIN cd.bookings book ON mem.memid = book.memid;
SELECT  mem.surname, mem.firstname, mem.memid, min(book.starttime) AS starttime
    FROM cd.bookings book INNER JOIN cd.members mem ON mem.memid = book.memid
    WHERE starttime >= '2012-09-01'
    GROUP BY mem.surname, mem.firstname, mem.memid
    ORDER BY memid;
SELECT COUNT(*) OVER(), firstname, surname
    FROM cd.members
    ORDER BY joindate;
SELECT row_number() OVER (ORDER BY joindate), firstname, surname
    FROM cd.members
    ORDER BY joindate;
SELECT facid, total
    FROM (
        SELECT facid, sum(slots) total, rank() OVER (ORDER BY sum(slots) DESC) rank
            FROM cd.bookings
            GROUP BY facid
        ) AS ranked
    WHERE rank = 1
SELECT surname || ', ' || firstname AS name
    FROM cd.members;
SELECT memid, telephone
    FROM cd.members
    WHERE telephone ~ '[()]';
SELECT substr(mems.surname, 1, 1) AS letter, count(*) AS count
    FROM cd.members mems
    GROUP BY letter