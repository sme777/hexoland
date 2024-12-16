import {
    Controller
  } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap";

export default class extends Controller {
    connect() {
        const toastLiveExample = document.getElementById('liveToast');
        const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toastLiveExample);
        toastBootstrap.show();
    }
}