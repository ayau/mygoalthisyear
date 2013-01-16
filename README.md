#My Goal This Year

This is a project started by [Alex Yau](https://github.com/ayau) to help you keep track of and achieve your goals in the coming year.

This project was started in late December 2012 and still in development. However, you can try out a basic, bareboned version of the site [here](http://mygoalthisyear.herokuapp.com/).

###Overview
This is an attempt to leverage the power of [gamification](http://www.youtube.com/watch?v=lfBpsV1Hwqs) to help you achieve what you set out to do in the coming year. 

We all have the experience of setting powerful goals at the beginning of the year only to forget about them a few weeks later. This project attempts to help you __break down your goals__ into achievable targets, __be creative__ by creating your very own unique badge and __monitor your progress__ as you slowly tackle challenges and get points.

##Tools and Resources
* Rails 3.2
* Backbone and CoffeeScript
* Sass
* [ColourPicker.js](http://safalra.com/web-design/javascript/colour-picker/) -- a simple javascript color picker
* [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook)
* JQuery draggable, droppable


##Badges
Icons for badges are in svg format and in the public domain, obtained from [TheNounProject](http://thenounproject.com/).

Currently, only 22 icons are included but more are coming soon.

##Privacy
All goals, progress and comments are private by default.

##Update (01/14/13)
    Backbone implemented for user page to increase responsiveness
    Ordering of bucket goals (order by date given up)
    Use of svg in badge selection (no need to reload after color selection)
    
##To do
* Switch to golden ratio color generation
* Move JS to Backbone for goal page
* Fix day 7 of 31
* Dynamic points change
* Ordering of goals and subgoals
* Replace Info section
* Improve subgoal selection and auto choose subgoal
* Implement month transitions
* Implement Badge view
* Display achievements dynamically -- scrollable
* Timeline view for users
* Shared progress for goals
* Privacy control -- everything is currently private
* Show all months
* Improve design for subgoal completion
* Implement a level system
* Implement comments for goals
* "Uncompleting" achieved goals
* Implement notifications
* Add more functions to the goal page
* User of svg in all badges
* Remove unnecessary views and methods serverside (those handled by backbone)

