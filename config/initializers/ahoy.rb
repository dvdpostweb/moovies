class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore

  def user
    controller.current_customer
  end

  #def track_visit(options)
  #    super do |visit|
  #      visit.gclid = visit_properties.landing_params["gclid"]
  #    end
  #  end

  #  def track_event(name, properties, options)
  #    super do |event|
  #      event.ip = request.ip
  #    end
  #  end

end
