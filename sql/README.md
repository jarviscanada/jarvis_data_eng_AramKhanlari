# Introduction
This project is a practical exploration of SQL and relational database concepts using a country-club database containing members, facilities, and bookings. 

The database is built with PostgreSQL and Docker, and the exercises cover a full range of SQL operations, including inserts, updates, deletes, filtering, JOINs, aggregations, and window functions. 

The goal is to understand how structured data is modeled and queried in a real environment, while maintaining clean, readable, and well-organized SQL.

# SQL Queries
###### Table Setup (DDL)
```sql
CREATE SCHEMA cd;

CREATE TABLE cd.members (
    memid SERIAL PRIMARY KEY,
    surname VARCHAR(200) NOT NULL,
    firstname VARCHAR(200) NOT NULL,
    address VARCHAR(300),
    zipcode INTEGER,
    telephone VARCHAR(20),
    recommendedby INTEGER,
    joindate TIMESTAMP
);

CREATE TABLE cd.bookings (
    bookid SERIAL PRIMARY KEY,
    facid INTEGER NOT NULL,
    memid INTEGER NOT NULL,
    starttime TIMESTAMP NOT NULL,
    slots INTEGER NOT NULL,
    FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
    FOREIGN KEY (memid) REFERENCES cd.members(memid)
);

CREATE TABLE cd.facilities (
    facid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    membercost NUMERIC NOT NULL,
    guestcost NUMERIC NOT NULL,
    initialoutlay NUMERIC NOT NULL,
    monthlymaintenance NUMERIC NOT NULL
);
```
##### Modifying Data
###### Question 1: Show all members
The club is adding a new facility - a spa. We need to add it into the facilities table.
Use the following values:

facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    VALUES (9, 'Spa', 20, 30, 100000, 800)
```

###### Question 2:  Insert calculated data into a table

Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:

Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    SELECT (SELECT max(facid) FROM cd.facilities) + 1, 'Spa', 20, 30, 100000, 800;
```
###### Question 3:  Update some existing data
We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
```sql
UPDATE cd.facilities
    SET initialoutlay = 10000
    WHERE facid = 1;
```
###### Question 4:  Update a row based on the contents of another row
We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
```sql
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
```
###### Question 5:  Delete all bookings
As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?
```sql
DELETE
    FROM cd.bookings;
```

###### Question 6:  Delete a member from the cd.members table
We want to remove member 37, who has never made a booking, from our database. How can we achieve that?
```sql
DELETE
    FROM cd.members
    WHERE memid = 37;
```
##### Basic Operations on Data
###### Question 7:  Control which rows are retrieved
How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.

```sql
SELECT facid, name, membercost, monthlymaintenance
    FROM cd.facilities  
    WHERE membercost > 0 AND membercost < 0.02 * monthlymaintenance;
```

###### Question 8:  Basic string searches
How can you produce a list of all facilities with the word 'Tennis' in their name?
```sql
SELECT *
    FROM   cd.facilities
    WHERE  name LIKE '%Tennis%'; 
```

###### Question 9:  Matching against multiple possible values
How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

```sql
SELECT *
    FROM cd.facilities
    WHERE facid IN (1,5);
```
###### Question 10:  Working with dates
How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question
```sql
SELECT memid, surname, firstname, joindate
    FROM cd.members
    WHERE joindate >= '2012-09-01';
```


###### Question 11:  Combining results from multiple queries
You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list!

```sql
SELECT surname
    FROM cd.members 
UNION 
SELECT name 
    FROM cd.facilities;
```
#####  Joining Data
###### Question 12:  Retrieve the start times of members' bookings
How can you produce a list of the start times for bookings by members named 'David Farrell'?
```sql
SELECT starttime
    FROM cd.bookings 
        INNER JOIN cd.members ON cd.members.memid = cd.bookings.memid
    WHERE firstname = 'David' AND 
    surname = 'Farrell';
```

###### Question 13:  Work out the start times of bookings for tennis courts
How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

```sql
SELECT book.starttime AS start, fac.name AS name
    FROM cd.facilities fac
        INNER JOIN cd.bookings book ON fac.facid = book.facid
    WHERE fac.name LIKE 'Tennis Court%' AND book.starttime >= '2012-09-21' AND book.starttime < '2012-09-22'
    ORDER BY book.starttime;
```

###### Question 14:  Produce a list of all members, along with their recommender
How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

