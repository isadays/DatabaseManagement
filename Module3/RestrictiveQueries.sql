SELECT * FROM Faculty;
SELECT * FROM Faculty
WHERE FacNo = '543-21-0987';
SELECT FacFirstName, FacLastName, FacSalary
FROM Faculty
WHERE FacSalary > 65000 AND FacRank = 'PROF';
SELECT DISTINCT FacCity, FacState
FROM Faculty;


SELECT FacFirstName,FacLastName, FacCity, FacSalary*1.1 AS IncreasedSalary, FacHireDate
FROM Faculty
WHERE (date_part('YEAR',FacHireDate)) > 2008;

/* SELECTING ARGUMENTS WITH SOME CHARACTER */ 
SELECT * 
FROM Offering
WHERE CourseNo LIKE 'IS%';
/* SELECTING RANGE OF ARGUMENTS */ 
SELECT FacFirstName, FacLastName, FacHireDate 
FROM Faculty
WHERE FacHireDate BETWEEN '2011-01-01' AND '2012-12-31';

/* SELECTING TEXT AND NUMERICAL ARGUMENTS , MIXING AND AND OR */ 
SELECT OfferNo, CourseNo, FacNo
FROM Offering 
WHERE (OffTerm = 'FALL' AND OffYear = 2019) OR (OffTerm= 'WINTER' AND OffYear= 2020);


