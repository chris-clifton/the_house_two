import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assigned-chores"
export default class extends Controller {

  // Send a PUT request to the Rails server that will update
  // the chore's status to :pending_review
  markComplete(event) {
    const assignedChoreId = event.target.dataset["assignedChoreId"];
    const url             = `/assigned_chores/${assignedChoreId}/mark_complete`;
    const csrf            = document.querySelector("meta[name='csrf-token']").getAttribute("content");
    const params          = { user_id: event.target.dataset["currentUserId"] };

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
        const flashNoticeContainer = document.getElementById("assigned-chore-show-message-container");

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
