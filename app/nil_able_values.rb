require 'dry/monads/maybe'
require 'dry/monads/result'
require 'dry/monads/do'

require './lib/channel/channel'
require './lib/channel/discussion'
require './lib/channel/user'

M = Dry::Monads

user1 = Channel::User.new(email: 'max@gmail.com', role: 'user')
user2 = Channel::User.new(email: 'bob@gmail.com', role: 'user')
user3 = Channel::User.new(email: 'john@gmail.com', role: 'user')

admin1 = Channel::User.new(email: 'ivan@gmail.com', role: 'admin')
admin2 = Channel::User.new(email: 'misha@gmail.com', role: 'admin')
admin3 = Channel::User.new(email: 'fedor@gmail.com', role: 'admin')

discussion1 = Channel::Discussion.new(title: 'Stuff', users: [user1, user2, admin1, admin2])
discussion2 = Channel::Discussion.new(title: 'Activities', users: [user2, user3, admin3, admin1])
discussion3 = Channel::Discussion.new(title: 'Health', users: [user1, user2, user3])

channel = Channel::Channel.new(discussions: [discussion1, discussion2, discussion3], admin: admin1)

def discussion_admin_email(channel, discussion_title)
  found_discussion = channel.discussions.find do |discussion|
    discussion.title.casecmp(discussion_title).zero?
  end

  return channel.admin.email unless found_discussion

  admin = found_discussion.users.find { |user| user.role == 'admin' }

  return channel.admin.email unless admin

  admin.email
end

def discussion_admin_email_with_monad(channel, discussion_title)
  (M.Maybe(channel.discussions.find { |discussion| discussion.title.casecmp(discussion_title).zero? }).bind do |discussion|
    M.Maybe(discussion.users.find { |user| user.role == 'admin' }).bind do |admin|
      M.Maybe(admin.email)
    end
  end).value_or(channel.admin.email)
end

class DiscussionAdminEmailWithDoNotation
  include Dry::Monads::Result::Mixin
  include Dry::Monads::Do.for(:discussion_admin_email)

  def call(channel, discussion_title)
    discussion_admin_email(channel, discussion_title).value_or(channel.admin.email)
  end

  private

  def discussion_admin_email(channel, discussion_title)
    discussion = yield M.Maybe(channel.discussions.find { |discussion| discussion.title.casecmp(discussion_title).zero? })
    admin = yield M.Maybe(discussion.users.find { |user| user.role == 'admin' })
    M.Maybe(admin.email)
  end
end

p discussion_admin_email(channel, 'Activities')
p discussion_admin_email(channel, 'Health')
p discussion_admin_email(channel, 'Money')

p discussion_admin_email_with_monad(channel, 'Activities')
p discussion_admin_email_with_monad(channel, 'Health')
p discussion_admin_email_with_monad(channel, 'Money')

p DiscussionAdminEmailWithDoNotation.new.(channel, 'Activities')
p DiscussionAdminEmailWithDoNotation.new.(channel, 'Health')
p DiscussionAdminEmailWithDoNotation.new.(channel, 'Money')
