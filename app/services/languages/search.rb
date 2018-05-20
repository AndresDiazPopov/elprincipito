class Languages::Search

  def self.call(state: nil)

    languages = Language.all

    # Search by state
    languages = languages.where(state: Language.states[state]) if state
    
    languages.uniq
  end

end
