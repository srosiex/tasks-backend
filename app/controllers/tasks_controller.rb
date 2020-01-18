class TasksController < ApplicationController
    before_action :authenticate_user!
    
    def index
        tasks = current_user.tasks
        render json: tasks
    end

    def show
        task = Task.find(params[:id])
        authorize_owner_resource(task)
        render_resource(task, with: [:notes])
    end

    def create
        task = Task.new(task_params)
        task.user = current_user
        task.save
        render_resource(task)
    end

    def update
        task = Task.find(params[:id])
        authorize_owner_resource(task)
        task.update(task_params)
        render_resource(task)
    end 
    
    def destroy
        task = Task.find(params[:id])
        authorize_owner_resource(task)
        task.destroy
        render_resource(task)
    end

    private

    def task_params
        params.require(:task).permit(:content)
    end

end
