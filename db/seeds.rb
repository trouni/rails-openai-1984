User.destroy_all

trouni = User.find_or_initialize_by(email: 'trouni@me.com')
trouni.update!(password: 123123)