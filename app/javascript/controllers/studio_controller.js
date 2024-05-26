import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Studio Controller Debugger:")
   
    const assemblyForm = document.getElementById("newAssemblyForm");
    const assemblyBtn = document.getElementById("designAssemblyButton");
    const designMapField = document.getElementById("designMap");

    const authorField = document.getElementById("assemblyAuthor");
    const titleField = document.getElementById("assemblyName");
    const volumeField = document.getElementById("assemblyVolume");
    const wellField = document.getElementById("assemblyWells");

    assemblyForm.addEventListener("submit", (e) => {
      e.preventDefault()
    });

    assemblyBtn.addEventListener("click", (e) => {
      if (authorField.value) {
        authorField.classList.add("is-valid");
        authorField.classList.remove("is-invalid");
      } else {
        authorField.classList.add("is-invalid");
        authorField.classList.remove("is-valid");
      }

      if (titleField.value) {
        titleField.classList.add("is-valid");
        titleField.classList.remove("is-invalid");
      } else {
        titleField.classList.add("is-invalid");
        titleField.classList.remove("is-valid");
      }

      if (designMapField.value) {
        designMapField.classList.add("is-valid");
        designMapField.classList.remove("is-invalid");
      } else {
        designMapField.classList.add("is-invalid");
        designMapField.classList.remove("is-valid");
      }

      if (authorField.value && titleField.value && designMapField.value ) {
            // allow request to go through
            assemblyForm.submit();
      }
    });


  }
}
