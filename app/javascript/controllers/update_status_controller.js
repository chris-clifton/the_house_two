import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="update-status"
export default class extends Controller {
  static targets = [
    "captainModal",
    "memberModal",
    "overlay",
    "closeButton",
    "cancelButton",
    "updateButton",
    "radioButtonFieldSet",
    "memberModalBodyContainer",
    "memberModalSuccessBodyContainer",
    "memberMarkCompleteButton"
  ]

  static values = {
    currentMemberId: Number,
    assignmentId: Number,
    currentStatus: String
  }

  // If a captain clicks the "Update Status" button, open the modal
  // If they click the "Cancel" button, the "X" button, or anywhere on the
  // modal overlay, close the modal then de-select all inputs and clear the
  // flash message from it.
  toggleCaptainModal() {
    if (this.captainModalTarget.classList.contains("hidden")) {
      this.captainModalTarget.classList.remove("hidden");
      this.selectCurrentStatus();
    } else {
      this.captainModalTarget.classList.add("hidden");
      this.deselectAllInputs();
      this.clearFlashMessage();
    }
  }

  // When a member clicks the "Mark Complete" button, open the modal which
  // allows the member to change the Assignment's status to "pending_review".
  // If they click the Cancel button, the X in the corner, or the modal overlay
  // then close the modal.
  toggleMemberModal() {
    if (this.memberModalTarget.classList.contains("hidden")) {
      this.memberModalTarget.classList.remove("hidden");
    } else {
      this.memberModalTarget.classList.add("hidden");
      this.clearFlashMessage();
    }
  }

  // When a Captain has clicked the "Submit" button, get the value of the selected
  // status. If the assignment is already in that state, let the user know, and
  // return early. Else, concatenate the selected status to the URL so we can send
  // a PUT request to the right Rails action. Update the modal with a flash message
  // once complete.
  captainSubmitUpdate() {
    const flashNoticeContainer = document.getElementById("update-status-modal-message-container");
    const selectedStatus = document.querySelector('input[name = "selected-status"]:checked').value;

    if(selectedStatus === this.currentStatusValue) {
      let message = `This chore is already in the state '${this.humanize(selectedStatus)}'`;
      let html = `<div class="border-container-yellow"><i class="fas fa-exclamation-circle fa-lg"></i><span class="ml-2">${message}</span></div>`;
      flashNoticeContainer.innerHTML = html;
      return;
    }

    const url = `/assignments/${this.assignmentIdValue}/mark_${selectedStatus}`;
    const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    fetch(url, {
      method: 'PUT',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrf
      }
    }).then(response => response.json()).then(data => {
      if (!!data.error) {
        const html = `<div class="border-container-red"><i class="fas fa-exclamation-circle fa-lg"></i><span class="ml-2">${data.message}</span></div>`
        flashNoticeContainer.innerHTML = html;
      } else {
        const html = `<div class="border-container-green"><i class="fas fa-bell"></i><span class="ml-2">${data.message}</span></div>`
        flashNoticeContainer.innerHTML = html;

        // Update the view's status container and set the data attribute for currentStatusValue
        document.getElementById("status-container").innerHTML = this.humanize(selectedStatus);
        document.getElementById("update-status-buttons-container").setAttribute("data-update-status-current-status-value", selectedStatus)
      }
    });
  }

  // Send a PUT request to the Rails controller to update the status of this
  // assignment to 'pending_review'. On success, update the modal by showing
  // the success body container and hiding the original modal body.
  memberMarkComplete() {
    const selectedStatus = 'pending_review';
    const url = `/assignments/${this.assignmentIdValue}/mark_pending_review`;
    const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

    fetch(url, {
      method: 'PUT',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrf
      }
    }).then(response => response.json()).then(data => {
      const flashNoticeContainer = document.getElementById("update-status-modal-message-container");

      if (!!data.error) {
        const html = `<div class="border-container-red"><i class="fas fa-exclamation-circle fa-lg"></i><span class="ml-2">${data.message}</span></div>`
        flashNoticeContainer.innerHTML = html;
      } else {
        // Update the view's status container and set the data attribute for currentStatusValue
        document.getElementById("status-container").innerHTML = this.humanize(selectedStatus);
        document.getElementById("update-status-buttons-container").setAttribute("data-update-status-current-status-value", selectedStatus);

        this.memberModalBodyContainerTarget.innerHTML = "";
        this.memberModalSuccessBodyContainerTarget.classList.remove("hidden");
        this.memberMarkCompleteButtonTarget.classList.add("hidden");
      }
    });
  }

  // Find all radio button inputs and make sure they have been deselected
  deselectAllInputs() {
    const radioButton = this.radioButtonFieldSetTarget.querySelector('input:checked');

    if (radioButton != null) {
      radioButton.checked = false;
    }
  }

  // Remove the innerHTML from the modal message container
  clearFlashMessage() {
    document.getElementById("update-status-modal-message-container").innerHTML = '';
  }

  // Find the radio button for whichever state the assignment's status is
  // currently in and make sure it is checked
  selectCurrentStatus() {
    let radioToSelect = this.radioButtonFieldSetTarget.querySelector(`input[value=${this.currentStatusValue}`);
    radioToSelect.checked = true;
  }

  // TODO: Figure out how Stimulus controller inheritance works in Rails 7 and move this
  //       to something like an application_controller.js so we can use this
  //       in other Stimulus controllers
  //       From DHH: https://github.com/hotwired/stimulus-rails/issues/78
  // Humanize a string to replace underscores with whitespace
  // and capitalize the first letter of the first word
  humanize(str) {
    return str
      .replace(/^[\s_]+|[\s_]+$/g, '')
      .replace(/[_\s]+/g, ' ')
      .replace(/^[a-z]/, function(m) { return m.toUpperCase(); });
  }
}
