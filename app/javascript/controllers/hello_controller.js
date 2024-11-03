import { Controller } from "@hotwired/stimulus"
/* evento -> controller#método.
  data - nome_do_controller - target.

  // app/javascript/controllers/ola_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "texto" ]

  mudarTexto(event) {
    this.textoTarget.textContent = `olá, ${event.target.value}`
  }
} */
export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
