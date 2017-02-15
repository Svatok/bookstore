class ProductAuthorsDecorator < Draper::Decorator

  def all_authors
    authors_names = ''
    return authors_names unless object.authors.present?
    object.authors.each_with_index do |author, i|
      authors_names += ', ' if i.nonzero?
      authors_names += author.first_name + ' ' + author.last_name
    end
    authors_names
  end

end
