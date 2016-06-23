DROP VIEW IF EXISTS standings;
DROP VIEW IF EXISTS matches_played;
DROP VIEW IF EXISTS player_wins;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;

CREATE TABLE players (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(80)
);

CREATE TABLE matches (
  id     SERIAL PRIMARY KEY,
  winner INTEGER REFERENCES players (id),
  loser  INTEGER REFERENCES players (id)
);

CREATE VIEW matches_played AS
  SELECT
    players.id,
    players.name,
    count(matches) AS played
  FROM players
    LEFT JOIN matches
      ON players.id = matches.winner OR players.id = matches.loser
  GROUP BY players.id;

CREATE VIEW player_wins AS
  SELECT
    players.id,
    players.name,
    count(matches.winner) AS wins
  FROM players, matches
  WHERE players.id = matches.winner
  GROUP BY players.id
  ORDER BY wins DESC;

CREATE VIEW standings AS
  SELECT
    matches_played.id,
    matches_played.name,
    COALESCE(player_wins.wins,
             0) AS wins,
    matches_played.played
  FROM matches_played
    LEFT JOIN player_wins
      ON matches_played.id = player_wins.id
  ORDER BY wins DESC;