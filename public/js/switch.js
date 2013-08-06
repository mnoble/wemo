Switch = function(button) {
  this.button = $(button)
  this.light  = this.button.siblings(".light")
  this.state  = this.button.hasClass("on") ? "on" : "off"
  this.load()
}

Switch.prototype.load = function() {
  this.button.on("click", $.proxy(this.toggle, this))
}

Switch.prototype.toggle = function() {
  $.post(this.toggle_url(), $.proxy(this.update, this))
}

Switch.prototype.toggle_url = function() {
  return "/wemos/" + this.button.data("id") + "/" + this.toggle_state()
}

Switch.prototype.update = function(data, status) {
  if (status != "success") return;
  this["set_" + this.toggle_state()]()
}

Switch.prototype.toggle_state = function() {
  return this.state == "on" ? "off" : "on"
}

Switch.prototype.set_off = function() {
  this.state = "off"
  this.button.removeClass("on")
  this.light.removeClass("on")
}

Switch.prototype.set_on = function() {
  this.state = "on"
  this.button.addClass("on")
  this.light.addClass("on")
}
