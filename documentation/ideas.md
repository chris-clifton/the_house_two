Brain dump of all ideas and random thoughts for this app. Many are pipe dreams or feature requests from the little users.

# Chores
- Chores have rewards and penalties
- Chores can have subtasks (dishes = load washer, run washer, dry dishes, put away)
- Chores can have types (checkout chores = all craft stuff put away, switches on chargers)
- When an captain has marked a chore complete, should alert the user next time they login congratulating them for completing the chore, displaying the reward for the chore, and their current balance

# Rules
- Rules have penalties and no rewards (not getting ready when asked the first time, not cleaning up after yourself, etc.)

# Challenges
- Challenges have rewards and no penalties
- These should be opportunities for kids to "unlock" tasks (via Training) that arent necessarily chores/their responsibility but they can do them in order to earn extra cash

# Rich forms for Chores, Challenges, Training
- Allow step by step instructions
- Allow photo uploads
- Allow limited amount of styling (bold, italics, lists, etc.)

# Other
- Leaderboard
- Monthly summaries
- User stats
- User PIN instead of password (probably necessary if you wall mount this thing)
- Learning section (books, online tutorials, etc.)
  - Kids can learn about a topic and present their learnings for a reward

# Rewards
- Switch to only using points, but the points can be cashed in for other things (tickets at chuckecheese)

# Assignments
- Tasks that must be completed in a certain time frame (feeding dog breakfast, taking out trash after dinner, etc.)
- Schedule repeating tasks

# Challenges
- maybe instead of a separate table for challenges, its just a task but with some kind of type
- maybe a tasks table with a enum type column for tasks, challenges
- instead of assignments/tasks name it "assignments"

# User/admin naming convention
- less sterile naming conventions that apply to different types of homes more broadly

# Organizations
- call these homes, houses, maybe something related to whatever we name users/admins

# Authentication
- Only want the main person to be required to have an email attached
- maybe just login with unique usernames would be good enough? and tehse belong to an organization

# Themes, Roles, and Organizations Brain Dump
- queen bee and the beehive
- pirate ship and the crew
- space station and its crew
- organizatios should be able to set their own roles (captain, moderator, user)
  - maybe they want to put the 16 year old in charge
  - maybe its Grandpa and kids, mom
- should allow themes where different roles have different titles/possibly even avatars
  - Pirates: officers can be the parents, jr officers for moderators, pirates/crew
  - Space stations: officers, jr officers, crew/astronauts?
  - Wolfpacks
- Themes can mean features are named different
  - astronaut checklist for "tasks" on space station
  - pirate checklist for "tasks"
  - basically just call them whatever noun their role is for that theme in front of the feature
- set the organization owner up with an animated setup guide
  - let them pick how many users they want to setup with
  - assign those users roles (captain, moderator, user)
    - describe to captains how the roles work and what they are able to do
      - editable permissions with sensible defaults
        - maybe defined permissions groups the captain can choose for his organization (the way IAM works)
    - how should moderators work?
      - captains should have to sign off on moderators "completing" things
      - moderators can approve a regular user's task to be complete
      - only captains can cash in rewards
        - allow for an captain to review anything a moderator did and override it
      **maybe this doesnt belong in the cool setup wizard but I got here from thinking about moderators**
      **but a scheduled report to the captains is a separate feature that sounds like a potential good idea**
      - maybe captains get a weekly report that says has sections like:
        - "pending review"
          - "user" waiting for your approval on these things
          - "moderator" approved each "user" of doing these things
          - give them two buttons to either confirm or review which takes them to the app and lists all this stuff out
          - when an captain either "confirms" the email report or confirms after they've reviewed the report, thats when things move from pending review to complete, and thats when rewards are applied (which only captains can do)
            - if this becomes a thing, we should set a preference on the review period- do they want daily, weekly, or monthly reports?
            - obviously allow them to approve anything whenever they want and that does not appear in the "pending review" section of the report
        - summary
          - just a list of everything everyone got done that report cycle, include stuff like rewqrds balances, rewards balances that were "cashed in", consqeunces (served/outstanding), milestones and training, etc.

- assign those users some kind of title if they want (mom, grandpa, uncle steve, bob, pop, whatever)
  - doesnt have anything to do with the role
- let them pick a theme
  - this will show them what each user in each role will be called (officer, jr officer, crew)
    - they should be able to swap between themes here to test it out

# Weekly reports
- See the comment in bold in the above section
- ability to approve tasks/apply rewards

# User agreements
- be cool about it but not too cool
  - probably smart to make the repo private so we arent inviting trouble (if it goes on the internet) but not hide what we're doing
- be open about how much time we spent on security/privacy and let users know we built this for fun
- make an honest privacy center
  - let the users know what is stored in the database and why
  - how this data could be used against them if the app were for whatever reason breached/sold
- when a user deletes their account, they should be given the option to delete literally everything from out database
  - just make it known like "hey! we can deactivate your account for your convenience if you ever sign back up (which means we have to keep your data), but we can really really delete it for your privacy if youre sure youre done here"
    - require captain password either way


# STI
- should tasks table be an STI table with types (task, challenge, training)

# User avatars
- Maybe instead of profile pictures there could be some kind of animated avatar
- Unlockable "skins" could be used as rewards
  - hats, shirts, accessories, pets, I dunno
- Unnecessary and you cant draw so you'd be paying for this

# Messages system
- When a user marks a task complete (changing its status to :pending_review), send a message to the captains/moderators to let them know they have a task to review
- When an captain/moderator has reviewed the task and marks it either complete, failed, or in progress, send a message to the user to let them know the new status of their task
  - If the task was marked complete by an captain/moderator, congratulate the user on a job well done and show them the reward they got for that task and their rewards balance
  - If the task was marked failed, let the user know the rewards they have missed out on and their current balance
  - If the task was changed back to in progress, let the user know they need to take another shot at it
  - Provide the ability for the captain/moderator to leave a custom message
    - back to inprogress example: "Almost finished the dishes but you forgot to start the machine"
    - marked failed example: "Didnt feed the dog and I already did it"

# Crews
- Since we have the concept of crews now, maybe we want members to be able to belong to other crews
  - User story: Pippa can belong to the crew at my house, but maybe Jessey's parents want to setup a crew and Pippa can belong there too
  - Need some kind of Crew select option
  - This would mean we'd need to allow crew owners to have and belong to multiple crews
- Crews should have the ability to have an avatar just like users and this should be displayed on the users nav bar
  - use the yellow house as a default
  - maybe that icon needs to change to something more crew like and less house like?
- Ability to edit crew name
- Crew#show
  - show members, captains etc.
  - stats on who is earning the most, completing the most chores, current rewards balances, etc.
