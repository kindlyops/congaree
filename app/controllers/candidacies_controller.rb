class CandidaciesController < ApplicationController
  decorates_assigned :candidacies

  def index
    @candidacies = found_candidacies

    respond_to do |format|
      format.json
      format.csv { @filename = filename }
    end
  end

  private

  def found_candidacies
    if params[:search].present?
      selected(paginate(policy_scope(PgSearch.multisearch(params[:search])))).map { |c| c.person.candidacy }
    else
      selected(paginate(ordered_candidacies))
    end
  end

  def filename
    "candidacies-#{DateTime.current.to_i}.csv"
  end

  def paginate(scope)
    if params[:offset].present? && params[:limit].present?
      scope.page(page).per(limit)
    else
      scope
    end
  end

  def selected(scope)
    if params[:id].present?
      scope.where(id: params[:id])
    else
      scope
    end
  end

  def ordered_candidacies
    policy_scope(Candidacy).joins(person: :contacts).order(order)
  end

  def limit
    params[:limit].to_i
  end

  def offset
    params[:offset].to_i
  end

  def page
    offset / limit
  end

  def direction
    params[:order]
  end

  def order
    return { id: :asc } unless params[:sort].present?
    return { id: :asc } unless whitelist_orders[params[:sort]].present?
    "#{whitelist_orders[params[:sort]]}#{stabilizer}"
  end

  def stabilizer
    ',id ASC'
  end

  def whitelist_orders
    {
      'zipcode' => "zipcode #{direction}",
      'contact' =>  "people.phone_number #{direction}",
      'availability' => "availability #{direction}",
      'experience' => "experience #{direction}",
      'qualifications' => "certification #{direction}",
      'status' => "contacts.subscribed #{direction}",
      'screened' => "contacts.screened #{direction}"
    }
  end
end
