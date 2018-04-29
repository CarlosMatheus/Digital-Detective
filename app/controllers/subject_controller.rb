class SubjectController < ApplicationController

  def index

    subjects = Subject.all # Subject.where(id:
    #  WildNew.all.count('*').group(:subject_id).order('count DESC').pluck(:subject_id))

    render locals: {
      subjects: subjects
    }
  end

end
