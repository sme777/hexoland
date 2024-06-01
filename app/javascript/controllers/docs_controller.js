import { Controller } from "@hotwired/stimulus"
import hljs from 'highlight.js';
import javascript from 'highlight.js/lib/languages/javascript';

export default class extends Controller {
  connect() {
    hljs.registerLanguage('javascript', javascript);
    const jsonData = {
        "name": "John Doe", "age": 30,
        "email": "john.doe@example.com",
        "address": {
            "street": "123 Main St",
            "city": "Anytown",
            "state": "CA",
            "zip": "12345"
        }
    };

    // Stringify and pretty-print the JSON data
    const prettyJson = JSON.stringify(jsonData, null, 2);

    // Set the pretty JSON to the container
    document.getElementById('preCode').textContent = prettyJson;

    // Initialize Highlight.js
    hljs.highlightAll({ language: 'javascript' });

    
  }
}
