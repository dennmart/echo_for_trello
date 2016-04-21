$ ->
  $('.contact-form').validate
    rules:
      'name':
        required: true
      'email':
        required: true
        email: true
      'message':
        required: true
        minlength: 10
    messages:
      'name': 'Please enter your name'
      'email': 'Please enter a valid email address'
      'message': 'Please enter a message (at least 10 characters)'
    highlight: (elem) ->
      $(elem).parent('div').addClass('has-error')
    unhighlight: (elem) ->
      $(elem).parent('div').removeClass('has-error')
