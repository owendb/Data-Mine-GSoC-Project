-- mysql  Ver 14.14 Distrib 5.5.41, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: civicrm
--
-- Do 'SELECT * from clicks_data_analytics' and 'SELECT * from clicks_data_analytics_per_click' to get the final results.
drop table if exists queue_mailing_mapping;

-- Create table 'queue_mailing_mapping' that maps every queue id to its mailing.
create table queue_mailing_mapping as select id, job_id from civicrm_mailing_event_queue;

alter table queue_mailing_mapping add column mailing_id int(10) unsigned;

update queue_mailing_mapping set mailing_id = (select mailing_id from civicrm_mailing_job where id = queue_mailing_mapping.job_id) where mailing_id is NULL and exists(select mailing_id from civicrm_mailing_job where id = queue_mailing_mapping.job_id);

-- Create table 'clicks_data' that stores information about the delay between sending of mails and opening of clicks.
create table clicks_data as select * from civicrm_mailing_event_trackable_url_open;

alter table clicks_data add column mailing_id int(10) unsigned;

update clicks_data set mailing_id = (select mailing_id from queue_mailing_mapping where id = clicks_data.event_queue_id) where mailing_id is NULL and exists(select mailing_id from queue_mailing_mapping where id = clicks_data.event_queue_id);

alter table clicks_data add column time_stamp_delivered datetime;

update clicks_data set time_stamp_delivered = (select time_stamp from civicrm_mailing_event_delivered where event_queue_id = clicks_data.event_queue_id) where time_stamp_delivered is NULL and exists(select time_stamp from civicrm_mailing_event_delivered where event_queue_id = clicks_data.event_queue_id);

alter table clicks_data add column delay_seconds int(10) unsigned;

update clicks_data set delay_seconds = TIMESTAMPDIFF(second, time_stamp_delivered, time_stamp);

-- Create table 'clicks_data_analytics' to store data pertaining to clicks analytics per mailing.
create table clicks_data_analytics as select mailing_id, min(delay_seconds) as min_delay, max(delay_seconds) as max_delay, avg(delay_seconds) as avg_delay from clicks_data group by mailing_id;

alter table clicks_data_analytics add column min_delay_time time;
alter table clicks_data_analytics add column max_delay_time time;
alter table clicks_data_analytics add column avg_delay_time time;

update clicks_data_analytics set min_delay_time = maketime(floor(min_delay/3600),floor(min_delay/60)%60,floor(min_delay%60));
update clicks_data_analytics set max_delay_time = maketime(floor(max_delay/3600),floor(max_delay/60)%60,floor(max_delay%60));
update clicks_data_analytics set avg_delay_time = maketime(floor(avg_delay/3600),floor(avg_delay/60)%60,floor(avg_delay%60));

-- Create table 'clicks_data_analytics_per_click' to store data pertaining to clicks analytics per click.
create table clicks_data_analytics_per_click as select trackable_url_id, min(delay_seconds) as min_delay, max(delay_seconds) as max_delay, avg(delay_seconds) as avg_delay from clicks_data group by trackable_url_id;

alter table clicks_data_analytics_per_click add column min_delay_time time;
alter table clicks_data_analytics_per_click add column max_delay_time time;
alter table clicks_data_analytics_per_click add column avg_delay_time time;

update clicks_data_analytics_per_click set min_delay_time = maketime(floor(min_delay/3600),floor(min_delay/60)%60,floor(min_delay%60));
update clicks_data_analytics_per_click set max_delay_time = maketime(floor(max_delay/3600),floor(max_delay/60)%60,floor(max_delay%60));
update clicks_data_analytics_per_click set avg_delay_time = maketime(floor(avg_delay/3600),floor(avg_delay/60)%60,floor(avg_delay%60));

