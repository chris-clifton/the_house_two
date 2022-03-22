import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-status"
export default class extends Controller {
  static targets = ["modal", "overlay", "closeButton", "cancelButton", "updateButton", "radioButtonFieldSet"]

  static values = { 
    currentUserId: Number,
    assignmentId: Number,
    currentStatus: String
  }

  // If a user clicks the "Update Status" button, open the modal
  // If they click the "Cancel" button, the "X" button, or anywhere on the
  // modal overlay, close the modal then de-select all inputs and clear the
  // flash message from it.
  toggleModal() {
    if (this.modalTarget.classList.contains("hidden")) {
      this.modalTarget.classList.remove("hidden");
      this.selectCurrentStatus();
    } else { 
      this.modalTarget.classList.add("hidden");
      this.deselectAllInputs();
      this.clearFlashMessage();
    }
  }

  // When a user has clicked the "Submit" button, get the value of the selected
  // status, concatenate it to the URL so we can send a PUT request to the right
  // Rails action. Update the modal with a flash message once complete.
  submitUpdate() {
    const selectedStatus = document.querySelector('input[name = "selected-status"]:checked').value;
    const url          = `/assignments/${this.assignmentIdValue}/mark_${selectedStatus}`;
    const csrf         = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    fetch(url, {
      method: 'PUT',
      headers:  {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrf
      }
    }).then(response => response.json())
      .then(data => {
        const flashNoticeContainer = document.getElementById("update-status-modal-message-container");

        if (!!data.error) {
          const html = `<div class="border-container-red"><i class="fas fa-exclamation-circle fa-lg"></i><span class="ml-2">${data.message}</span></div>`
          flashNoticeContainer.innerHTML = html; 
        } else {
          const html = `<div class="border-container-green"><i class="fas fa-bell"></i><span class="ml-2">${data.message}</span></div>`
          flashNoticeContainer.innerHTML = html;

          // document.getElementById("status-container").innerHTML = 'Pending Review'

          // document.getElementById("mark-complete-button").classList.add("hidden");
        }    
    });
  }

  deselectAllInputs() {
    const radioButton = this.radioButtonFieldSetTarget.querySelector('input:checked');

    if (radioButton != null) {
      radioButton.checked = false;
    }
  }

  clearFlashMessage() {
    document.getElementById("update-status-modal-message-container").innerHTML = '';
  }

  selectCurrentStatus() {
    let radioToSelect = this.radioButtonFieldSetTarget.querySelector(`input[value=${this.currentStatusValue}`);
    radioToSelect.checked = true;
  }

  checkRadioButton() {
  }

  uncheckRadioButton() {
  }
}
