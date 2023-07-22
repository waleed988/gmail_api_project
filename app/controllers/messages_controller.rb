class MessagesController < ApplicationController
  require 'google/apis/gmail_v1'
  include ApplicationHelper

  def index
    @messages = Message.all.group_by{ |msg| msg.from }
    @keys = @messages.keys
  end
end
