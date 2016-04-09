// Describe your query
// at the start
// in comments.


MATCH (con)-[r:CONSTITUENCY_OF]->(can)<-[m:MEMBER]-(p)
	WITH DISTINCT(p.Name) AS Party, COUNT(can.Surname) AS Party_Candidate_Count
MATCH (con)-[r:CONSTITUENCY_OF]->(can)<-[m:MEMBER]-(p)
	WHERE can.IsElected = true
RETURN DISTINCT(Party), Party_Candidate_Count, (Party_Candidate_Count - ???) AS ElectedCount
ORDER BY Party_Candidate_Count DESC;