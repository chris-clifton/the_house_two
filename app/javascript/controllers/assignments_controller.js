import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assignments"
export default class extends Controller {

  // Send a PUT request to the Rails server that will update
  // the task's status to :pending_review
  // TODO: When we switch to using a state machine, we can probably change this
  //       action to something more generic and use one action for all changes
  //       to an assignment's status value.
  markComplete(event) {
    const assignmentId = event.target.dataset["assignmentId"];
    const url          = `/assignments/${assignmentId}/mark_complete`;
    const csrf         = document.querySelector("meta[name='csrf-token']").getAttribute("content");
    const params       = { user_id: event.target.dataset["currentUserId"] };

    fetch(url, {
      method: 'PUT',
      headers:  {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrf
      },
      body: JSON.stringify(params)
    }).then(response => response.json())
      .then(data => {
        // TODO: Target the flash_notices partial and get rid of this container
        const flashNoticeContainer = document.getElementById("assignment-show-message-container");

        if (!!data.error) {
          const html = `<div class="border-container-red"><i class="fas fa-exclamation-circle fa-lg"></i><span class="ml-2">${data.message}</span></div>`
          flashNoticeContainer.innerHTML = html; 
        } else {
          const html = `<div class="border-container-green"><i class="fas fa-bell"></i><span class="ml-2">${data.message}</span></div>`
          flashNoticeContainer.innerHTML = html;

          document.getElementById("status-container").innerHTML = 'Pending Review'

          document.getElementById("mark-complete-button").classList.add("hidden");
        }    
    });
  }
}
