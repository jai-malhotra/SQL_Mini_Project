################################################## DBMS 1 MINI PROJECT ##################################################
use ipl;

# CHECKING THE DATA
select * from ipl_bidder_details;
select * from ipl_bidder_points;
select * from ipl_bidding_details;
select * from ipl_match;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_standings;
select * from ipl_tournament;
select * from ipl_user;

################################################## QUESTION 1 ##################################################
# Show the percentage of wins of each bidder in the order of highest to lowest percentage.

select b1.bidder_id as "Bidder ID", bidder_name as "Bidder Name", sum(case when bid_status='Won' then 1 else 0 end)*100/count(bid_status) as Wins_Percentage
from ipl_bidding_details b1 join ipl_bidder_details b2 on b1.bidder_id=b2.bidder_id 
group by b1.bidder_id
order by Wins_Percentage desc;

################################################## QUESTION 2 ##################################################
# Display the number of matches conducted at each stadium with stadium name, city from the database.

select s1.stadium_id as "Stadium ID", stadium_name as "Stadium Name", city as "City in which the Stadium is Located", count(s2.stadium_id) as "Number of Matches Conducted in the Stadium"
from ipl_stadium s1 join ipl_match_schedule s2 on s1.stadium_id=s2.stadium_id
group by s1.stadium_id
order by s1.stadium_id;

################################################## QUESTION 3 ##################################################
# In a given stadium, what is the percentage of wins by a team which has won the toss?

# Some corrections in data for the table ipl_match
update ipl_match set match_winner = 2 where match_id = 1054;
update ipl_match set match_winner = 1 where match_id = 1056;
update ipl_match set match_winner = 2 where match_id = 1057;
update ipl_match set match_winner = 1 where match_id = 1058;

select m2.stadium_id as "Stadium ID", Stadium_name as "Stadium Name", sum(case when toss_winner=match_winner then 1 else 0 end) as "Cases when Team Won Both the Toss and the Match", count(m2.stadium_id) as "Total Matches Played in the Stadium", sum(case when toss_winner=match_winner then 1 else 0 end)*100/count(m2.stadium_id) as "Win Percentage when Toss Won"
from ipl_match m1 join ipl_match_schedule m2 on m1.match_id=m2.match_id
join ipl_stadium m3 on m2.stadium_id=m3.stadium_id
group by m2.stadium_id
order by m2.stadium_id;

################################################## QUESTION 4 ##################################################
# Show the total bids along with bid team and team name.

select b2.bid_team as "Bid Team", team_name as "Team Name", count(b1.no_of_bids) as "Total Bids"
from ipl_bidder_points b1 join ipl_bidding_details b2 on b1.bidder_id=b2.bidder_id
join ipl_team b3 on b3.team_id=b2.bid_team
group by bid_team
order by bid_team;

################################################## QUESTION 5 ##################################################
# Show the team id who won the match as per the win details.

select if(match_winner=1, team_id1, team_id2) as "Winning Team ID", substr(win_details,6,3) as "Winning Team", win_details as "Win Details"
from ipl_match;

################################################## QUESTION 6 ##################################################
# Display total matches played, total matches won and total matches lost by team along with its team name.

select t1.team_id as "Team ID", team_name as "Team Name", sum(matches_played) as "Total Matches Played", sum(matches_won) as "Total Matches Won", sum(matches_lost) as "Total Matches Lost"
from ipl_team_standings t1 join ipl_team t2 on t1.team_id=t2.team_id
group by team_name
order by sum(matches_won) desc;

################################################## QUESTION 7 ##################################################
# Display the bowlers for Mumbai Indians team.

select p1.player_id as "Player ID", player_name as "Player Name", player_role as "Player Role", team_name as "Team Name"
from ipl_player p1 join ipl_team_players p2 on p1.player_id=p2.player_id
join ipl_team p3 on p2.team_id=p3.team_id
where team_name="Mumbai Indians" and player_role='bowler';

################################################## QUESTION 8 ##################################################
# How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.

select team_name as "Team Name", count(player_role) as "Number of All Rounders in the Team"
from ipl_team t1 join ipl_team_players t2 on t1.team_id=t2.team_id
where player_role='All-Rounder'
group by team_name
having count(player_role)>4
order by count(player_role) desc;