```sql
SELECT mem.firstname AS memfname, mem.surname AS memsname, rec.firstname AS recfname, rec.surname AS recsname
    FROM cd.members mem
        LEFT OUTER JOIN cd.members rec ON rec.memid = mem.recommendedby
    ORDER BY memsname, memfname;
```

###### Question 15:  Produce a list of all members who have recommended another member
How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

```sql
SELECT DISTINCT rec.firstname AS firstname, rec.surname AS surname
    FROM cd.members mem
        INNER JOIN cd.members rec ON rec.memid = mem.recommendedby
    ORDER BY surname, firstname;
```

###### Question 16:  Produce a list of all members, along with their recommender, using no joins.
How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.

```sql
SELECT DISTINCT mem.firstname || ' ' || mem.surname AS member, (
    SELECT rec.firstname || ' ' || rec.surname AS recommender
        FROM cd.members rec
        WHERE rec.memid = mem.recommendedby)
    FROM cd.members mem
    ORDER BY member;
```

##### Aggregation of Data
###### Question 17:  Count the number of recommendations each member makes.
Produce a count of the number of recommendations each member has made. Order by member ID.

```sql
SELECT recommendedby, count(*)
    FROM cd.members
    WHERE recommendedby IS NOT NULL
    GROUP BY recommendedby
    ORDER BY recommendedby;
```

###### Question 18:  List the total slots booked per facility
Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.

```sql
SELECT facid, sum(slots) AS "Total Slots"
    FROM cd.bookings
    GROUP BY facid
    ORDER BY facid;
```

###### Question 19:  List the total slots booked per facility in a given month
Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

```sql
SELECT facid, sum(slots) AS "Total Slots"
    FROM cd.bookings
    WHERE starttime starttime >= '2012-09-01' AND starttime < '2012-10-01'
    GROUP BY facid
    ORDER BY facid;
```

###### Question 20:   List the total slots booked per facility per month
Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
```sql
SELECT facid, extract(month FROM starttime) AS month, sum(slots) AS "Total Slots"
    FROM cd.bookings
    WHERE extract(year FROM starttime) = 2012
    GROUP BY facid, month
    ORDER BY facid;
```
###### Question 21: Find the count of members who have made at least one booking
Find the total number of members (including guests) who have made at least one booking.

```sql
SELECT COUNT(DISTINCT book.memid) AS "count"
    FROM cd.members mem LEFT OUTER JOIN cd.bookings book ON mem.memid = book.memid;
```
###### Question 22: List each member's first booking after September 1st 2012
Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.

```sql
SELECT  mem.surname, mem.firstname, mem.memid, min(book.starttime) AS starttime
    FROM cd.bookings book INNER JOIN cd.members mem ON mem.memid = book.memid
    WHERE starttime >= '2012-09-01'
    GROUP BY mem.surname, mem.firstname, mem.memid
    ORDER BY memid;
```
###### Question 23: Produce a list of member names, with each row containing the total member count
Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.

```sql
SELECT COUNT(*) OVER(), firstname, surname 
    FROM cd.members
    ORDER BY joindate;
```
###### Question 24: Produce a numbered list of members
Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.

```sql
SELECT row_number() OVER (ORDER BY joindate), firstname, surname
    FROM cd.members
    ORDER BY joindate;
```
###### Question 25: Output the facility id that has the highest number of slots booked, again
Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tie-ing results get output.

```sql
SELECT facid, total
    FROM (
        SELECT facid, sum(slots) total, rank() OVER (ORDER BY sum(slots) DESC) rank
            FROM cd.bookings
            GROUP BY facid
        ) AS ranked
    WHERE rank = 1
```
#### Operations with Strings
###### Question 26: Format the names of members
Output the names of all members, formatted as 'Surname, Firstname'

```sql
SELECT surname || ', ' || firstname AS name 
    FROM cd.members;
```
###### Question 27: Find telephone numbers with parentheses
You've noticed that the club's member table has telephone numbers with very inconsistent formatting. You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.

```sql
SELECT memid, telephone 
    FROM cd.members 
    WHERE telephone ~ '[()]';  
```
###### Question 28: Count the number of members whose surname starts with each letter of the alphabet
You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet. Sort by the letter, and don't worry about printing out a letter if the count is 0.

```sql
SELECT substr(mems.surname, 1, 1) AS letter, count(*) AS count
    FROM cd.members mems
    GROUP BY letter
```
EOF