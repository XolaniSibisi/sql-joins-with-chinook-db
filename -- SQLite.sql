-- SQLite
SELECT * FROM genres;

SELECT * FROM playlists;

SELECT albums.Title, artists.Name
FROM albums JOIN artists
ON albums.ArtistId = artists.ArtistId
WHERE artists.Name = 'Lost';

SELECT tracks.TrackId, tracks.Name, genres.Name
FROM tracks JOIN genres
ON tracks.GenreId = genres.GenreId
WHERE genres.Name = 'Metal';

SELECT * FROM playlists
JOIN playlist_track ON playlist_track.PlaylistId = playlists.PlaylistId
JOIN tracks ON playlist_track.TrackId =  tracks.TrackId
WHERE playlists.Name = 'Music';

--one: Find all the artists for a given Genre
SELECT * FROM genres
JOIN tracks ON tracks.GenreId = genres.GenreId
JOIN albums ON albums.AlbumId = tracks.AlbumId
JOIN artists ON artists.ArtistId = albums.ArtistId
WHERE genres.Name = 'Rock';

--two: Find the Playlist with the most / least songs (will need a group by  and count )
SELECT p.PlaylistId, p.Name, COUNT(pt.TrackId) AS NumberOfSongs
FROM playlists p
JOIN Playlist_Track pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId, p.Name
ORDER BY NumberOfSongs DESC
LIMIT 1;

SELECT p.PlaylistId, p.Name, COUNT(pt.TrackId) AS NumberOfSongs
FROM playlists p
JOIN Playlist_Track pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId, p.Name
ORDER BY NumberOfSongs ASC
LIMIT 1;


--three: Find the total for a given invoice
SELECT InvoiceId, SUM(UnitPrice * Quantity) as Total
FROM invoice_items
WHERE InvoiceId = 3
GROUP BY InvoiceId;

--four: Find all the playlists containing a given genre
SELECT * FROM genres
JOIN tracks ON tracks.GenreId = genres.GenreId
JOIN playlist_track ON playlist_track.TrackId = tracks.TrackId
JOIN playlists ON playlists.PlaylistId = playlist_track.PlaylistId
WHERE genres.Name = 'Rock';

--five: Find the biggest/smallest invoice amounts
SELECT MAX(UnitPrice*Quantity) AS BiggestInvoiceAmount,
       MIN(UnitPrice*Quantity) AS SmallestInvoiceAmount
FROM invoice_items;

--six: Find the artist with the most/least songs
WITH ArtistTrackCount AS (
    SELECT
        ar.Name AS ArtistName,
        COUNT(t.TrackId) AS TrackCount
    FROM
        artists ar
    JOIN albums al ON ar.ArtistId = al.ArtistId
    JOIN tracks t ON al.AlbumId = t.AlbumId
    GROUP BY
        ar.Name
)

SELECT 
    ArtistName,
    TrackCount,
    CASE
        WHEN TrackCount = (SELECT MAX(TrackCount) FROM ArtistTrackCount) THEN 'Most Songs'
        WHEN TrackCount = (SELECT MIN(TrackCount) FROM ArtistTrackCount) THEN 'Least Songs'
        ELSE 'Other'
    END AS Description
FROM 
    ArtistTrackCount
WHERE 
    TrackCount = (SELECT MAX(TrackCount) FROM ArtistTrackCount)
    OR TrackCount = (SELECT MIN(TrackCount) FROM ArtistTrackCount);
