class LoadGmailMessages < ApplicationJob
    queue_as :default
  
    def perform()
      gmail = Google::Apis::GmailV1::GmailService.new
      client = ApplicationController.helpers.create_client()
      messages = ApplicationController.helpers.list_user_messages(gmail, client)
      messages.each do |message|
        mail = gmail.get_user_message('me', message.id)
        subject_header = mail.payload.headers.select{ |head| head.name == 'Subject' }.first&.value
        from_email = mail.payload.headers.select{ |head| head.name == 'From' }.first&.value
        to_email = mail.payload.headers.find { |header| header.name == 'To' }&.value
        cc_emails = mail.payload.headers.select { |header| header.name == 'Cc' }.map(&:value)
        Message.find_or_create_by(from: from_email, to: to_email, subject: subject_header, cc: cc_emails)
      end
    end
  end
  