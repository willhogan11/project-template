# Irish Constituencies Neo4j Database
###### Will Hogan, G00318460

## Introduction
My project is completely based on what transpired during the recent General Elections in Ireland in 2016. It aims to supply the user with useful general and statistical information, based on data that i have collected using the references highlighted in the footer of this page. 

There are three main parts that i focused on to source data and build my database:

|  *Field*   | *Value*  |
|:--------:|:-------------------------------------------:|
| **Candidates**     	| The Politicians that ran in the recent elections |
| **Parties**        	| The Political parties that each politician is associated with |
| **Constituencies** 	| The locations or areas that each Politician works in |

Based on the above Fields and values, I made general associations between Candidates, Parties and Constituencies in my project. 


---

## Database

####Tools Used
I used the Cypher query language to create and search my database. Cypher bares many similarities to SQL in its Syntax, but is different in other ways. I also used the IDE Neo4j to interact and input all my writes and search queries in Cypher which was then stored in the Database. I also used Notepad++ for parsing and sorting the data into Cypher friendly format. 

####Data Sourcing
I did a lot of research on how best to implement and structure my database and of course what data i was going to use and where i was going to get it from. There was plenty of information on the internet, but really i was looking for something with most of the data in one place to avoid having to reference lots of locations and increase the workload when trying to piece together all the data, which in turn would have made things much more difficult when trying to parse that data into cypher friendly code. 

After much searching, i found a useful CSV file from a website mentioned in Number 2 in the References section below, which gave me most of the data that i needed, however this was Pre-Election data and which obviously didn't contain any actual election results, so i then used some post analysis data referenced in Number 4, to add to my main data set. 

####Creating the Database
I used Microsoft Excel to add various CYPHER code in columns, which i repeated down through each row. Once i had completed this task, i then imported each file into Notepad++. I found this extremely useful as i was able to complete bulk removal of extra whitespace, tabs and other unwanted artefacts that remained from the CSV import. I was able to accomplish this with simple Find and replace all functions in Notpad++.

Once all my Nodes and relationships were ready, I amalgamated them all into one single ```.cypher``` file. Anyone who want to use this database, just needs to copy and paste the scripts form the one file and run in Neo4j or Console. 

Here is a brief outline of the structure of each node, the properties that it holds and some examples of Cypher code that is used to create each Node and Relationship.
<br><br>
#####Candidate Node:

|  *Node*   | *Label* | *Property 1*  | *Property 2* | *Property 3* | *Property 4* |
|:--------:|:------:|:-------:|:-----------:|:----------:|:---------:|
| **Candidate**| EndaKenny | FirstName | Surname | Gender | IsElected |

Corresponding Cypher Create statement:

```cypher
CREATE(EndaKenny:Candidate{FirstName:"Enda",Surname:"Kenny",Gender:"Male", IsElected: true})
```
<br>
#####Constituency Node:

|  *Node*   | *Label* | *Property 1*  | *Property 2* | *Property 3* |
|:--------:|:------:|:-------:|:-----------:|:----------:|
| **Constituency**| Mayo | Name | Population | Seats |

Corresponding Cypher Create statement:

```cypher
CREATE(Mayo:constit{Name:"Mayo",Population:120332,Seats:4})
```
<br>
#####Political Party Node:

|  *Node*   | *Label* | *Property 1*  | *Property 2* | *Property 3* | *Property 4* |
|:--------:|:------:|:-------:|:-----------:|:----------:|:---------:|
| **Party**| FineGael | FirstName | Surname | Gender | IsElected |

Corresponding Cypher Create statement:

```cypher
CREATE(FineGael:Party{Name:"FineGael"})
```
<br>
#####Relationship Creation
To create relationships i added specific labels to each node, which made things considerably easier when performing multiple relationships in the one query. 
Here's an example of how a created a Relationship between the Parties, Candidates and Constituencies in one query:
```cypher
CREATE(Mayo)-[:CONSTITUENCY_OF]->(EndaKenny)<-[:MEMBER {role: "Leader"}]-(FineGael)
```

---

## Queries
I have selected three queries to work with that displays useful information to the user about the Election
Query one retrieves and displays general information about each Candidate, like the party they represent and the Constituency that they work in. 

Query two displays details about each party, ie the number if members in each and each parties performance, like the Total elected number of candidates and unsuccessful candidates. This query is designed to reflect the Parties performance in the Election. 

Query three displays details about each genders performance in a particular Constituency, with breakdown by constituency and Gender. Percentages and count of won seats are calculated and displayed in each column. 


#### Query one - Retrieve Candidates, Parties & Constituencies
This query uses a three way relationship model to build / join the various nodes together. Each candidate node is used to match 
A relationship with the party and constituency nodes. So for example as the arrow directions of the 
Relationship part of the query would suggest, a constituency belongs to certain candidate and a party has a candidate as a member. 

The result set itself contains fundamental information about each candidates Election campaign, Full name of each candidate, 
The Party they represent and the Constituency they work in. For readability i used alias naming convention for each column result returned,
Which essentially allows for 'on the fly' naming for unsightly column results. 

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

#### Query two - Party Candidate Count Statistics (Elected & Unsuccessful)
This query returns a number of interesting statistics based on each party’s performance
In the Election. The first count is the Number of candidates in each party, followed by the Count of successfully elected candidates by party and
Finally the count of each candidate by party, whose efforts bore no fruit.

The query is structured with a relationship match for party and candidate nodes
Which then groups together each party name and returns various counts. I used ```DISTINCT``` for the grouping part of the query
and the inbuilt ```STR()``` function which allowed me to structure my own Row/Column detail. 
I used the ```UNION ALL``` keywords to vertically stack each result set on top of each other. To avoid confusion and as i mentioned above, 
i used the ```STR()``` function to Highlight which part of the query the user is reading and just to make it more readable i used multiple ```ORDER BY``` 
To display the count information from Highest to lowest (DESC) on each ```UNION ALL``` 

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

#### Query Three - Elected Male / Female Statistics
This query returns details about the amount of available seats in the area, plus the amount Elected 
Male / Female candidates and the Number of Elected Female percentages ordered from High to Low. 

I started by matching the relationships and used a where clause to breakdown the result set into Candidates that are Female and 
Got elected. From there i used some math to calculate the remaining columns based on previous Counts of Available seats and Female Elected counts. 
```cypher
MATCH
	(con)-[r:CONSTITUENCY_OF]->(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = true 
		AND can.Gender = "Female"
RETURN 
	DISTINCT(con.Name) AS Area, 
	con.Seats AS AvailableSeats, 
        (con.Seats - COUNT(can.Gender = "Female")) AS Elected_M_Count,
	COUNT(can.Gender = "Female") AS Elected_F_Count,
        (COUNT(can.Gender = "Female") * 100 / con.Seats + "%") AS Elected_F_P
ORDER BY Elected_F_P DESC;
```

---

## References
1. [Neo4J website](http://neo4j.com/), the website of the Neo4j database.
2. [Election 2016 Database Source](http://irish-elections.storyful.com/). I used this database source to work with for my project, it came in CSV format.
3. [Elected Candidates](http://www.rte.ie/news/election-2016/parties/fianna-fail/). I used this link, to factor in all elected candidates into my project. 
4. [Notepad++ Tricks](http://a4apphack.com/featured/tricks-with-notepad). Found this very useful for parsing plain text and removing unwanted
whitespaces etc, that would have remained after working with CSV file to create cypher code. 
5. [Stackoverflow example referenced](http://stackoverflow.com/questions/22616786/neo4j-cypher-stacking-results-with-union-and-with). This link came in handy when i was looking for stacking multiple resultsets vertically.
