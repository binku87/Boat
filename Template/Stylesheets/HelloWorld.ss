// Shared
text_input_wrap:
    width: win_width * 0.9
    height: 46
    left: (win_width - width) / 2
    font-size: 22

// UI
title:
    font-size: 50
    left: (win_width - width) / 2
    top: win_width * 0.25
    color: rgb(56, 146, 227)

text_input_name_wrap:
    inherit: text_input_wrap
    width: win_width * 0.9
    height: 46
    font-size: 22
    left: (win_width - width) / 2
    top: title.bottom + 5

text_input_name_icon:
    relative: text_input_name_wrap
    width: 20
    height: 20
    left: 15
    top: (text_input_name_wrap.height - height) / 2

text_input_name:
    relative: text_input_name_wrap
    width: text_input_name_wrap.width - text_input_name_icon.right - 10
    height: (text_input_name_wrap.height - 4) / 2
    left: text_input_name_icon.right - text_input_name_wrap.left + 10
    top: (text_input_name_wrap.height - height) / 2

text_input_password_wrap:
    width: win_width * 0.9
    height: 46
    font-size: 22
    left: (win_width - width) / 2
    top: text_input_name_wrap.bottom + 5

text_input_password_icon:
    relative: text_input_password_wrap
    width: 20
    height: 20
    left: 15
    top: (text_input_password_wrap.height - height) / 2

text_input_password:
    relative: text_input_password_wrap
    width: text_input_password_wrap.width - text_input_password_icon.right - 10
    height: (text_input_password_wrap.height - 4) / 2
    left: text_input_password_icon.right - text_input_password_wrap.left + 10
    top: (text_input_password_wrap.height - height) / 2

login_button:
    width: 135
    height: 42
    top: text_input_password_wrap.bottom + 5
    left: text_input_password_wrap.left

register_button:
    width: 135
    height: 42
    top: text_input_password_wrap.bottom + 5
    left: text_input_password_wrap.right - width
