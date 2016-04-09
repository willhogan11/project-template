# Irish Constituencies Neo4j Database
###### Will Hogan, G00318460

## Introduction
Give a summary here of what your project is about.

## Database
Explain how you created your database, and how information is represented in it.

## Queries
Summarise your three queries here.
Then explain them one by one in the following sections.

#### Query one - Retrieve Candidates, Parties & Constituencies
This query uses a three way relationship model to build / join the various nodes together. Each candidate node is used to match 
a relationship with the party and constituency nodes. So for example as the arrow directions of the 
relationship part of the query would suggest, a constituency belongs to certain candidate and a party has a candidate as a member. 

The resultset itself contains fundamental information about each candidates Election campaign, Full name of each candidate, 
the Party they represent and the Constituency they work in. For readability i used alias naming convention for each column result returned,
which essentially allows for 'on the fly' naming for unsightly column results. 

```cypher
MATCH (con)-[r:CONSTITUENCY_OF]->(can)<-[m:MEMBER]-(p)
RETURN 
	can.FirstName AS Name, 
	can.Surname AS Surname, 
	p.Name AS Party, 
	con.Name as Constituency, 
	m AS Role
ORDER BY Party, Constituency;
```

#### Query two - Party Candidate Count Statistics(Elected & Unsuccessful)
This query returns a number of interesting statistics based on each parties performance
in the Election. The first count is the Number of candidates in each party, followed by the Count of successfully elected candidates by party and
finally the count of each candidate by party, whose efforts bore no fruit.

The query is structured with a relationship match for party and candidate nodes
which then groups together each party name and returns various counts. I used ```DISTINCT``` for the grouping part of the query
and the inbuilt ```STR()``` function which allowed me to structure my own Row/Column detail. 
I used the ```UNION ALL``` keywords to Vertically stack each resultset on top of each other. To avoid confusion and as i mentioned above, 
i used the ```STR()``` function to Highlight which part of the query the user is reading and just to make it more readable i used multiple ```ORDER BY``` 
to display the count information from Highest to lowest (DESC) on each ```UNION ALL``` 

```cypher
MATCH(can)<-[m:MEMBER]-(p)
RETURN 
	DISTINCT(p.Name) AS Party, 
	STR("Total Members") AS Election_Info, 
	COUNT(can) AS Party_Candidate_Count
ORDER BY Party_Candidate_Count DESC

UNION ALL

MATCH(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = true
RETURN 
	DISTINCT(p.Name) AS Party, 
	STR("Elected Candidate Count") AS Election_Info,
	COUNT(can) AS Party_Candidate_Count 
ORDER BY Party_Candidate_Count DESC

UNION ALL

MATCH(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = false
RETURN 
	DISTINCT(p.Name) AS Party, 
	STR("Not Elected Candidate Count") AS Election_Info,
	COUNT(can) AS Party_Candidate_Count
ORDER BY Party_Candidate_Count DESC;
```

#### Query three title
This query retreives the Bacon number of an actor...
```cypher
MATCH
	(Bacon)
RETURN
	Bacon;
```

## References
1. [Neo4J website](http://neo4j.com/), the website of the Neo4j database.
2. [Election 2016 Database Source](http://irish-elections.storyful.com/). I used this database source to work with for my project, it came in CSV format. 
3. [Notepad++ Tricks](http://a4apphack.com/featured/tricks-with-notepad). Found this very useful for parsing plain text and removing unwanted
whitespaces etc, that would have remained after working with CSV file to create cypher code. 
4. [Elected Candidates](http://www.rte.ie/news/election-2016/parties/fianna-fail/). I used this link, to factor in all elected candidates into my project. 
5. [Stackoverflow example referenced](http://stackoverflow.com/questions/22616786/neo4j-cypher-stacking-results-with-union-and-with). This link came in handy when i was looking for stacking multiple resultsets vertically. 