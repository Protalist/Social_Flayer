class AdminsController < ApplicationController
    before_action :authorize , :except => [:show_report,:report]

    def homeadmin
      @reports = Report.all
    end

    def show_report
        authorize! :show_report, User
    end

    def report
      if User.where(id: params[:id]).exists?
        authorize! :report, User.find(params[:id])
        report=Report.new(report_params)
        report.reported_id=params[:id]
        report.reporter_id=current_user.id
        if report.save
          flash[:alert]="report inviato"
        else
          flash[:alert]="report non riuscito"
        end
        redirect_to user_path(params[:id])
      else
        redirect_to root_path, :alert => "non esiste questo utente"
      end
    end

    def show_ban
      @ban=Report.where(reported_id: params[:id])
    end

    def send_ban
      if Report.where(reported_id: params[:id]).exists?
        day=params.require(:ban).permit(:day)
        day=day[:day].to_i
        if day >0
          data=Time.now()+day.day
          User.find(params[:id]).update(ban: data.to_i)
        elsif day < 0
          User.find(params[:id]).update(ban: day)
        else
        end
        Report.where(reported_id: params[:id]).destroy_all
      else
        flash[:alert]="non esiste il report"
      end
      redirect_to admin_path
    end

    private
    def authorize
      authorize! :admin, User
    end

    def report_params
      params.require(:report).permit(:motivation)
    end
end
