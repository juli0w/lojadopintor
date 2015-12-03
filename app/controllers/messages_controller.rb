class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      NotificationMailer.contact(@message).deliver
      redirect_to new_message_path, notice: "Obrigado por enviar sua mensagem!"
    else
      render :new
    end
  end

private

  def message_params
    params.require(:message).permit(:name, :email, :phone, :cellphone, :message)
  end
end
