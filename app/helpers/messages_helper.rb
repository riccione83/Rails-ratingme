module MessagesHelper

public

    def send_test_message
        device_token = '1eefd403a33fa66e4aa119444c14be92ec87372a0a46b38508c95cfc640fe916'
        puts "Device token: " + device_token
    
        #APNS.send_notification(device_token, 'Hello iPhone!' )
        #APNS.send_notification(device_token, :alert => 'New login from website!', :badge => 1, :sound => 'default')
        APNS.send_notification(device_token, :alert => 'New login from website!', :badge => 1, :sound => 'default',
                                            :other => {:sent => 'new_login', :custom_param => "custom_id"})

        #n1 = APNS::Notification.new(device_token, 'Hello iPhone!' )
        #n2 = APNS::Notification.new(device_token, :alert => 'Hello iPhone!', :badge => 1, :sound => 'default')
        #APNS.send_notifications([n1, n2])
    
        puts "Message sent!"
    end
  
    def send_message_to_user(user, message, unreaded_messages)
        device_token = user.device_token
        if device_token != nil
           # APNS.send_notification(device_token, :alert => message, :badge => unreaded_messages, :sound => 'default')
            # =>,:other => {:sent => 'new_rating', :custom_param => id})
            puts "Message sent: " + message + " - to: " + user.user_name
        end
    end
    
    def new_message_for_user(user, message, long_text_message, notify)
        msg = user.messages.create
        msg.message = message
        msg.long_text = long_text_message
        msg.status = 0
        msg.save
        #send notification to user
        if notify == true
         #   send_message_to_user(user,message,user.messages.where(:status => 0).count)
        end
    end
end