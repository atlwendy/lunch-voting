Lunch Voting
============

This is an application that helps people to make a decision on lunch venu selection. 

Lunch voting work flow:

![Alt text] (workflow.png "work flow")

It's described as follows:

* A user initiates a lunch meeting. 
* The system sends out emails to all the invitees. 
* Invitees can follow the link in the email to land on this scheduled lunch page.
* Once they RSVP'd, they can start voting on the venues. 
* Each user gets vote either up or down on a venue. 
* User can also propose new venues. 
* The venue with highest votes is selected. 

Extra notes:

* 48 hours before the scheduled lunch time, system sends out a reminder email to all invitees to vote. 
* 24 hours prior to lunch time, winner is selected and voting is locked. 
* The final decision is emailed to the RSVP'd invitees. 

The purpose of this mechanism is for everyone to plan on their event ahead of time and prevent last minute plan change.

The entire application is written with Ruby/Rails and JQuery. 

