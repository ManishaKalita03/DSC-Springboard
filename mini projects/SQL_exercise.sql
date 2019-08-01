

/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name
FROM Facilities where membercost > 0


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(name)as free_facility
FROM Facilities Where membercost = 0



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid,name,membercost,monthlymaintenance
FROM Facilities 
Where membercost <(0.2*monthlymaintenance)



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */


SELECT * 
FROM Facilities
WHERE facid IN (1,5)



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */


SELECT name,monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN 'expensive'
ELSE 'cheap' END AS cost_label
From Facilities



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */


SELECT firstname,surname,joindate 
FROM Members where joindate = (Select MAX(joindate) From Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT DISTINCT name, CONCAT( firstname,  ' ', surname ) AS  Member_name
FROM Facilities
JOIN Bookings ON Facilities.facid = Bookings.facid
JOIN Members ON Members.memid = Bookings.memid
AND name LIKE  'Tennis Court%'
ORDER BY Member_name



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT name,CONCAT( firstname,  ' ', surname ) AS  Member_name,
(Case When Bookings.memid=0 Then guestcost
Else membercost END)*slots AS Cost
FROM Facilities
JOIN Bookings ON Facilities.facid = Bookings.facid
JOIN Members ON Members.memid = Bookings.memid
Where Cast(starttime as Date)="2012-09-14"
And ((Case When Bookings.memid=0 Then guestcost
Else membercost END)*slots)>30
Order by 3 DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT name, CONCAT( firstname,  ' ', surname ) AS  Member_name,(Case When Bookings.memid=0 Then guestcost
Else membercost END)*slots AS Cost
FROM Facilities
JOIN Bookings ON Facilities.facid = Bookings.facid
JOIN Members ON Members.memid = Bookings.memid
WHERE starttime IN (Select starttime from Bookings Where Cast(starttime as date) =  "2012-09-14" )
AND ((Case When Bookings.memid=0 Then guestcost
Else membercost END)*slots)>30
order by Cost Desc



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


SELECT name, (
monthlymaintenance - ( guestcost + membercost )
) AS  Revenue
FROM Facilities
WHERE (
monthlymaintenance - ( guestcost + membercost )
) <1000
ORDER BY 2