
#Suite Life

##File Structure

	|-- suitelife
	    |-- README.md
	    |-- .meteor							# packages and settings
	    |-- client							# will only run on the client
	    |   |-- layouts													
	    |   |   |-- defaultLayout.html 		# All other html is routed into {{> yield}}
	    |   |-- routes 						# route methods using iron_router
	    |   |   |-- chore_routes.coffee
	    |   |   |-- post_routes.coffee
	    |   |   |-- routes.coffee
	    |   |-- styles						# css
	    |   |-- subscriptions
	    |   |   |-- subscription.coffee 	# pub/sub for security. see http://bit.ly/PqiojT for details
	    |   |-- views 						# 95% of our code goes here
	    |       |-- chore
	    |       |   |-- chore_detail.coffee
	    |       |   |-- chore_detail.html
	    |       |   |-- chore_edit.coffee
	    |       |   |-- chore_edit.html
	    |       |   |-- chore_list.coffee
	    |       |   |-- chore_list.html
	    |       |   |-- chore_new.coffee
	    |       |   |-- chore_new.html
	    |       |-- common 					# reusable code- may split into helpers and templates later
	    |       |   |-- dropdown.coffee
	    |       |   |-- dropdown.html
	    |       |   |-- loading.html
	    |       |-- home
	    |       |   |-- home.html
	    |       |-- nav
	    |       |   |-- nav.html
	    |       |-- post
	    |       |   |-- post_detail.coffee
	    |       |   |-- post_detail.html
	    |       |   |-- post_edit.coffee
	    |       |   |-- post_edit.html
	    |       |   |-- post_list.coffee
	    |       |   |-- post_list.html
	    |       |   |-- post_new.coffee
	    |       |   |-- post_new.html
	    |       |-- splash
	    |       |   |-- splash.html
	    |       |-- suite
	    |           |-- suite.coffee
	    |           |-- suite.html
	    |           |-- suite_new.coffee
	    |-- collections						# database methods
	    |   |-- chore_collection.coffee
	    |   |-- post_collection.coffee
	    |   |-- suite_collection.coffee
	    |-- lib								# loads before other folders
	    |-- public 							# public-facing files like images, favicons, and robots
	    |-- server							# will only run on the server
	        |-- publications								
	            |-- publication.coffee 		# pub/sub for security. see http://bit.ly/PqiojT

##Links

[Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

[Tutorials](https://docs.google.com/spreadsheets/d/1oXsB1buRqZNS4U7Nxmb3syLAD2Ls50scBq2nT6GlFxY/edit?usp=sharing)

