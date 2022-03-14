import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
// https://www.sledgeworx.io/previewing-image-uploads-with-stimulus-js/
export default class extends Controller {
  static targets = [ "output", "input" ]

  // Handle rendering an image preview
  renderPreview() {
    let input = this.inputTarget
    let output = this.outputTarget

    let height = output.height;
    let width = output.width;

    if (input.files && input.files[0]) {
      let reader = new FileReader();

      reader.onload = function () {
        output.src = reader.result;
      }

      reader.readAsDataURL(input.files[0]);

      // Make sure the size is reset to whatever
      // size the original image was
      output.height = height;
      output.width = width;
    }
  }
}
