class UserForm extends Backbone.View
  initialize: ->
    #initializer

  events:
    'change input[name="user[first_name]"]': 'generateEmail'
    'change input[name="user[last_name]"]': 'generateEmail'

  generateEmail: ->
    if @$('#user_first_name').prop('value') != "" && $('#user_last_name').prop('value') != "" 
      first_name = @$('#user_first_name').prop('value')
      last_name = @$('#user_last_name').prop('value')
      email = "#{first_name}.#{last_name}@originate.com".replace(/ /g, '').toLowerCase()
      @$('#user_email').prop 'value', email

module.exports = UserForm
