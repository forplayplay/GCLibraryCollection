class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors
  has_many :contributions, through: :book_authors

  validates :name, uniqueness: true, presence: true

  after_create :sort_by_name

  def self.search(search)
    search_length = search.split.length
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }).order(:name)

  end

  def sort_by_name
    update_attribute(:sort_by, name.split(" ").last) unless sort_by
    return sort_by
  end
end
