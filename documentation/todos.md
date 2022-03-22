# TODOs
1. assignments becomes assignments
2. Setting up homes (organizations) with multi-tenancy
3. Naming convention for users/admins
4. convert tasks to tasks (tasks have a type task or challenge)
- get rid of challenges
5. set up state machine (aasm)
6. define MVP
7. Decide on whether we want to do STI or an enum/category attr on Tasks to differentiate between Chores and Challenges (and possibly Training?)

# Other TODOs
Tests
- Written too much stuff already to have not tested any of it

UI
- Need to decide on a color palette (https://huemint.com/website-3/)
  - red, green, yellow might do well to represent the states of tasks and stuff, then just need some kind of primary color for the application shell

Fix the mobile menu
- Currently has an issue where the overlay element I'm "hiding" isn't actually getting hidden correctly and it prevents the user from being able to click on anything underneath it.
- I also don't know if we want to keep this column on the far left that allows the mobile menu to be opened.  The hamburger is probably good enough and it means we can't put anything on the far left side of the screen for mobile without z-indexing over this stupid invisible column.

Rewards Category
- Rewards currently have a value and category but we probably only need a value since we are planning a dynamic/chuck-e-cheese ticket-style rewards system. If this is the case, we probably don't need the rewards table at all and can just add a reward column to the assignments table. Will make that assignments form easier as well.

Flash message in assignments/show.html.erb
- Currently in assignments_controller.js, the markComplete() function targets a div to put flash messages in that is built into assignments/show.html.erb.  Need to switch this to target the application flash message container in the _flash_messages.html.erb partial instead.

Mobile buttons
- Buttons do not respond well to a smaller screen. Should figure out the best way to handle this but my guess is a special button class to be used on smaller screens that have less vertical and possibly also horizontal padding.
  - Dont do that- just add screensize breakpoints to the .btn class and I don't have to worry about doing anything different and can just keep calling .btn

## Gems
yarddoc
- Trying to document everything expecting to use this gem, but after installation will probably have to go back and make sure everythings cool

rspec
- Write tests
- Cleanup all the minitest files I've generated from scaffolding and what not

bullet
- 99 problems but N + 1

fasterer

rails-best-practices

overcommit
- Probably overkill for a side project but why not do things like you would in prod?
- Commit hooks: rubocop, yarddoc, rspec, rails-best-practices, bullet, fasterer

auditable
- Probably want to be able to check and see whos doing what and when. God help me if the kids figure out each others passwords and wreak havoc on each other.
- Would mean I need to track histories and at least be able to read them somewhere

discard
- If we're going to use auditable for histories, maybe I want to use discard and soft-delete stuff or else I'm going to have to add a bunch of crap to deal with the join tables

## DevOps
Probably going to run this locally for now to make sure this doesnt end up being a point of contention outside the house, but maybe want a copy on Heroku or something that only admins can log into remotely. Possibly accomplish this by just keeping the URL in my pocket and let the kids get served by localhost. That means I need to take care of syncing data and need to build an API though. Maybe having an outdated copy on Heroku from weekly backups or something is ok? Not a priority.

If I do actually put this on the big scary internet, need to figure out if its worth doing in AWS and getting terraform/jenkins/etc. involved or if I just want to manually manage deploys on Heroku like a peasant that has other things to do than setup a devops pipeline. Probably worth the experience since I'm supposed to be learning this anyway.

# UI
Buttons
- To stick with the TailwindUI kit stuff, convert the classes we're getting from them into our btn/btn-<COLOR> classes (focus ring, bg/font color, hover, etc.)
  - Once this is done, we can convert all the tailwind buttons to our custom classes and remove the dozens of classes it takes to put a button on the screen using their stuff

Modals
- In mobile view, the modals are aligned towards the bottom of the screen and not the middle. There is some <div> we're getting from Tailwind thats sole purpose is to place the modal and we probably just need to update that.
  - May have been resolved, but now the bug for the mobile menu overlay is preventing the user from being able to select a radio button

- Use a stimulus CSS controller similar to the modern FE rails book on the radio buttons (_update_status.html.erb)
