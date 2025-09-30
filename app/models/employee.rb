# app/models/employee.rb
class Employee < ApplicationRecord
  # Status enum
  enum :status, { active: 0, inactive: 1 }

  # Scopes
  scope :active_employees, -> { where(deleted_at: nil) }
  scope :deleted_employees, -> { where.not(deleted_at: nil) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :search, ->(query) {
    if query.present?
      where("full_name ILIKE ? OR email ILIKE ? OR position ILIKE ?",
            "%#{query}%", "%#{query}%", "%#{query}%")
    end
  }

  # Validations
  validates :full_name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, format: { with: /\A[\+]?[0-9\-\(\)\s]+\z/ }
  validates :position, presence: true
  validates :status, inclusion: { in: statuses.keys }

  # Soft delete methods
  def soft_delete!
    update(deleted_at: Time.current)
  end

  def restore!
    update(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end

  def status_badge_class
    case status
    when "active"
      "success"
    when "inactive"
      "secondary"
    else
      "secondary"
    end
  end
end
