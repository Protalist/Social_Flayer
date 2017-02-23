class Report < ApplicationRecord
  belongs_to :reported, class_name: "User", foreign_key: "user.id"
  belongs_to :reporter, class_name: "User", foreign_key: "user.id"

  validates :reported_id , presence: true
  validates :reporter_id , presence: true
  validates_uniqueness_of :reporter_id, :scope => :reported_id
  validate :differente

  private
  def differente
    if (reporter_id==reported_id)
      errors.add(:different,("non puoi reportare te stesso a meno che tu non voglia essere reportato"))
    end
  end

end
