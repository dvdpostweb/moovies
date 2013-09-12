class MessagesController < ApplicationController
  before_filter :authenticate_customer!, :unless => :faq?

  def show
    @message = current_customer.tickets.find(params[:id])
    @message.message_tickets.custer.collect do |message|
      message.update_attribute(:is_read, true)
    end
    
    if request.xhr?
      render :layout => false
    end
  end

  def index
    status = params[:filter] == Ticket.filter[:archive] ? true : false
    if params[:sort] && params[:sort].to_sym == :ticket
      @messages = current_customer.tickets.by_kind(status).ordered.paginate(:page => params[:page] || 1)
    else
      @messages = current_customer.tickets.by_kind(status).includes(:message_tickets, :category_ticket).order("message_tickets.id desc").paginate(:page => params[:page] || 1)
    end
  end

  def new
    @message = Ticket.new
    if request.xhr?
      @hide = 1;
      render :layout => false
    end
  end

  def create
    if !params[:message].empty?
      @ticket = Ticket.new(params[:ticket].merge(:customer_id => current_customer.to_param))
      @ticket.save
      variable = "$$$content$$$:::#{params[:message].gsub(/\n/, '<br />')};;;"
      if params[:add_on]
        variable += params[:add_on]
      end
      
      @message = MessageTicket.new(:ticket => @ticket, :mail_id => Moovies.email[:message_free], :data => variable)
      if @message.save
        flash[:notice] = t 'message.create.message_sent' #"Message sent successfully"
      
        respond_to do |format|
          format.html { redirect_to messages_path }
          format.js {@error = false}
        end
      else
        flash[:error] = t 'message.create.message_not_sent' # "Message not sent successfully"
        respond_to do |format|
          format.html {redirect_to messages_path}
          format.js {@error = true}
        end
      end
    else
      flash[:error] = t 'message.create.message_not_sent' # "Message not sent successfully"
      
      respond_to do |format|
        format.html {redirect_to messages_path}
        format.js {@error = true}
      end
    end
  end

  def faq
    @faqs = Faq.ordered.all
  end

  def destroy
    @message = current_customer.tickets.find(params[:id])
    @message.update_attribute(:remove, true)
    respond_to do |format|
      format.html {redirect_to messages_path}
      format.js   {render :status => :ok, :nothing => true}
    end
  end

  def urgent
    @offline_request = current_customer.payment.recovery
  end

  protected
  def faq?
    params[:action] == 'faq'
  end
end
