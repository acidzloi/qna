module VoteHelpers
  def voted(model, author)
    if model.to_s == 'Answer'
      question = create(:question, user: author)
      create(model.to_s.underscore.to_sym, question: question, user: author)
    else
      create(model.to_s.underscore.to_sym, user: author)
    end
  end
end
