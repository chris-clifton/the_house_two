# MVP
## Assignments
- CRUD Assignments
- Ability for captains to create chores (as a type of task) with a name and description
- Ability for captains to assign chores (as an assignment) to a user with a reward and consequence
- Ability for a user to view their assignments
- Ability for a user to mark their assignments as complete
  - An captain can either confirm its complete, mark it failed, or put it back to :in_progress
    - When complete, the assignment's reward value should be applied to the user's reward balance value and it should be hidden from the user's "My Chores" or "My Tasks" or whatever
    - When failed, the assignment's consequence value should be applied to the user somehow
      - Most likely need to set these up like tasks where they have a status such as "pending" or "complete/served"
      - captains should mark the consequence as complete/served and it should be removed from the user's "My Consequences"
    - When put back to in progress, allow the user to try completing the task again
- Write tests

## Tasks
- CRUD Tasks
- Figure out if we want to do enum for task type or STI
- Task types should be Chore, Challenge, and possibly Training
  - Chores should have a Reward and a Consequence- these are obligatory but you still get something for completing them
  - Challenges should have a Reward but not a Consequence- these are basically "bonus" chores that allow the user to earn a little extra cash for helping out in an "above and beyond" way
  - Training I dont think needs a Reward and definitely not a Consequence, and should unlock either a Chore or Challenge that the user can now complete to earn rewards

## Rewards
- CRUD Rewards
- Users should be able to see their current rewards balance, the rewards they have the opportunity to earn (open chores) and the rewards they have missed out on (failed chores)
- captains should be able to "deduct" from the users rewards balance (user cashed in their rewards outside the app)
- captains should be able to "add" to the users rewards balance

## Organizations
- CRUD Organizations
- However we want to name these, we need to refactor the current setup to allow for more than one group of users (household, family, etc.)

# Phase Two
# Assignments
- Allow an captain to include a note when they update an assignment's status
  - Probably need to get rid of the 'note' column on assignments and create a table to store these in so there can be multiple notes for an assignment
  - Or should this stay there so we can add special notes for a specific assignment?
    - i.e.: assignment = feed the dog breakfast, special note = we are out of his regular food, use two cups of the other dogs food instead
## Training and Challenges
- CRUD Training
- CRUD Challenges
- Trainings should either be a set of instructions for how to complete either a new Chore or new Challenge or, if more hands-on training is required, some sort of notice that you must receive Training from one of the captains or moderators
- Once a user has marked their training as complete, it should be reviewable by captains the same way chores are
- When an captain has approved the user's training, it should be unlocked/available to them as an assignable chore or challenge
  - Will need to figure out which users are allowed to be assigned which chores/challenges depending on whether theyve completed training on it
  - Maybe a join table between users and training that has a user id, chore/challenge id, status enum and users can only be assigned chores/challenges where their training has been complete

## Consequences
- CRUD Consequences
- When an captain marks a chore as failed, a consequence record should be created and associated with the user
- It should have three states (in progress, pending review, complete)
- A user should be able to mark their consequence as having "been served" which an captain will approve
- Right now consequences are setup with a value, category, and duration but maybe they should just have the option of deducting rewards points and/or a message like "30 minutes screentime" or "now you gotta walk the dog, too" or something like that which doesnt fit the rigid database structure we have currently

## Milestones
- CRUD Milestones
- Some system where additional rewards are applied when a user has completed a chore X number of times
- Do the Dishes (3/10) for example
- When a user completes the first 10 milestone, automatically give them another one for 25 or something like that
