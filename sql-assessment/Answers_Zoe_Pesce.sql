CREATE DATABASE SQL_Challenge;
use sql_challenge;

create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);

create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
);

-- 1 Write a query to get the sum of impressions by day.
select date(date) as day, sum(impressions) as sum_day_impressions
from marketing_data
group by date;

-- 2 Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?
select state, sum(revenue) as total_state_revenue from website_revenue
group by state
order by sum(revenue) desc
limit 3;
-- the third best state generated $37,577 in revenue

-- 3 Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.
select c.name, sum(m.cost) as total_cost, sum(m.impressions) as total_impressions, sum(m.clicks) as total_clicks, sum(w.revenue) as total_revenue
from marketing_data m inner join website_revenue w on m.campaign_id = w.campaign_id inner join campaign_info c on c.id = m.campaign_id
group by m.campaign_id;

-- 4 Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?
select c.name, w.state, sum(m.conversions) as total_conversions 
from website_revenue w inner join marketing_data m on w.campaign_id = m.campaign_id inner join campaign_info c on c.id = m.campaign_id
where c.name = 'Campaign5'
group by c.name, w.state
order by sum(m.conversions) desc;
-- Georgia (GA) generated the most conversions for Campaign5

-- 5 In your opinion, which campaign was the most efficient, and why?
select c.name, sum(m.cost) as total_cost, sum(w.revenue) as total_revenue, sum(w.revenue)-sum(m.cost) as total_profit, sum(m.conversions) as total_coversions, sum(m.clicks) as total_clicks, sum(m.impressions) as total_impressions, sum(w.revenue)/sum(m.cost) as revenue_to_cost_ratio
from marketing_data m inner join website_revenue w on m.campaign_id = w.campaign_id inner join campaign_info c on c.id = m.campaign_id
group by c.name
order by revenue_to_cost_ratio desc;
-- Campaign4 was the most efficient in terms of cost because it has the highest ratio of revenue to cost, as shown by the output of the above query. While Campaign3 generated the highest gross profit, it is ranked second to last in terms of cost efficiency because it had a higher cost relative to the revenue it generated.

-- 6 (Bonus Question) Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
select dayname(date) as day_of_week, sum(clicks) as total_clicks from marketing_data
group by day_of_week
order by sum(clicks) desc;
-- As shown by the output of the above query, Saturday is the best day of the week to run ads. This conclusion is based on the total number of clicks by day of the week.