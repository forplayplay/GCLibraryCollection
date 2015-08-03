class Loan < ActiveRecord::Base
  belongs_to :book
  belongs_to :user

  after_create :set_lending_info
  after_create :update_book_availability

  scope :active, -> { where(returned_date: nil) }
  scope :overdue, -> { active.where("due_date < ?", Date.today) }

  DURATION = 30
  MAX_RENEWALS = 2

  def return_loan
    update_attribute(:returned_date, Time.now.to_date)
  end

  def renew_loan
    if renewal_count < MAX_RENEWALS && !(user.do_not_lend) then
      update_attribute(:due_date, (due_date + DURATION))
      update_attribute(:renewal_count, ( renewal_count + 1 ) )
    else
      return false
    end
  end

  def overdue?
    active? && (due_date < Date.today)
  end

  def active?
    returned_date == nil
  end

  private

  def set_lending_info
    update_attribute(:start_date, Time.now.to_date) unless start_date
    update_attribute(:due_date, DURATION.days.from_now) unless due_date
    update_attribute(:renewal_count, 0) unless renewal_count
  end

  def update_book_availability
    book.update_availability
  end
end