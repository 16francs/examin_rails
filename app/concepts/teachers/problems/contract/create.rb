# frozen_string_literal: true

class Teachers::Problems::Contract::Create < Teachers::Problems::Contract::Operate
  property :title
  property :content
  attr_accessor :tags

  validates :title,
            presence: true,
            length: { in: 1..31 },
            format: { with: VALID_VALUE_REGEX }
  validates :content,
            presence: true,
            length: { in: 1..63 }

  validate :tag_length
  validate :tags_size
  validate :unique_tags?

  private

  def tag_length
    tags.each do |tag|
      return errors.add(:tags, 'tag is 1..15') unless tag.size.between?(1, 15)
    end
  end

  def tags_size
    errors.add(:tags, 'tags size is less than 4') unless tags.size < 5
  end

  def unique_tags?
    errors.add(:tags, 'tags is not unique') unless tags.count - tags.uniq.count == 0
  end
end
