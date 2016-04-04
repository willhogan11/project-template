// Returns a list of all Political Candidates, the Cconstituency that they work in and the Party they work for.

MATCH (con)-[r:CONSTITUENCY_OF]->(can)<-[m:MEMBER]-(p)
RETURN can.FirstName AS Name, 
	   can.Surname AS Surname, 
       p.Name AS Party, 
       con.Name as Constit, 
       m AS Role
ORDER BY Party, Constit;