class PostDecorator < Draper::Decorator
  delegate_all

  def resized_main_image_for_index
    main_image.variant(resize_to_fill: [200, 200]).processed
  end

  def resized_main_image_for_show
    main_image.variant(resize_to_fit: [600, 600]).processed
  end

  def resized_sub_image_first_for_index
    sub_image_first.variant(resize_to_fill: [200, 200]).processed
  end

  def resized_sub_image_first_for_show
    sub_image_first.variant(resize_to_fit: [400, 400]).processed
  end

  def resized_sub_image_second_for_index
    sub_image_second.variant(resize_to_fill: [200, 200]).processed
  end

  def resized_sub_image_second_for_show
    sub_image_second.variant(resize_to_fit: [400, 400]).processed
  end

end
#  post.decorated.resized_main_image_for_show
#  post.decorated.resized_sub_image_first_for_show
#  post.decorated.resized_sub_image_second_for_show