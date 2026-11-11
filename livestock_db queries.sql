SELECT a.Species, SUM(fl.Cost) AS TotalFeedCost, COUNT(*) AS FeedEntries
FROM livestock_db.FEED_LOG fl
JOIN ANIMAL a ON fl.AnimalID = a.AnimalID
GROUP BY a.Species
ORDER BY TotalFeedCost DESC;

SELECT at.`Type`, COUNT(*) AS NumTransactions,
SUM(at.Price) AS TotalValue
FROM livestock_db.ANIMAL_TRANSACTION at
GROUP BY at.`Type`;

SELECT a.TagNumber, a.Species, a.Breed, a.Sex, a.Weight, a.Status, h.PenName, f.FarmName
FROM livestock_db.ANIMAL a
Join Housing h ON a.HousingID = h.HousingID
JOIN FARM f ON h.FarmID = f.FarmID
WHERE a.Status = 'Active';

SELECT hr.RecordDate, a.TagNumber, a.Species, hr.Type, hr.Diagnosis, a.Name AS AttendingStaff, s.Role
FROM livestock_db.HEALTH_RECORD hr
JOIN ANIMAL a ON hr.AnimalID = a.AnimalID
LEFT JOIN STAFF s ON hr.StaffID = s.StaffID
ORDER BY hr.RecordDate DESC;