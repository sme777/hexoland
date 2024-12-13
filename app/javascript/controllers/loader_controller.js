import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

    const uploadFile = async (file, type) => {
        const formData = new FormData();
        formData.append('file', file);
      
        try {
          const response = await fetch('/studio/loader', {
            method: 'POST',
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'), // Include CSRF token
            },
            body: formData,
          });
      
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
      
          const data = await response.json();
          // update the EDITOR

          editor.update({ json: data });
        } catch (error) {
          console.error('Error uploading file:', error);
        }
      };
      
      // Attach event listener to file input
      document.getElementById('sequenceLoader').addEventListener('change', (event) => {
        const file = event.target.files[0];
        if (file) {
          uploadFile(file, "sequence");
        }
      });
  }
}
