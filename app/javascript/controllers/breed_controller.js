import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["breed"];

  fetchBreed(event) {
    event.preventDefault(); // Prevent default form submission behavior
    const breedName = this.breedTarget.value.trim();
    const errorMessage = document.getElementById('error-message');

    if (breedName === "") {
      errorMessage.textContent = "Please enter a breed name.";
      return;
    }

    errorMessage.textContent = ""; // Clear previous errors

    const csrfToken = document.querySelector("[name='csrf-token']").getAttribute('content');
    fetch('/fetch_breed', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ breed: breedName })
    })
    .then(response => {
      if (!response.ok) throw new Error('Network response was not ok.');
      return response.json();
    })
    .then(data => {
      document.getElementById('dogImage').innerHTML = `<img src="${data.image_url}" class="img-fluid" alt="Image of ${breedName}">`;
      document.getElementById('breedName').textContent = `Breed: ${breedName}`;
    })
    .catch(error => {
      document.getElementById('error-message').textContent = "Failed to fetch breed data.";
      console.error('There has been a problem with your fetch operation:', error);
    });
  }
}
