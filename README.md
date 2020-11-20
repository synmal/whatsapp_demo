# Twlio Chat App Demo

## Setup
1. Clone repo
2. Run `bin/bundle install`
3. Run `rails db:create` and `rails db:migrate`
___
## Workers
`bundle exec sidekiq`
___
## Environment Variables
```
twilio:
  account_sid: Account SID from Twilio
  auth_token: Auth Token from Twilio
  whatsapp: 'whatsapp:{Whatsapp-capable number from Twilio}'
  sms: '{SMS-capable number from Twilio}'
  messenger: 'messenger:{Messenger Page ID linked to Twilio}'

tunnel: 'example.ngrok.io (For registering webhook for Whatsapp, SMS and Messenger)'
```
**Note**: All numbers must be in E.164 format
___
## Twilio Messenger
Messenger integration is not out of the box. You might need to add the channel from [Twilio Channels](https://www.twilio.com/console/channels).

After adding the Messenger channel, you need to login with Facebook and connect to your desired page to Twilio.

**Note:** Due to the messenger channel is still in beta, your page might not be able to link. When this happens, contact their support.

Be sure to add in your callback URL and status callback URL.
1. Callback URL - `POST /webhook/twilio`
2. Status Callback URL - `POST /webhook/twilio/status`
___
## Twilio Whatsapp
Whatsapp is already supported in Programmable SMS out of the box. You just need to have a Whatsapp-capable number.

After setting up, be sure add Callback URL and Status Callback URL in the Whatsapp settings.
1. Callback URL - `POST /webhook/twilio`
2. Status Callback URL - `POST /webhook/twilio/status`

### Whatsapp-Capable Numbers
You will need to request for it from [here](https://www.twilio.com/console/sms/whatsapp/senders).

## 24-hour window for Whatsapp & Messenger
### For Both
**24-hour window** - It's a window where Twilio able to send freeform text to the recipient. The window will be open whenever the recipient open a conversation. The window will closed 24 hours after the **last message sent by the recipient**.

### Whatsapp
Outside the 24-hour window, we will need to send using templates approved by Whatsapp. Template approval can be create by [this guide](https://www.twilio.com/docs/whatsapp/tutorial/send-whatsapp-notification-messages-templates#creating-message-templates-and-submitting-them-for-approval).

In this demo app, it will throw an error if you try to send a freeform text outside the 24 hour window. **Twilio gem will not raise an error if you do so**

In case of adding templates, please do so in `models/message.rb` and update tests in `spec/models/message_spec.rb`

## Message attachments
Twilio has impose restrictions for message attachments as listed [here](https://www.twilio.com/docs/sms/accepted-mime-types).

Maximum size of **one** attachment is 5MB.
___
## Test
`bundle exec rspec`