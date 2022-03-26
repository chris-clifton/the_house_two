# MVP
## Assignments
- CRUD Assignments
- Ability for captains to create chores (as a type of task) with a name and description
- Ability for captains to assign chores (as an assignment) to a member with a reward and consequence
- Ability for a member to view their assignments
- Ability for a member to mark their assignments as complete
  - A captain can either confirm its complete, mark it failed, or put it back to :in_progress
    - When complete, the assignment's reward value should be applied to the member's reward balance value and it should be hidden from the member's "My Chores" or "My Tasks" or whatever
    - When failed, the assignment's consequence value should be applied to the member somehow
      - Most likely need to set these up like tasks where they have a status such as "pending" or "complete/served"
      - captains should mark the consequence as complete/served and it should be removed from the member's "My Consequences"
    - When put back to in progress, allow the member to try completing the task again
- Write tests
- There should be a history log of some sort, with at least the statuses that affect a members rewards points.
  - At such and such time, member was awarded x points or lost x points because of completion/failure of task y.
- Assignments should be one-time or recurring.

## Tasks
- CRUD Tasks
- Figure out if we want to do enum for task type or STI
- Task types should be Chore, Challenge, and possibly Training
  - Chores should have a Reward and a Consequence- these are obligatory but you still get something for completing them
  - Challenges should have a Reward but not a Consequence- these are basically "bonus" chores that allow the member to earn a little extra cash for helping out in an "above and beyond" way
  - Training I dont think needs a Reward and definitely not a Consequence, and should unlock either a Chore or Challenge that the member can now complete to earn rewards

## Rewards
- CRUD Rewards
- members should be able to see their current rewards balance, the rewards they have the opportunity to earn (open chores) and the rewards they have missed out on (failed chores)
- captains should be able to "deduct" from the members rewards balance (member cashed in their rewards outside the app)
- captains should be able to "add" to the members rewards balance

## Organizations
- CRUD Organizations
- However we want to name these, we need to refactor the current setup to allow for more than one group of members (household, family, etc.)
- When creating a user account, maybe have a wizard that takes the new user to setting up their crew, adding their first task, etc. Maybe the wizard is overkill. Maybe just after signup, you dump them at their admin page where they can start setting things up, or maybe have a 'take a tour' feature to help them get started.
  - https://gist.github.com/tomciopp/2847246
  - https://github.com/zombocom/wicked

# Phase Two
# Assignments
- Allow a captain to include a note when they update an assignment's status
  - Probably need to get rid of the 'note' column on assignments and create a table to store these in so there can be multiple notes for an assignment. I think a single note is probably fine for assignments.
  - Or should this stay there so we can add special notes for a specific assignment?
    - i.e.: assignment = feed the dog breakfast, special note = we are out of his regular food, use two cups of the other dogs food instead
- If an assignment is failed, can it be put back into the pool so another kid can pick it up? Or do we want to force the one kid to learn to do the thing the right way? Maybe only challenges are reassignable.
- Assignments should have due date/times. Maybe notifications/alerts get sent out as reminders an hour before the task is due?
- For recurring assignments, give ability to rotate between members.
## Training and Challenges
- CRUD Training
- CRUD Challenges
- Trainings should either be a set of instructions for how to complete either a new Chore or new Challenge or, if more hands-on training is required, some sort of notice that you must receive Training from one of the captains or moderators
- Once a member has marked their they have completed training, it should be marked pending_reviews and is reviewable by captains the same way chores are.
- When a captain has approved the member's training, it should be unlocked/available to them as an assignable chore or challenge
  - Will need to figure out which members are allowed to be assigned which chores/challenges depending on whether they've completed training on it
  - Maybe a join table between members and training that has a member id, chore/challenge id, status enum and members can only be assigned chores/challenges where their training has been complete

## Consequences
- CRUD Consequences
- When a captain marks a chore as failed, a consequence record should be created and associated with the member
- It should have three states (in progress, pending review, complete)
- A member should be able to mark their consequence as having "been served" which a captain will approve
- Right now consequences are setup with a value, category, and duration but maybe they should just have the option of deducting rewards points and/or a message like "30 minutes screentime" or "now you gotta walk the dog, too" or something like that which doesn't fit the rigid database structure we have currently

## Milestones
- CRUD Milestones
- Some system where additional rewards are applied when a member has completed a chore X number of times
- Do the Dishes (3/10) for example
- When a member completes the first 10 milestone, automatically give them another one for 25 or something like that
