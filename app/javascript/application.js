import { Application } from "@hotwired/stimulus"
import breed_controller from "./controllers/breed_controller"
window.Stimulus = Application.start();
Stimulus.register("breed", breed_controller);
