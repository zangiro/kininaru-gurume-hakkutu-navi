class PostDecorator < Draper::Decorator
  delegate_all

  def resized_main_image_small
    main_image.variant(resize_to_fill: [ 200, 200 ]).processed
  end

  def resized_main_image_large
    main_image.variant(resize_to_fit: [ 600, 600 ]).processed
  end

  def resized_sub_image_first_small
    sub_image_first.variant(resize_to_fill: [ 200, 200 ]).processed
  end

  def resized_sub_image_first_large
    sub_image_first.variant(resize_to_fit: [ 400, 400 ]).processed
  end

  def resized_sub_image_second_small
    sub_image_second.variant(resize_to_fill: [ 200, 200 ]).processed
  end

  def resized_sub_image_second_large
    sub_image_second.variant(resize_to_fit: [ 400, 400 ]).processed
  end

  #def resized_avatar
  #  avatar.variant(resize_to_fill: [200, 200]).processed
  #end
end
