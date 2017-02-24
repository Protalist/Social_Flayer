class AdminsController < ApplicationController
    def homeadmin
      @reports = Report.all
    end

    def show_report
    end

    def report
      if User.where(id: params[:id]).exists?
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
    end

    private

    def report_params
      params.require(:report).permit(:motivation)
    end
end
