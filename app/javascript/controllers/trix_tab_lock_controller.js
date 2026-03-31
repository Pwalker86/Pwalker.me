import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  lockTab(event) {
    if (event.key !== "Tab") return
    if (event.altKey || event.ctrlKey || event.metaKey) return
    if (!this.element.contains(document.activeElement)) return

    event.preventDefault()
  }
}
