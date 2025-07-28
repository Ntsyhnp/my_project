let Hooks = {}

Hooks.ScrollTo = {
  mounted() {
    this.handleEvent("scroll_to", ({ id }) => {
      const el = document.getElementById(id)
      if (el) el.scrollIntoView({ behavior: "smooth", block: "start" })
    })
  }
}

export default Hooks
