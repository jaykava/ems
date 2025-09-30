# app/controllers/employees_controller.rb
class EmployeesController < ApplicationController
  before_action :set_employee, only: [ :show, :edit, :update, :destroy, :toggle_status, :restore, :permanent_destroy ]

  def index
    @employees = Employee.active_employees
                        .search(params[:search])
                        .by_status(params[:status])
                        .order(:full_name)
                        .page(params[:page]).per(8)

    @total_employees = Employee.active_employees.count
    @active_count = Employee.active_employees.active.count
    @inactive_count = Employee.active_employees.inactive.count
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      redirect_to employees_path, notice: "Employee was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Employee was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.soft_delete!
    redirect_to employees_path, alert: "Employee was successfully deleted."
  end

  def toggle_status
    new_status = @employee.active? ? "inactive" : "active"
    @employee.update(status: new_status)
    redirect_to employees_path, notice: "Employee status changed to #{new_status}."
  end

  def restore
    @employee.restore!
    redirect_to permanent_destroy_employee_path, notice: "Employee was successfully restored."
  end

  def permanent_destroy
    if @employee.deleted?
      @employee.destroy
      redirect_to permanent_destroy_employee_path, alert: "Employee was permanenty deleted."
    end
  end

  def soft_deleted_employees
    @soft_deleted_employees = Employee.deleted_employees.order(:full_name).page(params[:page]).per(10)
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:full_name, :email, :phone, :position, :status)
  end
end
