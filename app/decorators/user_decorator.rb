class UserDecorator < Draper::Decorator
  delegate_all

  def resized_avatar
    avatar.variant(resize_to_fit: [ 200, 200 ]).processed
  end

  def resized_avatar_small
    avatar.variant(resize_to_fit: [ 40, 40 ]).processed
  end
end
