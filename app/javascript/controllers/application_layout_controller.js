import { Controller } from "@hotwired/stimulus"

import { enter, leave } from "el-transition"

// Connects to data-controller="application-layout"
export default class extends Controller {
  static targets = ["sideBar", "sideBarOverLay", "sideBarContainer", "button",
                    "offCanvasMobileMenu"]

  // When the buttonTarget is clicked, toggle the sidebar and use the el-transition
  // library to use the transitions set in the data-attributes for the sideBarTarget
  // and sideBarOverLayTarget
  toggleSideBar() {
    // Enter transition
    if (this.sideBarTarget.classList.contains("hidden")) {
      enter(this.sideBarTarget);
      enter(this.sideBarOverLayTarget);
      document.getElementById("off-canvas-mobile-menu").classList.remove("md:hidden")
    // Leave transition
    } else {
      leave(this.sideBarTarget);
      leave(this.sideBarOverLayTarget);
      document.getElementById("off-canvas-mobile-menu").classList.add("md:hidden")
    }
  }

  // For all elements of the nav-bar-element class, remove the active-nav-bar-element
  // class, apply the inactive-nav-bar-element class and then only re-apply the
  // active-nav-bar-element to the event target
  toggleActiveNavElement(e) {
    Array.from(document.getElementsByClassName("nav-bar-element")).forEach(function(item) {
      item.classList.remove("active-nav-bar-element");
      item.classList.add("inactive-nav-bar-element");
    });

    e.target.classList.remove("inactive-nav-bar-element");
    e.target.classList.add("active-nav-bar-element");
  }
}
