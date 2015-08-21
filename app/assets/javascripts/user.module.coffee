class UserForm extends Backbone.View
  initialize: ->
    #initializer
    supervisors = new Bloodhound
      datumTokenizer: Bloodhound.tokenizers.whitespace,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      local: $('.supervisor-selector').data('autocomplete')

    $('.supervisor-selector').typeahead({
      hint: true,
      highlight: true,
      minLength: 1
    },
    {
      name: 'supervisors',
      source: supervisors
    })

  events:
    'change input[name="user[first_name]"]': 'generateEmailAndFullName'
    'change input[name="user[last_name]"]': 'generateEmailAndFullName'

  generateEmailAndFullName: ->
    @generateEmail()
    @generateFullName()

  generateEmail: ->
    if @$('#user_first_name').prop('value') != "" && $('#user_last_name').prop('value') != "" 
      first_name = @$('#user_first_name').prop('value')
      last_name = @$('#user_last_name').prop('value')
      email = "#{first_name}.#{last_name}@originate.com".replace(/ /g, '').toLowerCase()
      @$('#user_email').prop 'value', email

  generateFullName: ->
    if @$('#user_first_name').prop('value') != "" && $('#user_last_name').prop('value') != "" 
      first_name = @$('#user_first_name').prop('value')
      last_name = @$('#user_last_name').prop('value')
      email = "#{first_name} #{last_name}"
      @$('#user_full_name').prop 'value', email

module.exports = UserForm
