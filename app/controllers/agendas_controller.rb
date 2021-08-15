class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    # binding.irb
    unless @agenda.user == current_user || @agenda.team.owner_id == current_user.id
      binding.irb
      redirect_to dashboard_path and return
    end
    # binding.irb
    members = @agenda.team.members
    members.each do |member|
      AgendaMailer.delete_agenda_mail(member.email, member.password).deliver
    end
    binding.irb
    @agenda.destroy
    # binding.irb

    redirect_to dashboard_path
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
