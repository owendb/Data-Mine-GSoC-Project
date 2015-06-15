# Data-Mine-GSoC-Project
The project aims at adding prediction to the existing data, i.e. to be able to make predictions about how likely an individual would respond positively or negatively or neutrally to a particular engagement action given their relationship history. 

Refer to this link for more information about the project:
http://wiki.civicrm.org/confluence/display/CRM/Data+Mine+Project

**Present Status**

There are 2 sql files - 

*mailing_sendopen_analysis.sql* -> Creates table 'civicrm_mailing_analytics' that contains the final results about mail analytics.
*mailing_clicks_analysis.sql* -> Creates table 'civicrm_clicks_analytics' and 'civicrm_clicks_analytics_per_click'  that contains the final results about clicks analytics.

The aggregated results of these sql files on the dump are stored in Results_dump folder.
