-- Create an IPL Database
CREATE DATABASE IPL;

-- Using IPL Database
USE DATABASE IPL;

-- Create a Schema for the IPL Database
CREATE SCHEMA IPL_SCHEMA;

-- Create a File Format object for CSV data
CREATE OR REPLACE FILE FORMAT mycsvformat
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  null_if = ('NULL','null')
  empty_field_as_null = TRUE
  ENCODING = 'iso-8859–1'
  SKIP_HEADER = 1;

-- Create a Stage
CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = mycsvformat;

-- Upload the CSV files from your local file system using SnowSQL
PUT file:///home/majdi/Downloads/IPL-data-till-2017/*.csv @my_csv_stage;

-- List stages
LIST @my_csv_stage;

-- Create tables to load the CSV data into it
-- Create Team table
CREATE OR REPLACE TABLE team (
    team_sk integer,
    team_id integer,
    team_name string
);

-- Create Player_match table 
CREATE OR REPLACE TABLE player_match (
    player_match_sk INT,
    playermatch_key DECIMAL,
    match_id INT,
    player_id INT,
    player_name STRING,
    dob DATE,
    batting_hand STRING,
    bowling_skill STRING,
    country_name STRING,
    role_desc STRING,
    player_team STRING,
    opposit_team STRING,
    season_year DATE,
    is_manofthematch BOOLEAN,
    age_as_on_match INT,
    isplayers_team_won BOOLEAN,
    batting_status STRING,
    bowling_status STRING,
    player_captain STRING,
    opposit_captain STRING,
    player_keeper STRING,
    opposit_keeper STRING
);

-- Create a Player table
CREATE OR REPLACE TABLE player (
    player_sk INT,
    player_id INT,
    player_name STRING,
    dob DATE,
    batting_hand STRING,
    bowling_skill STRING,
    country_name STRING
);

--Create a Match table
CREATE OR REPLACE TABLE match (
    match_sk INT,
    match_id INT,
    team1 STRING,
    team2 STRING,
    match_date DATE,
    season_year DATE,
    venue_name STRING,
    city_name STRING,
    country_name STRING,
    toss_winner STRING,
    match_winner STRING,
    toss_name STRING,
    win_type STRING,
    outcome_type STRING,
    manofmach STRING,
    win_margin INT,
    country_id INT
);

-- Create a Ball_by_ball table
CREATE OR REPLACE TABLE ball_by_ball (
    match_id INT,
    over_id INT,
    ball_id INT,
    innings_no INT,
    team_batting STRING,
    team_bowling STRING,
    striker_batting_position INT,
    extra_type STRING,
    runs_scored INT,
    extra_runs INT,
    wides INT,
    legbyes INT,
    byes INT,
    noballs INT,
    penalty INT,
    bowler_extras INT,
    out_type STRING,
    caught BOOLEAN,
    bowled BOOLEAN,
    run_out BOOLEAN,
    lbw BOOLEAN,
    retired_hurt BOOLEAN,
    stumped BOOLEAN,
    caught_and_bowled BOOLEAN,
    hit_wicket BOOLEAN,
    obstructingfield BOOLEAN,
    bowler_wicket BOOLEAN,
    match_date DATE,
    season INT,
    striker INT,
    non_striker INT,
    bowler INT,
    player_out INT,
    fielders INT,
    striker_match_sk INT,
    strikersk INT,
    nonstriker_match_sk INT,
    nonstriker_sk INT,
    fielder_match_sk INT,
    fielder_sk INT,
    bowler_match_sk INT,
    bowler_sk INT,
    playerout_match_sk INT,
    battingteam_sk INT,
    bowlingteam_sk INT,
    keeper_catch BOOLEAN,
    player_out_sk INT,
    matchdatesk DATE
);

-- Load data into the table target
-- Load data into Team table
COPY INTO team
  FROM @my_csv_stage/Team.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

-- Load data into Ball_By_Ball table
COPY INTO ball_by_ball
  FROM @my_csv_stage/Ball_By_Ball.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';  
  
-- Load data into Match table
COPY INTO match
  FROM @my_csv_stage/Match.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file'; 
  
-- Load data into Player table
COPY INTO player
  FROM @my_csv_stage/Player.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';
  
-- Load data into Player_match table
COPY INTO player_match
  FROM @my_csv_stage/Player_match.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file'; 

-- Select all records from tables target
select * from player_match limit 10;
select * from match limit 10;
select * from player limit 10;
select * from ball_by_ball limit 10;
select * from team limit 10;